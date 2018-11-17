from django.conf.urls import url
from . import views
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    url(r'^snippets/', views.snippet_list),
    url(r'^snippets/(?P<pk>[^/]+)/', views.snippet_detail),
]

urlpatterns = format_suffix_patterns(urlpatterns)