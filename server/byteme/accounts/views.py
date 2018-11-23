from .models import UserProfile

from django.shortcuts import render
from django.contrib.auth.models import User
from django.core.validators import validate_email

from rest_framework.decorators import api_view

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

@api_view(['POST'])
def CreateProfile(request):
	try:
        json_username = request.data.get("User").get("id")
        json_email = request.data.get("User").get("email")
        json_password = request.data.get("User").get("pw_hash")
    except : 
        return Response({"Response":"Sign_up", "status": "Please check request json"}, status=status.HTTP_400_BAD_REQUEST)
	
	try:
		validate_email(json_email)
	except:
		return Response({"Response":"Sign_up", "status": "Invalid email"}, status=status.HTTP_400_BAD_REQUEST)

	if not json_email.endswith("@kaist.ac.kr"):
		return Response({"Response":"Sign_up", "status": "Not a KAIST email"}, status=status.HTTP_400_BAD_REQUEST)

	try:
		user = User.objects.create_user(json_username, password=json_password)
	except:
		return Response({"Response":"Sign_up", "status": "Not a unique username"}, status=status.HTTP_400_BAD_REQUEST)

	try:
		person = UserProfile.objects.create(user=user, isAdmin=False)
	except:
		user.delete()
		return Response({"Response":"Sign_up", "status": "Not a unique email"}, status=status.HTTP_400_BAD_REQUEST)
"""=======
    try:
        json_username = request.data.get("register").get("username")
        json_email = request.data.get("register").get("email")
        json_password = request.data.get("register").get("password")
    except : 
        return Response({"Response":"Register", "status": "Please check response json"}, status=status.HTTP_400_BAD_REQUEST)
    user = User.objects.create_user(json_username, email=json_email, password=json_password)
    person = UserProfile.objects.create(user=user, isAdmin=False)
>>>>>>> 4fed7d9f92f1e7fdc741d9fad1b0f182f0a2808a"""

	return_json  = {"Response": "Sign_up", "id": json_email, "result": "accepted"}
	return Response(return_json, status=status.HTTP_200_OK)