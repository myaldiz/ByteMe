from django.conf.urls import url, include
from . import views  
from rest_framework.authtoken import views as r_view

urlpatterns = [
    url(r'^api-token-auth/', r_view.obtain_auth_token),
    url(r'^profile', views.GetProfile),
	url(r'^register', views.CreateProfile),
	url(r'^modify', views.ModifyProfile),
]

# urlpatterns = format_suffix_patterns(urlpatterns)