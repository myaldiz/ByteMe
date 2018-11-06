from django.conf.urls import url
from . import views  
from rest_framework.urlpatterns import format_suffix_patterns


"""
Browse event:
http GET http://127.0.0.1:8000/api/v1/event/browse

Modify event:
http POST http://127.0.0.1:8000/api/v1/event/modify/<event_id> event:='{"abstract": "BlaBla", "place": "Kaist", "time": "2018-11-03 03:01:00.914138+00:00", "title": "Zombies", "details": "Blabla"}'

Add event:
http POST http://127.0.0.1:8000/api/v1/event/add event:='{"abstract": "BlaBla", "place": "Kaist", "time": "2018-11-03 03:01:00.914138+00:00", "title": "Zombies", "details": "Blabla"}'

Delete event:
http DELETE http://127.0.0.1:8000/api/v1/event/delete/<event_id> 

Approve event:
http -f POST http://127.0.0.1:8000/api/v1/event/request/approvel/<event_id> req="add" | req="mod" | req="del"
"""


urlpatterns = [
    url(r'^browse', views.BrowseEvent),
    # url(r'^browse/(?P<user_name>\w+)', views.BrowseEvent),
    url(r'^add', views.AddEvent),
    url(r'^delete/(?P<event_id>[^/]+)', views.DeleteEvent),
    url(r'^modify/(?P<event_id>[^/]+)', views.ModiftEvent),
    url(r'^request/approvel/(?P<event_id>[^/]+)', views.ApproveEvent),
]

urlpatterns = format_suffix_patterns(urlpatterns)