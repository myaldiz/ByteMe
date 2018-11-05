from .models import Event
from .serializers import EventSerializer

from django.http import JsonResponse
from django.http import Http404
from django.utils import timezone
from django.db.models import Q

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view

# helper fuction
def queryEvent(ID = None, username = None):
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
        if username:
            return Event.objects.get(identifier = ID).filter(~Q(req = "add"))
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

    if req == "add":
        event = Event.objects.get(identifier = ID)
        event.req = "non"
        event.save()
        return event

    if req == "del":
        Event.objects.get(identifier = ID).delete()
        return True

#API
@api_view(['GET'])
def BrowseEvent(request):
    #TODO authentication

    Event_List   = queryEvent()
    Event_json   = EventSerializer(Event_List, many = True)
    return_json  = {"Response":"List_events", "Events":[Event_json.data]}
    return Response(return_json)
 
#API
@api_view(['POST'])
def AddEvent(request):
    #TODO authentication
    #TODO What is the return json looks like

    Event_json = EventSerializer(data = request.data.get("event"))

    if Event_json.is_valid():
        Event_json.save()
        return Response(Event_json.data, status = status.HTTP_202_ACCEPTED)
    
    return Response(Event_json.data, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['POST'])
def ModiftEvent(request, event_id):
    #TODO authentication
    #TODO What is the return json looks like

    event = Event.objects.get(identifier = event_id)
    Event_json = EventSerializer(event, data = request.data.get("event"))

    if Event_json.is_valid():
        Event_json.save()
        return Response(Event_json.data, status = status.HTTP_202_ACCEPTED)

    return Response(Event_json.data, status = status.HTTP_400_BAD_REQUEST)

#API
@api_view(['DELETE'])
def DeleteEvent(request, event_id):
    #TODO authentication
    #TODO What is the return json looks like

    event = Event.objects.get(identifier = event_id)
    event.req = "del"
    event.save()
    return Response(status = status.HTTP_202_ACCEPTED)

#API
@api_view(['POST'])
def ApproveEvent(request, event_id):
    #TODO authentication
    #TODO not approve?

    req = request.POST.get("req", False)
    event = approveEventChange(event_id, req)
    return Response(status = status.HTTP_205_RESET_CONTENT)

