from django.conf.urls import url
from . import views  
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    url(r'^browse', views.BrowseEvent),
    url(r'^add', views.AddEvent),
    url(r'^delete/(?P<event_id>[^/]+)', views.DeleteEvent),
    url(r'^modify/(?P<event_id>[^/]+)', views.ModifyEvent),
    url(r'^attend/(?P<event_id>[^/]+)', views.MarkEvent),
    url(r'^unattend/(?P<event_id>[^/]+)', views.UnMarkEvent),
    url(r'^tag/browse', views.BrowseTag),
    url(r'^tag/select/(?P<event_id>[^/]+)', views.SelectTag),
    url(r'^tag/remove/(?P<event_id>[^/]+)', views.RemoveTag),
    url(r'^request/approvel/(?P<event_id>[^/]+)', views.ApproveEvent),
]

urlpatterns = format_suffix_patterns(urlpatterns)