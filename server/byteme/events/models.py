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
	abstractReq = models.TextField(max_length=3000)
	placeReq = models.CharField(max_length=100)
	timeReq = models.DateTimeField()
	titleReq = models.CharField(max_length=300)
	detailsReq = models.TextField()

	__rankingVector = models.DecimalField()

	def generateRankingVector():
		pass

class Tag(models.Model):
	name = models.CharField(max_length=30)
	rankingScore = models.DecimalField()

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
