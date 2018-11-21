from .models import UserProfile

from django.shortcuts import render
from django.contrib.auth.models import User

from rest_framework.decorators import api_view

@api_view(['POST'])
def CreateProfile(request):
	try:
        json_username = request.data.get("register").get("username")
        json_email = request.data.get("register").get("email")
        json_password = request.data.get("register").get("password")
    except : 
        return Response({"Response":"Register", "status": "Please check response json"}, status=status.HTTP_400_BAD_REQUEST)
	user = User.objects.create_user(json_username, email=json_email, password=json_password)
	person = UserProfile.objects.create(user=user, isAdmin=False)
