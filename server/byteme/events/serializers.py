from rest_framework import serializers
from .models import Event
from .tag_serializers import TagSerializer
from accounts.serializers import *
from accounts.models import *

class EventSerializer(serializers.Serializer):
    identifier = serializers.UUIDField(read_only= True, format='hex_verbose')
    creater    = serializers.StringRelatedField(read_only= True)
    attendant  = serializers.StringRelatedField(read_only= True, many = True)
    abstract   = serializers.CharField(required = False, allow_blank=True, max_length=5000)
    place      = serializers.CharField(required = False, allow_blank=True, max_length=500)
    time       = serializers.CharField(required = False, allow_blank=True, max_length=500)
    title      = serializers.CharField(required = False, allow_blank=True, max_length=500)
    details    = serializers.CharField(required = False, allow_blank=True, max_length=5000)
    tags       = serializers.StringRelatedField(required = False, allow_null = True, many = True)
    req        = serializers.CharField(required = False, allow_blank=True, max_length=50)
    Iscore     = serializers.DecimalField(required = False, allow_null = True, max_digits = 3, decimal_places = 3)
    speaker    = SpeakerSerializer(required = False)
    tags       = TagSerializer(required = False, many = True) 
    imgurl     = serializers.CharField(required = False, allow_blank=True, max_length=500)



    def update(self, instance, validated_data):
        instance.abstractReq = validated_data.get('abstract', instance.abstractReq)
        instance.placeReq    = validated_data.get('place'   , instance.placeReq)
        instance.timeReq     = validated_data.get('time'    , instance.timeReq)
        instance.titleReq    = validated_data.get('title'   , instance.titleReq)
        instance.detailsReq  = validated_data.get('details' , instance.detailsReq)
        instance.imgurLReq   = validated_data.get('poster_image' , instance.imgurLReq)
        if "speaker" in validated_data:
            speaker_data         = validated_data.pop('speaker')
            instance.speakerReq  = Speaker.objects.update_or_create(**speaker_data)[0]
        
        if "tags" in validated_data:
            tags_data = validated_data.pop('tags')
            for tag in tags_data:
                tag_get = Tag.objects.get(name = tag.get('name'))
                instance.tagsReq.add(tag_get) 

        if instance.req == "non":
            instance.req = "mod"
            
        instance.save()
        return instance