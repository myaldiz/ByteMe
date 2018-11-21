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

# helper fuction
def queryEvent(creater = None):
    """
    query event from the sqlitle using django defalut model API

    Args:
        ID (UUIDField): event id
        username (String): user id

    returns:
        events/event or Http404

    TODO: not sure that if we are going to query event by id/username or not
    """
    try:
        if creater:
            return Event.objects.filter(~Q(req = "add")).filter(creater = creater)
        else:
            return Event.objects.all().filter(~Q(req = "add"))
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

    TODO: Authentication
    """
    if req == "mod":
        event = Event.objects.get(identifier = ID)
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

    if req == "add":
        event = Event.objects.get(identifier = ID)
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
        event = Event.objects.get(identifier = ID)
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
    #TODO authentication
    user_name = request.GET.get("user", False)
    # renderer_classes = [TemplateHTMLRenderer]
    # template_name = 'login.html'

    if user_name:
        try:
            user = User.objects.get(username = user_name)
            creater = UserProfile.objects.get(user = user) 
        except User.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
        except UserProfile.DoesNotExist:
            return_json  = {"Response":"List_events", "Events":[]}
            return Response(return_json, status=status.HTTP_200_OK)
            
        Event_List = queryEvent(creater = creater)
    else:
        Event_List   = queryEvent()

    Event_json   = EventSerializer(Event_List, many = True)
    # Event_json.data.
    return_json  = {"Response":"List_events", "Events":Event_json.data}
    return Response(return_json, status=status.HTTP_200_OK)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def AddEvent(request):
    #TODO authentication
    #TODO What is the return json looks like
    try:
        json_emial   = request.data.get('User').get("email")
        json_speaker = request.data.get('speaker').get('name')
        json_event   = request.data.get('Event')
        json_time    = request.data.get('Event').get("time")
        json_title   = request.data.get('Event').get("title")
    except : 
        return Response({"Response":"Add_Event", "status": "Please check response json"}, status=status.HTTP_400_BAD_REQUEST)
    # create/update a speaker
    Speaker.objects.update_or_create(name = json_speaker)

    # get speaker/creater
    speaker = Speaker.objects.get(name = json_speaker)
    creater = UserProfile.objects.get(userEmail = json_emial)

    #create new event
    New_event = Event.objects.create(creater = creater, time = json_time, speaker = speaker, req = "add")

    #make it become json and updata the data
    Event_json = EventSerializer(New_event, data = json_event)

    if Event_json.is_valid():
        Event_json.save()
        Updated_Event_json = {"id": Event_json.data["identifier"], "title": json_title, "status": "wait"}
        return_json  = {"Response":"Add_Event", "Events":Updated_Event_json}
        return Response(return_json, status = status.HTTP_202_ACCEPTED)
    
    return Response(Event_json.data, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def ModifyEvent(request, event_id):
    #TODO authentication
    #TODO What is the return json looks like
    try:
        json_emial   = request.data.get('User').get("email")
        json_event   = request.data.get('Event')
        json_time    = request.data.get('Event').get("time")
        json_title   = request.data.get('Event').get("title")
    except : 
        return Response({"Response":"Add_Event", "status": "Please check response json"}, status=status.HTTP_400_BAD_REQUEST)

    creater = UserProfile.objects.get(userEmail = json_emial)
    
    event = Event.objects.get(creater = creater)
    Event_json = EventSerializer(event, data = json_event)

    if Event_json.is_valid():
        Event_json.save()
        Updated_Event_json = Event_json.data
        return_json  = {"Response":"Modify_Event", "Events":Updated_Event_json}
        return Response(return_json, status = status.HTTP_202_ACCEPTED)

    return Response(Event_json.data, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['DELETE'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def DeleteEvent(request, event_id):
    #TODO authentication
    #TODO What is the return json looks like

    event = Event.objects.get(identifier = event_id)
    event.req = "del"
    event.save()
    event_json = {"id": event_id, "title": event.title, "status": "wait"}
    return_json = {"Response": "Delete_event", "Event": event_json}
    return Response(return_json, status = status.HTTP_202_ACCEPTED)

#API
@api_view(['POST'])
@authentication_classes((SessionAuthentication, BasicAuthentication))
@permission_classes((IsAuthenticated,))
def ApproveEvent(request, event_id):
    #TODO authentication
    #TODO not approve?

    req = request.POST.get("req", False)
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
        return Response("something wrong", status = status.HTTP_400_BAD_REQUEST)

