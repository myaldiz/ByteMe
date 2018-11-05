from rest_framework import serializers
from .models import Person, Speaker, UserProfile
from events.tag_serializers import TagSerializer
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta: 
        model = User
        fields = '__all__'

class PersonSerializer(serializers.Serializer):
    univ = serializers.CharField(required=False, allow_blank=True, max_length=100)
    dept = serializers.CharField(required=False, allow_blank=True, max_length=100)
    tags = TagSerializer()

class SpeakerSerializer(PersonSerializer):
    name = serializers.CharField(required=False, allow_blank=True, max_length=100)
    speakerEmail = serializers.EmailField(required=False, allow_blank=True, max_length=100)
    bio = serializers.CharField(required=False, allow_blank=True, max_length=100)

class UserProfileSerializer(PersonSerializer):
    user = UserSerializer(required =True)
    userEmail = serializers.EmailField(required=False, allow_blank=True, max_length=100)
    isAdmin = serializers.BooleanField(required=False)