import django
import os
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "byteme.settings.base")
django.setup()

from crawler.models import Crawler
from accounts.models import Speaker, UserProfile, User
from events.tag import Tag
from events.models import Event
from events.views import approveEventChange
from time import sleep
import csv
import json
import pickle
import sys
import random
from datetime import datetime
from django.utils import timezone

num_random_scholars = 50
sys.setrecursionlimit(100000)
my_crawler = Crawler()
my_crawler.verbose = False

with open('crawling_output/scholar_crawled.pickle', 'rb') as handle:
    scholar_dic_pickle = pickle.load(handle)

scholar_list = []
for scholar_dic in scholar_dic_pickle:
    name = scholar_dic['name']
    try:
        univ = scholar_dic['association']
    except KeyError:
        univ = 'Kaist'
    email = ''.join(name.split(' ')) + str(random.randint(0,100)) + '@' + univ.split(' ')[0] + '.edu'
    email = email.lower()
    #print(name, univ, email)
    scholar = Speaker.objects.create(name=name, univ=univ, speakerEmail=email)
    if scholar_dic != {}:
        if 'field_of_study' in scholar_dic.keys():
            tag_objects = my_crawler.update_tag_info(scholar_dic['field_of_study'])
            scholar_dic['tags'] = tag_objects
        my_crawler.update_scholar_info(scholar, scholar_dic)
    scholar_list.append(scholar)

image_urls = []
with open('crawling_output/images.csv', newline='\n') as csvfile:
    m_reader = csv.reader(csvfile, delimiter=',', quotechar='|')
    for row in m_reader:
        image_urls.append(row[0])


index_list = set()
while len(index_list) != num_random_scholars:
    index_list.add(random.randint(0, len(scholar_dic_pickle)-1))
index_list = list(index_list)

admin = User.objects.create_superuser(username='admin', password='password@', email='berk17@gmail.com')
UserProfile.objects.create(user=admin)
username = 'myaldiz'
passw = '1234'
email = 'myaldiz@kaist.ac.kr'
staff = True
django_user = User.objects.create_user(username, password=passw, email= email, is_staff=staff)
user = UserProfile.objects.create(user=django_user)
#print(User.objects.all(), UserProfile.objects.all())

with open('crawling_output/Events.json') as file:
    vals = json.load(file)
abstract_list = []
place_list = []
title_list = []
details_list = []
for i in vals['Events']:
    abstract_list.append(i['abstract'])
    place_list.append(i['place'])
    title_list.append(i['title'])
    details_list.append(i['details'])


for index in index_list:
    scholar_dic = scholar_dic_pickle[index]
    scholar = scholar_list[index] 
    image_url = image_urls[random.randint(0, len(image_urls)-1)]
    time = timezone.now()
    time = time.replace(year=2019, month = random.randint(1,12), 
                        day=random.randint(1,25), hour=12, minute=0)
    abstract = abstract_list[random.randint(0,len(abstract_list)-1)]
    place = place_list[random.randint(0,len(place_list)-1)]
    title = title_list[random.randint(0,len(title_list)-1)]
    details = details_list[random.randint(0,len(details_list)-1)]
    cur_event = Event.objects.create(creater = user, speaker = scholar, time = time, timeReq = time, speakerReq = scholar, 
                                     req = "add", placeReq=place, titleReq=title, detailsReq=details,
                                     abstractReq=abstract, imgurLReq=image_url)
    tags = set()
    while (len(tags) != 10):
        cur_tag = Tag.objects.all()[random.randint(0,len(Tag.objects.all())-1)]
        tags.add(cur_tag)
    for tag in tags:
        cur_event.tags.add(tag)
    
    if bool(random.randint(0,2)):
        approveEventChange(cur_event.identifier, req="add")
    cur_event.save()

print('Population Complete!!')