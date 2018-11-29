from django.shortcuts import render, render_to_response, get_object_or_404
from django.http import HttpResponseRedirect

from events.models import Event
from accounts.models import UserProfile
from accounts.models import Speaker
from events.tag import Tag
from events.tag_serializers import TagSerializer
from events.serializers import EventSerializer

from django.contrib.auth.models import User
from events.views import approveEventChange
# Create your views here.
def approve(request):
    login_user = request.user #get login user
    login_userprofile = UserProfile.objects.get(user = login_user) #get userprofile
    event_created = Event.objects.all()

    if request.method == "POST":
        event_id = request.POST["id"]
        event = Event.objects.get(identifier = event_id)
        approveEventChange(event_id, event.req)
        return HttpResponseRedirect(next)
    
    return render(request, 'approve.html', locals())