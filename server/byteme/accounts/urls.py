from django.conf.urls import url, include
from . import views  
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    url(r'^', include('rest_framework.urls')),
    url(r'^profile', views.GetProfile),
	url(r'^register', views.CreateProfile),
	url(r'^modify', views.ModifyProfile),
]

urlpatterns = format_suffix_patterns(urlpatterns)