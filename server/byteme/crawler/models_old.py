from django.db import models
import threading, time, queue
from pytrends.request import TrendReq

class Crawler:
    def __init__(self, trend_sleep=5, scholar_sleep=5):
        self.trend_sleep = trend_sleep
        self.scholar_sleep = scholar_sleep
        self.trends_q = queue.Queue()
        self.scholar_q = queue.Queue()
        self.trends_thread = None
        self.scholar_thread = None
        self.pytrend = TrendReq(hl='en-US', tz=360)

        
    def is_workers_working(self):
        is_trends_working = self.trends_thread != None and self.trends_thread.is_alive()
        is_scholar_working = self.scholar_thread != None and self.scholar_thread.is_alive()
        return (is_trends_working, is_scholar_working)
    
    
    def crawl_tag(self, tag):
        out_str = tag + ", " + str(time.time())
        print(out_str)
        return None

    
    def crawl_person(self, person):
        out_str = person + ", " + str(time.time())
        print(out_str)
        return None
    
    
    def trends_worker(self):    
        while not self.trends_q.empty():
            cur_tag = self.trends_q.get()
            self.crawl_tag(cur_tag)
            time.sleep(self.trend_sleep)
        print("Finished trends :(")

            
    def scholar_worker(self):    
        while not self.trends_q.empty():
            cur_person = self.trends_q.get()
            self.crawl_person(cur_person)
            time.sleep(self.scholar_sleep)
        print("Finished scholar :(")

            
    def tag_crawl_request(self, tag):
        if not self.is_workers_working()[0]: #Tag worker is not working
            self.trends_q.put(tag)
            self.trends_thread = threading.Timer(self.trend_sleep, self.trends_worker)
            self.trends_thread.start()
        else:
            self.trends_q.put(tag)
        

    def person_crawl_request(self, person):
        if not self.is_workers_working()[1]: #Scholar worker is not working
            self.scholar_q.put(person)
            self.scholar_thread = threading.Timer(self.scholar_sleep, self.scholar_worker)
            self.scholar_thread.start()
        else:
            self.scholar_q.put(person)
