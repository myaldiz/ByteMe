from django.conf.urls import url
from . import views  
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    url(r'^browse', views.BrowseEvent),
    url(r'^add', views.AddEvent),
    url(r'^delete/(?P<event_id>[^/]+)', views.DeleteEvent),
    url(r'^modify/(?P<event_id>[^/]+)', views.ModifyEvent),
    url(r'^request/approvel/(?P<event_id>[^/]+)', views.ApproveEvent),
]

urlpatterns = format_suffix_patterns(urlpatterns)