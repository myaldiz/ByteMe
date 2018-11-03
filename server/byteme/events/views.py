from .models import EventHandler
from .models import Event
from .serializers import EventSerializer

from django.http import JsonResponse
from django.http import Http404
from django.utils import timezone

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view

eventHandler = EventHandler()


@api_view(['GET'])
def BrowseEvent(request):
    #TODO authentication

    Event_List   = eventHandler.queryEvent(username = None)
    Event_json   = EventSerializer(Event_List, many = True)
    return_json  = {"Response":"List_events", "Events":[Event_json.data]}
    return Response(return_json)
 
@api_view(['POST'])
def AddEvent(request):
    #TODO authentication

    Event_json = EventSerializer(data = request.data.get("event"))
    if Event_json.is_valid():
        Event_json.save()
        return Response(Event_json.data, status=status.HTTP_202_ACCEPTED)
    
    return Response(Event_json.data, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def ModiftEvent(request, event_id):
    #TODO authentication

    #Get the event
    event = Event.objects.get(identifier = event_id)
    #Store post_form in Req columns
    Event_json = EventSerializer(event, data = request.data.get("event"))

    #check if post_form is valid
    if Event_json.is_valid():
        Event_json.save()
        return Response(Event_json.data, status=status.HTTP_202_ACCEPTED)

    return Response(Event_json.data, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def DeleteEvent(request, event_id):
    #TODO authentication

    #Get the event
    event = Event.objects.get(identifier = event_id)
    #set req = "delete"
    event.req = "del"
    event.save()
    return Response(status=status.HTTP_202_ACCEPTED)

@api_view(['POST'])
def ApproveEvent(request, event_id):
    #TODO authentication

    req = request.POST.get("req", False)
    event = eventHandler.approveEventChange(event_id, req)
    return Response(status=status.HTTP_205_RESET_CONTENT)

