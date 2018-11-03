from django.test import TestCase
from .models import Event
from django.utils import timezone

# Create your tests here.
class EventCreateTestCase(TestCase):
    def create(self):
        now = timezone.now()
        Event.objects.create(
            abstract="This is the abstract.", 
            place="KAIST", 
            time=now, 
            title="This is the title.",
            details="detail detail detail detail detail.")
        