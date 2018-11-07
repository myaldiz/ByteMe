from rest_framework import serializers
from .models import Event
from .tag_serializers import TagSerializer
from accounts.serializers import *
from accounts.models import *

class EventSerializer(serializers.Serializer):
    identifier = serializers.UUIDField(read_only= True, format='hex_verbose')
    creater    = serializers.StringRelatedField(read_only= True)
    attendant  = serializers.StringRelatedField(read_only= True, many = True)
    abstract   = serializers.CharField(required = False, allow_blank=True, max_length=100)
    place      = serializers.CharField(required = False, allow_blank=True, max_length=100)
    time       = serializers.CharField(required = False, allow_blank=True, max_length=100)
    title      = serializers.CharField(required = False, allow_blank=True, max_length=100)
    details    = serializers.CharField(required = False, allow_blank=True, max_length=100)
    tags       = serializers.StringRelatedField(required = False, allow_null = True, many = True)
    req        = serializers.CharField(required = False, allow_blank=True, max_length=100)
    speaker    = serializers.CharField(read_only= True)
    #TODO poster_image



    def update(self, instance, validated_data):
        instance.abstractReq = validated_data.get('abstract', instance.abstractReq)
        instance.placeReq    = validated_data.get('place'   , instance.placeReq)
        instance.timeReq     = validated_data.get('time'    , instance.timeReq)
        instance.titleReq    = validated_data.get('title'   , instance.titleReq)
        instance.detailsReq  = validated_data.get('details' , instance.detailsReq)
        # instance.tagsReq
        if instance.req == "non":
            instance.req = "mod"
        instance.save()
        return instance