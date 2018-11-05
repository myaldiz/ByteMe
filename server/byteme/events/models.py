import uuid
from django.db import models
from accounts.models import Speaker, UserProfile
from .tag import Tag

class Event(models.Model):
	identifier = models.UUIDField(primary_key = True, default = uuid.uuid4, editable = False)
	creater = models.ForeignKey(UserProfile, on_delete = models.CASCADE, related_name="creater", default = None)
	attendant = models.ManyToManyField(UserProfile, related_name="attendant", default = None)
	abstract = models.TextField(max_length = 3000)
	place = models.CharField(max_length = 100)
	time = models.DateTimeField()
	title = models.CharField(max_length = 300)
	details = models.TextField()
	tags = models.ManyToManyField(Tag, related_name="tags")
	speaker = models.ForeignKey(Speaker, on_delete = models.CASCADE, related_name="speacker", default = None)

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
	tagsReq = models.ManyToManyField(Tag, related_name="tagsReq", default = None)
	speakerReq = models.ForeignKey(Speaker, on_delete=models.CASCADE, related_name="speakerReq", default = None, null=True)

	rankingVector = models.DecimalField(decimal_places=0, max_digits=5, null=True)

	#TODO poster_image

	def generateRankingVector():
		pass
	
	def __str__(self):
		return str(self.identifier)


