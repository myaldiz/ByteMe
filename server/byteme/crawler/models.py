#from pytrends.request import TrendReq
#from django.db import models
import threading, time, queue

import requests
from bs4 import BeautifulSoup

import os
import random
import sys
import time
import math
from http.cookiejar import LWPCookieJar
from urllib.request import Request, urlopen
from urllib.parse import quote_plus, urlparse, parse_qs
from events.tag import Tag

try:
    from bs4 import BeautifulSoup
    is_bs4 = True
except ImportError:
    from BeautifulSoup import BeautifulSoup
    is_bs4 = False


class GoogleSearch:
    # URL templates to make Google searches.
    url_home = "https://www.google.%(tld)s/"
    url_search = "https://www.google.%(tld)s/search?hl=%(lang)s&q=%(query)s&" \
                "btnG=Google+Search&tbs=%(tbs)s&safe=%(safe)s&tbm=%(tpe)s"
    url_next_page = "https://www.google.%(tld)s/search?hl=%(lang)s&q=%(query)s&" \
                    "start=%(start)d&tbs=%(tbs)s&safe=%(safe)s&tbm=%(tpe)s"
    url_search_num = "https://www.google.%(tld)s/search?hl=%(lang)s&q=%(query)s&" \
                    "num=%(num)d&btnG=Google+Search&tbs=%(tbs)s&safe=%(safe)s&" \
                    "tbm=%(tpe)s"
    url_next_page_num = "https://www.google.%(tld)s/search?hl=%(lang)s&" \
                        "q=%(query)s&num=%(num)d&start=%(start)d&tbs=%(tbs)s&" \
                        "safe=%(safe)s&tbm=%(tpe)s"

    # Cookie jar. Stored at the user's home folder.
    home_folder = os.getenv('HOME')
    if not home_folder:
        home_folder = os.getenv('USERHOME')
        if not home_folder:
            home_folder = '.'   # Use the current folder on error.
    cookie_jar = LWPCookieJar(os.path.join(home_folder, '.google-cookie'))
    try:
        cookie_jar.load()
    except Exception:
        pass

    # Default user agent, unless instructed by the user to change it.
    USER_AGENT = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0)'

    # Load the list of valid user agents from the install folder.
    try:
        install_folder = os.path.abspath(os.path.split(__file__)[0])
        try:
            user_agents_file = os.path.join(install_folder, 'user_agents.txt.gz')
            import gzip
            fp = gzip.open(user_agents_file, 'rb')
            try:
                user_agents_list = [_.strip() for _ in fp.readlines()]
            finally:
                fp.close()
                del fp
        except Exception:
            user_agents_file = os.path.join(install_folder, 'user_agents.txt')
            with open(user_agents_file) as fp:
                user_agents_list = [_.strip() for _ in fp.readlines()]
    except Exception:
        user_agents_list = [USER_AGENT]

    # Get a random user agent.
    def get_random_user_agent(self):
        """
        Get a random user agent string.
        :rtype: str
        :return: Random user agent string.
        """
        return random.choice(self.user_agents_list)


    # Request the given URL and return the response page, using the cookie jar.
    def get_page(self, url, user_agent=None):
        """
        Request the given URL and return the response page, using the cookie jar.
        :param str url: URL to retrieve.
        :param str user_agent: User agent for the HTTP requests.
            Use None for the default.
        :rtype: str
        :return: Web page retrieved for the given URL.
        :raises IOError: An exception is raised on error.
        :raises urllib2.URLError: An exception is raised on error.
        :raises urllib2.HTTPError: An exception is raised on error.
        """
        if user_agent is None:
            user_agent = self.USER_AGENT
        request = Request(url)
        request.add_header('User-Agent', self.USER_AGENT)
        self.cookie_jar.add_cookie_header(request)
        response = urlopen(request)
        self.cookie_jar.extract_cookies(response, request)
        html = response.read()
        response.close()
        try:
            self.cookie_jar.save()
        except Exception:
            pass
        return html


    # Filter links found in the Google result pages HTML code.
    # Returns None if the link doesn't yield a valid result.
    def filter_result(self, link):
        try:

            # Valid results are absolute URLs not pointing to a Google domain
            # like images.google.com or googleusercontent.com
            o = urlparse(link, 'http')
            if o.netloc:
                return link

            # Decode hidden URLs.
            if link.startswith('/url?'):
                link = parse_qs(o.query)['q'][0]

                # Valid results are absolute URLs not pointing to a Google domain
                # like images.google.com or googleusercontent.com
                o = urlparse(link, 'http')
                if o.netloc:
                    return link

        # Otherwise, or on error, return None.
        except Exception:
            pass
        return None


    # Returns a generator that yields URLs.
    def search(self, query, tld='com', lang='en', tbs='0', safe='off', num=10, start=0,
            stop=None, domains=None, pause=2.0, only_standard=False,
            extra_params={}, tpe='', user_agent=None):
        """
        Search the given query string using Google.
        :param str query: Query string. Must NOT be url-encoded.
        :param str tld: Top level domain.
        :param str lang: Language.
        :param str tbs: Time limits (i.e "qdr:h" => last hour,
            "qdr:d" => last 24 hours, "qdr:m" => last month).
        :param str safe: Safe search.
        :param int num: Number of results per page.
        :param int start: First result to retrieve.
        :param int or None stop: Last result to retrieve.
            Use None to keep searching forever.
        :param list of str or None domains: A list of web domains to constrain
            the search.
        :param float pause: Lapse to wait between HTTP requests.
            A lapse too long will make the search slow, but a lapse too short may
            cause Google to block your IP. Your mileage may vary!
        :param bool only_standard: If True, only returns the standard results from
            each page. If False, it returns every possible link from each page,
            except for those that point back to Google itself. Defaults to False
            for backwards compatibility with older versions of this module.
        :param dict of str to str extra_params: A dictionary of extra HTTP GET
            parameters, which must be URL encoded. For example if you don't want
            Google to filter similar results you can set the extra_params to
            {'filter': '0'} which will append '&filter=0' to every query.
        :param str tpe: Search type (images, videos, news, shopping, books, apps)
            Use the following values {videos: 'vid', images: 'isch',
            news: 'nws', shopping: 'shop', books: 'bks', applications: 'app'}
        :param str or None user_agent: User agent for the HTTP requests.
            Use None for the default.
        :rtype: generator of str
        :return: Generator (iterator) that yields found URLs.
            If the stop parameter is None the iterator will loop forever.
        """
        # Set of hashes for the results found.
        # This is used to avoid repeated results.
        hashes = set()

        # Count the number of links yielded
        count = 0

        # Prepare domain list if it exists.
        if domains:
            query = query + ' ' + ' OR '.join(
                                    'site:' + domain for domain in domains)

        # Prepare the search string.
        query = quote_plus(query)

        # Check extra_params for overlapping
        for builtin_param in ('hl', 'q', 'btnG', 'tbs', 'safe', 'tbm'):
            if builtin_param in extra_params.keys():
                raise ValueError(
                    'GET parameter "%s" is overlapping with \
                    the built-in GET parameter',
                    builtin_param
                )

        # Grab the cookie from the home page.
        self.get_page(self.url_home % vars())

        # Prepare the URL of the first request.
        if start:
            if num == 10:
                url = self.url_next_page % vars()
            else:
                url = self.url_next_page_num % vars()
        else:
            if num == 10:
                url = self.url_search % vars()
            else:
                url = self.url_search_num % vars()

        # Loop until we reach the maximum result, if any (otherwise, loop forever).
        while not stop or start < stop:

            try:  # Is it python<3?
                iter_extra_params = extra_params.iteritems()
            except AttributeError:  # Or python>3?
                iter_extra_params = extra_params.items()
            # Append extra GET_parameters to URL
            for k, v in iter_extra_params:
                url += url + ('&%s=%s' % (k, v))

            # Sleep between requests.
            time.sleep(pause)

            # Request the Google Search results page.
            html = self.get_page(url)

            # Parse the response and process every anchored URL.
            if is_bs4:
                soup = BeautifulSoup(html, 'html.parser')
            else:
                soup = BeautifulSoup(html)
            anchors = soup.find(id='search').findAll('a')
            for a in anchors:

                # Leave only the "standard" results if requested.
                # Otherwise grab all possible links.
                if only_standard and (
                        not a.parent or a.parent.name.lower() != "h3"):
                    continue

                # Get the URL from the anchor tag.
                try:
                    link = a['href']
                except KeyError:
                    continue

                # Filter invalid links and links pointing to Google itself.
                link = self.filter_result(link)
                if not link:
                    continue

                # Discard repeated results.
                h = hash(link)
                if h in hashes:
                    continue
                hashes.add(h)

                # Yield the result.
                yield link

                count += 1
                if stop and count >= stop:
                    return

            # End if there are no more results.
            if not soup.find(id='nav'):
                break

            # Prepare the URL for the next request.
            start += num
            if num == 10:
                url = self.url_next_page % vars()
            else:
                url = self.url_next_page_num % vars()

class Crawler:
    def __init__(self, trend_sleep=2, scholar_sleep=2):
        self.scholar_sleep = scholar_sleep
        self.scholar_q = queue.Queue()
        self.scholar_thread = None
        self.google = GoogleSearch()
        #self.pytrend = TrendReq(hl='en-US', tz=360)

        
    def is_workers_working(self):
        is_trends_working = self.scholar_thread != None and self.scholar_thread.is_alive()
        return is_trends_working


    def scholar_worker(self):    
        print("Scholar Worker Back!")
        while not self.scholar_q.empty():
            cur_scholar = self.scholar_q.get()
            scholar_dic = self.crawl_scholar(cur_scholar)
            if scholar_dic != {}:
                if 'field_of_study' in scholar_dic.keys():
                    tag_objects = self.update_tag_info(scholar_dic['field_of_study'])
                    scholar_dic['tags'] = tag_objects
                self.update_scholar_info(cur_scholar, scholar_dic)
            time.sleep(self.scholar_sleep)
        print("Scholar Worker Stopped")

            
    def scholar_crawl_request(self, scholar):
        if not scholar.is_crawled:
            print('scholar is not crawled')
            if not self.is_workers_working(): #Tag worker is not working
                self.scholar_q.put(scholar)
                self.scholar_thread = threading.Timer(self.scholar_sleep, self.scholar_worker)
                self.scholar_thread.start()
            else:
                self.scholar_q.put(scholar)
        else:
            print('scholar is already crawled')


    def update_scholar_info(self, scholar, dic):
        print('Entered Scholar Update')
        try:
            scholar.name = str(dic['name'])
            scholar.univ = str(dic['association'])
            scholar.h_index = int(dic['citations'][2])
            scholar.i_index = int(dic['citations'][4])
            scholar.citations = int(dic['citations'][0])
            print('Will add keys')
            if 'tags' in dic.keys():
                for key in dic['tags']:
                    #print(type(key))
                    scholar.tags.add(key)
            scholar.is_crawled = True
            scholar.save()
            print('Succesfully added keys to scholar')
        except KeyError:
            print('There is key error')
        except Exception:
            print('There is another exception')
            


    def update_tag_info(self, tags):
        #print('Entered tag info addition', tags)
        tag_objects = []
        for tag in tags:
            tag_objects.append(Tag.objects.update_or_create(name=str(tag))[0])
        return tag_objects

    def parse_scholar_id(self, in_str):
        idx1 = in_str.find('citations?user') + 14
        if(in_str[idx1] == '='):
            idx1 += 1
        elif (in_str[idx1] == '%'):
            idx1 += 3
        substr = in_str[idx1:idx1+12]
        return substr

    def create_link(self, scholar_id):
        return "http://scholar.google.com/citations?user=" + scholar_id + "&hl=en"

    def create_google_query(self, scholar):
        query = scholar.name + " " + scholar.univ + " google scholar"
        return query

    def is_scholar_link(self, link):
        out = "scholar.google" in link and 'citations?user' in link
        return out


    def crawl_univ_scholar_ids(self, univ_name, stop=100):
        #Refine google scholar user id's
        matches = set()
        query = univ_name + ' google scholar'
        for j in self.google.search(query, stop=stop): 
            if self.is_scholar_link(j):
                s_id = self.parse_scholar_id(j)
                matches.add(s_id)
        return matches


    def crawl_single_scholar_id(self, scholar):
        google_query = self.create_google_query(scholar)
        for j in self.google.search(google_query, stop=10):
            if self.is_scholar_link(j):
                return self.parse_scholar_id(j)
        return None


    def crawl_scholar(self, scholar):
        crawl_dic = {}
        try:
            scholar_id = self.crawl_single_scholar_id(scholar)
        except:
            print('Google Search blocked crawling :(')
            return crawl_dic
        
        if scholar_id == None:
            return crawl_dic
        
        #Create the link
        link = self.create_link(scholar_id)

        #Get the page
        try:
            page = requests.get(link)
        except Exception:
            print('Google Scholar blocked crawling :(')
            return crawl_dic

        soup = BeautifulSoup(page.content, 'html.parser')

        try:
            #Start crawling
            name = soup.find_all('div', id='gsc_prf_in')
            name = list(name[0].children)[0]
            crawl_dic['name'] = name
            #print(name, '\n')
        except Exception:
            print('Failed finding name')

        try:
            association = soup.find_all('a', class_='gsc_prf_ila')
            if not association == []:
                association = list(association[0].children)[0]
                if association.lower() == 'homepage':
                    association = ''
                else:
                    crawl_dic['association'] = association
                    #print(association, '\n')
        except Exception:
            print('Failed finding association')

        try:
            title = soup.find_all('div', class_="gsc_prf_il")
            if not title == []:
                title = list(title[0].children)[0]
                crawl_dic['title'] = title
            #    print(title, '\n')
        except Exception:
            print('Failed finding title')


        try:
            citations = soup.find_all('td', class_='gsc_rsb_std')
            if not citations == []:
                citations = [list(cite.children)[0] for cite in citations]
                crawl_dic['citations'] = citations
                citation_str = ['All Citations', 'Citations since 2013',
                    'All h-index', 'h-index since 2013',
                    'All i10-index', 'i10 index since 2013']
                crawl_dic['citation_str'] = citation_str
        except Exception:
            print('Failed finding citations')
        
        try:
            years_cite = soup.find_all('span', class_='gsc_g_t')
            if not years_cite == []:
                years_cite = [list(cite.children)[0] for cite in years_cite]
                crawl_dic['years_cite'] = years_cite
        except Exception:
            print('Failed finding citation year')
            
        try:
            yearly_cite = soup.find_all('span', class_='gsc_g_al')
            if not yearly_cite == []:
                yearly_cite = [list(cite.children)[0] for cite in yearly_cite]
                crawl_dic['yearly_cite'] = yearly_cite
        except Exception:
            print('Failed finding yearly citations')

        #print(citation_str, '\n', citations, '\n', years_cite, '\n', yearly_cite)

        try:
            field_of_study = soup.find_all('a', class_="gsc_prf_inta gs_ibl")
            if not field_of_study == []:
                field_of_study = [list(cite.children)[0] for cite in field_of_study]
                crawl_dic['field_of_study'] = field_of_study
            #    print(field_of_study)
        except Exception:
            print('Failed finding field of study')

        try:
            co_auth_info = soup.find_all('span', class_='gsc_rsb_a_desc')
            if not co_auth_info == []:
                co_auth_info = [list(cite.children)[0] for cite in co_auth_info]
                co_authors = [list(cite.children)[0] for cite in co_auth_info]
                crawl_dic['co_authors'] = co_authors
                co_auth_id = [self.parse_scholar_id(cite.attrs['href']) for cite in co_auth_info]
                crawl_dic['co_auth_id'] = co_auth_id
            #    print(co_authors, co_auth_id)
        except Exception:
            print('Failed finding co_authors')

        try:
            paper_names = soup.find_all('a', class_='gsc_a_at')
            if not paper_names == []:
                paper_names = [list(cite.children)[0] for cite in paper_names]
                crawl_dic['paper_names'] = paper_names
            #    print(paper_names)
        except Exception:
            print('Failed finding paper_names')
        
        try:
            cite_num = soup.find_all('a', class_='gsc_a_ac gs_ibl')
            if not cite_num == []:
                cite_num = [list(cite.children)[0] for cite in cite_num]
                crawl_dic['cite_num'] = cite_num
            #    print(cite_num)
        except Exception:
            print('Failed finding citation numbers')

        try:
            paper_year = soup.find_all('span', class_='gs_oph')
            if not paper_year == []:
                paper_year = [list(cite.children)[0][2:] for cite in paper_year]
                crawl_dic['paper_year'] = paper_year
                #print(paper_year)
        except Exception:
            print('Failed finding paper years')    
        
        try:
            paper_info = soup.find_all('div', class_='gs_gray')
            if not paper_info == []:
                paper_info = [list(cite.children)[0] for cite in paper_info]
                paper_authors = [paper_info[val] for val in range(0, len(paper_info), 2)]
                paper_authors = [authors.split(', ') for authors in paper_authors]
                for authors in paper_authors:
                    if '...' in authors:
                        authors.pop()
                crawl_dic['paper_authors'] = paper_authors
                paper_confs = [paper_info[val+1] for val in range(0, len(paper_info)-1, 2)]
                crawl_dic['paper_confs'] = paper_confs
                #print(paper_authors, paper_confs)
        except Exception:
            print('Failed finding paper author or confs')
            
        ##Dont forget to remove this after
        #crawl_dic['soup'] = soup

        return crawl_dic

