from django.shortcuts import render

from .models import UserProfile

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.renderers import TemplateHTMLRenderer


# Create your views here.
@api_view(['GET'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def example_view(request):
    
    userprofile = UserProfile.objects.get(user = request.user)

    content = {
        'name': str(request.user),
        'userEmail': userprofile.userEmail,  # `django.contrib.auth.User` instance.
    }
    return Response(content)