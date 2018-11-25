from rest_framework import serializers
from events.tag import Tag
from events.tag_serializers import TagSerializer
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta: 
        model = User
        fields = ('username','email')

class PersonSerializer(serializers.Serializer):
    univ = serializers.CharField(required=False, allow_blank=True, max_length=100)
    dept = serializers.CharField(required=False, allow_blank=True, max_length=100)
    tags = serializers.StringRelatedField(required = False, allow_null = True, many = True)

class SpeakerSerializer(PersonSerializer):
    name = serializers.CharField(required=False, allow_blank=True, max_length=100)
    speakerEmail = serializers.EmailField(required=False, allow_blank=True, max_length=100)
    bio = serializers.CharField(required=False, allow_blank=True, max_length=100)

class UserProfileSerializer(PersonSerializer):
    user = UserSerializer(required =False, allow_null=True)
    # userEmail = serializers.EmailField(required=False, allow_blank=True, max_length=100)
    # isAdmin = serializers.BooleanField(required=False, allow_null=True)