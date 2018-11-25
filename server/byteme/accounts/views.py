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
def GetProfile(request):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    content = {
        'name': str(login_user),
        'userEmail': login_user.email,  
    }
    return Response(content, status=status.HTTP_200_OK)

@api_view(['POST'])
def CreateProfile(request):
	try:
		json_username = request.data.get("User").get("id")
		json_email = request.data.get("User").get("email")
		json_password = request.data.get("User").get("pw_hash")
		json_type = request.data.get("User").get("type")
	except : 
		return Response({"Response":"Sign_up", "status": "Please check the request json"}, status=status.HTTP_400_BAD_REQUEST)
	
	try:
		validate_email(json_email)
	except:
		return Response({"Response":"Sign_up", "status": "Invalid email"}, status=status.HTTP_400_BAD_REQUEST)

	if not json_email.endswith("@kaist.ac.kr"):
		return Response({"Response":"Sign_up", "status": "Not a KAIST email"}, status=status.HTTP_400_BAD_REQUEST)

	try:
		if json_type == "admin":
			staff = True
		elif json_type == "normal":
			staff = False
		else:
			return Response({"Response":"Sign_up", "status": "Not a valid user type"}, status=status.HTTP_400_BAD_REQUEST)
		user = User.objects.create_user(json_username, password=json_password, email= json_email, is_staff=staff)
	except:
		return Response({"Response":"Sign_up", "status": "Not a unique username"}, status=status.HTTP_400_BAD_REQUEST)

	try:
		person = UserProfile.objects.create(user=user)
	except:
		user.delete()
		return Response({"Response":"Sign_up", "status": "Not a unique email"}, status=status.HTTP_400_BAD_REQUEST)


	return_json  = {"Response": "Sign_up", "id": json_email, "result": "accepted"}
	return Response(return_json, status=status.HTTP_200_OK)

@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def AddTags(request):
	pass