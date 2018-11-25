from .models import UserProfile
from .serializers import *

from django.shortcuts import render
from django.contrib.auth.models import User
from django.core.validators import validate_email

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
    return Response(UserProfileSerializer(login_userprofile).data, status=status.HTTP_200_OK)

@api_view(['POST'])
def CreateProfile(request):
	try:
		json_username = request.data.get("User").get("id")
		json_email = request.data.get("User").get("email")
		json_password = request.data.get("User").get("pw_hash")
		json_type = request.data.get("User").get("type")
	except Exception: 
		return Response({"Response":"Sign_up", "status": "Please check the request json"}, status=status.HTTP_400_BAD_REQUEST)
	
	try:
		validate_email(json_email)
	except Exception:
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
	except Exception:
		return Response({"Response":"Sign_up", "status": "Not a unique username"}, status=status.HTTP_400_BAD_REQUEST)

	try:
		person = UserProfile.objects.create(user=user)
		#person = UserProfile.objects.create(user=user, isAdmin=False)
	except Exception:
		user.delete()
		return Response({"Response":"Sign_up", "status": "Not a unique email"}, status=status.HTTP_400_BAD_REQUEST)


	return_json  = {"Response": "Sign_up", "id": json_email, "result": "accepted"}
	return Response(return_json, status=status.HTTP_200_OK)

@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def ModifyProfile(request):
    login_user = request.user
    login_userprofile = UserProfile.objects.get(user=login_user)

    json_dept = request.data.get('dept')
    json_tags_list = request.data.get('tags')
    login_userprofile.dept = json_dept
    for tag in json_tags_list:
        json_tag = tag["name"]
        tag_object = Tag.objects.get(name=json_tag)
        login_userprofile.tags.add(tag_object)

    login_userprofile.save()
    return Response({"Response": "Modify_profile", "status": "accepted"}, status=status.HTTP_202_ACCEPTED)
    