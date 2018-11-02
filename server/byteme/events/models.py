from django.db import models

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
	abstractReq = models.TextField(max_length=3000, default=None)
	placeReq = models.CharField(max_length=100, default=None)
	timeReq = models.DateTimeField(default=None)
	titleReq = models.CharField(max_length=300, default=None)
	detailsReq = models.TextField(default=None)

	rankingVector = models.DecimalField(decimal_places=0, max_digits=5)

	def generateRankingVector():
		pass

class Tag(models.Model):
	name = models.CharField(max_length=30)
	rankingScore = models.DecimalField(decimal_places=0, max_digits=5)

	def calculateRankingScore():
		pass

def addEvent(username, abstract, place, time, title, details):
	pass

def deleteEvent(username, identifier):
	pass

def modifyEvent(username, identifier, abstract, place, time, title, details):
	pass

def queryEvent(username):
	pass

def approveEventChange(identifier):
	pass
