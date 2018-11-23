from django.conf.urls import url, include
from . import views  
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    url(r'^', include('rest_framework.urls')),
    url(r'^user', views.example_view),
	url(r'^register', views.CreateProfile),
]

urlpatterns = format_suffix_patterns(urlpatterns)