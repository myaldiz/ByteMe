from .models import Event
from accounts.models import UserProfile
from accounts.models import Speaker
from .serializers import EventSerializer

from django.http import JsonResponse
from django.http import Http404
from django.utils import timezone
from django.db.models import Q
from django.contrib.auth.models import User

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.renderers import TemplateHTMLRenderer

from crawler.models import Crawler
crawler = Crawler()

# helper fuction
def queryEvent(user, event_type):
    """
    query event from the sqlitle using django defalut model API

    Args:
        ID (UUIDField): event id
        username (String): user id

    returns:
        events/event or Http404
    """
    try:
        if event_type == "attending":
            return Event.objects.filter(~Q(req="add")).filter(attendant__user__username = str(user))
        elif event_type == "created":
            return Event.objects.filter(~Q(req="add")).filter(creater=user)
        else:
            return Event.objects.all().filter(~Q(req="add"))
    except Event.DoesNotExist:
        raise Http404

# helper fuction
def approveEventChange(ID, req):
    """
    approve the operations(add/del/mod) in event 

    Args:
        ID (UUIDField): event id
        req (String): operation

    returns:
        events for add/mod, True for del
    """
    if req == "mod":
        event = Event.objects.get(identifier = ID) #get the event 

        if req == event.req:
            if event.abstractReq != None: 
                event.abstract = event.abstractReq
                event.abstractReq = None

            if event.placeReq != None:
                event.place = event.placeReq
                event.placeReq = None

            if event.timeReq != None:
                event.time = event.timeReq
                event.timeReq = None

            if event.title != None:
                event.title = event.titleReq
                event.titleReq = None

            if event.detailsReq != None:
                event.details = event.detailsReq
                event.detailsReq  = None

            event.req = "non"
            event.save()
            return event
        else:
            return False

    if req == "add":
        event = Event.objects.get(identifier = ID) #get the event 

        if req == event.req:
            event.abstract    = event.abstractReq
            event.place       = event.placeReq
            event.time        = event.timeReq
            event.title       = event.titleReq
            event.details     = event.detailsReq
            event.req         = "non"
            event.abstractReq = None
            event.placeReq	  = None
            event.timeReq	  = None
            event.titleReq	  = None
            event.detailsReq  = None
            event.save()
            return event
        else:
            return False

    if req == "del":
        event = Event.objects.get(identifier = ID) #get the event 

        if req == event.req:
            Event.objects.get(identifier = ID).delete()
            return True
        else: 
            return False
 
#API
@api_view(['GET'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def BrowseEvent(request):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile
    
    try:
        event_type = request.GET.get("type", False) # attending or created
    except:
        return Response({"Response":"List_events", "status": "No request type"}, status=status.HTTP_400_BAD_REQUEST)

    if event_type != "attending" and event_type != "created" and event_type != "all":
        return Response({"Response":"List_events", "status": "Invalid request type"}, status=status.HTTP_400_BAD_REQUEST)
    
    Event_List = queryEvent(login_userprofile, event_type)
    Event_json = EventSerializer(Event_List, many = True)

    # Event_json.data.
    return_json  = {"Response":"List_events", "Events":Event_json.data}
    return Response(return_json, status=status.HTTP_200_OK)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def AddEvent(request):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    try:
        json_speaker = request.data.get('speaker').get('name')
        json_event   = request.data.get('Event')

    except : 
        return Response({"Response":"Add_Event", "status": "Please check the response json"}, status=status.HTTP_400_BAD_REQUEST)

    # create or update a speaker
    Speaker.objects.update_or_create(name = json_speaker)

    # get the speaker and creater
    speaker = Speaker.objects.get(name = json_speaker)
    crawler.scholar_crawl_request(speaker)
    creater = login_userprofile

    # get time and title to create a initial event
    json_time  = request.data.get('Event').get("time")
    json_title = request.data.get('Event').get("title")

    #create a new event
    New_event = Event.objects.create(creater = creater, time = json_time, speaker = speaker, req = "add")

    #make it becomes json and updatas the data
    Event_json = EventSerializer(New_event, data = json_event)

    #check if json valod
    if Event_json.is_valid():
        Event_json.save()
        Updated_Event_json = {"id": Event_json.data["identifier"], "title": json_title, "status": "processing"}
        return_json  = {"Response":"Add_Event", "Events":Updated_Event_json}
        return Response(return_json, status = status.HTTP_202_ACCEPTED)
    
    return Response(Event_json.data, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def ModifyEvent(request, event_id):
    """
    Dont forget to call crawling method!
    It will check if speaker crawled or not, dont worry :) ..
    """
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    try:
        json_event   = request.data.get('Event')
    except : 
        return Response({"Response":"Modify_Event", "status": "Please check response json"}, status=status.HTTP_400_BAD_REQUEST)

    
    # get the creater
    creater = login_userprofile
    
    # get the certain event
    event = Event.objects.get(creater = creater)
    Event_json = EventSerializer(event, data = json_event)

    #check if json valod
    if Event_json.is_valid():
        Event_json.save()
        return_json  = {"Response":"Modify_Event", "Events": json_event, "status": "processing"}
        return Response(return_json, status = status.HTTP_202_ACCEPTED)

    return Response(Event_json.data, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['DELETE'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def DeleteEvent(request, event_id):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    # get certain event
    event = Event.objects.get(identifier = event_id)
    event.req = "del"
    event.save()

    event_json = {"id": event_id, "title": event.title, "status": "processing"}
    return_json = {"Response": "Delete_event", "Event": event_json}

    return Response(return_json, status = status.HTTP_202_ACCEPTED)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def ApproveEvent(request, event_id):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    req = request.POST.get("req", False) #get it from form

    event = approveEventChange(event_id, req)

    if (event):
        if req == "add":
            res = "Add_event"
            title = event.title
            event_json = {"id": event_id, "title": title, "status": "accepted"}

        if req == "mod":
            res = "Modify_event"
            title = event.title
            event_json = {"id": event_id, "title": title, "status": "accepted"}

        if req == "del":
            res = "Delete_event"
            event_json = {"id": event_id, "status": "accepted"}
        return Response({"Response": res, "Event": event_json}, status = status.HTTP_205_RESET_CONTENT)
    else:
        return Response({"Response":"Approve_event", "status": "Different request proccessing"}, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def MarkEvent(request, event_id):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    event = Event.objects.get(identifier = event_id) #get the event 

    event.attendant.add(login_userprofile)
    event.save()

    return Response({"Response":"Mark_event", "status": "accepted"}, status = status.HTTP_200_OK)


#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def UnMarkEvent(request, event_id):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile

    event = Event.objects.get(identifier = event_id) #get the event 

    event.attendant.remove(login_userprofile)
    event.save()

    return Response({"Response":"Unmark_event", "status": "accepted"}, status = status.HTTP_200_OK)

