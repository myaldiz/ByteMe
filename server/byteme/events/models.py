from django.db import models
import uuid

class Event(models.Model):
	identifier = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
	abstract = models.TextField(max_length=3000)
	place = models.CharField(max_length=100)
	time = models.DateTimeField()
	title = models.CharField(max_length=300)
	details = models.TextField()

	REQUEST = (
		('non', 'No Request'),
		('add', 'Addition'),
		('del', 'Deletion'),
		('mod', 'Modification'),
	)
	req = models.CharField(max_length=3, choices = REQUEST, default='non')
	abstractReq = models.TextField(max_length=3000, default=None, null=True)
	placeReq = models.CharField(max_length=100, default=None, null=True)
	timeReq = models.DateTimeField(default=None, null=True)
	titleReq = models.CharField(max_length=300, default=None, null=True)
	detailsReq = models.TextField(default=None, null=True)

	rankingVector = models.DecimalField(decimal_places=0, max_digits=5, null=True)

	#TODO poster_image

	def generateRankingVector():
		pass
	
	def __str__(self):
		return str(self.identifier)


class Tag(models.Model):
	name = models.CharField(max_length=30)
	rankingScore = models.DecimalField(decimal_places=0, max_digits=5)

	def calculateRankingScore():
		pass

class EventHandler():
	def addEvent(self, username, identifier, abstract = None, place = None, time = None, title = None, details = None):
		event = Event.objects.get(identifier = identifier)
		event.req = "non"
		event.save()
		return event

	def deleteEvent(self, username, identifier):
		Event.objects.get(identifier = identifier).delete()
		return

	def modifyEvent(self, username, identifier, abstract = None, place= None, time= None, title= None, details= None):
		event = Event.objects.get(identifier = identifier)
		event.abstract = event.abstractReq
		event.place    = event.placeReq
		event.time     = event.timeReq
		event.title    = event.titleReq
		event.details  = event.detailsReq
		event.req      = "non"
		event.abstractReq = None
		event.placeReq	  = None
		event.timeReq	  = None
		event.titleReq	  = None
		event.detailsReq  = None
		event.save()
		return event

	def queryEvent(self, username):
		try:
			return Event.objects.all()
		except Event.DoesNotExist:
			raise Http404

	def approveEventChange(self, identifier, req):
		if req == "mod":
			return self.modifyEvent(username = None, identifier = identifier)

		if req == "add":
			return self.addEvent(username = None, identifier = identifier)

		if req == "del":
			self.deleteEvent(username = None, identifier = identifier)
			return True

