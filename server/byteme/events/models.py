import uuid
from django.db import models
from accounts.models import Speaker, UserProfile
from .tag import Tag

class Event(models.Model):
	identifier = models.UUIDField(primary_key = True, default = uuid.uuid4, editable = False)
	creater = models.ForeignKey(UserProfile, on_delete = models.CASCADE, related_name="created", default = None)
	attendant = models.ManyToManyField(UserProfile, related_name="attendant", default = None)
	abstract = models.TextField(max_length = 3000)
	place = models.CharField(max_length = 100)
	time = models.DateTimeField()
	title = models.CharField(max_length = 300)
	details = models.TextField(max_length = 3000)
	tags = models.ManyToManyField(Tag, default = None, related_name="tags")
	speaker = models.ForeignKey(Speaker, on_delete = models.CASCADE, related_name="events", default = None)
	imgurl  =  models.CharField(max_length = 100, default=None, null=True)

	REQUEST = (
		('non', 'No Request'),
		('add', 'Addition'),
		('del', 'Deletion'),
		('mod', 'Modification'),
	)
	req = models.CharField(max_length=3, choices = REQUEST, default='non')
	abstractReq = models.TextField(max_length=3000, default=None, null=True , blank = True)
	placeReq = models.CharField(max_length=100, default=None, null=True, blank = True)
	timeReq = models.DateTimeField(default=None, null=True, blank = True)
	titleReq = models.CharField(max_length=300, default=None, null=True, blank = True)
	detailsReq = models.TextField(default=None, null=True, blank = True)
	tagsReq = models.ManyToManyField(Tag, related_name="tagsReq", default = None, blank = True)
	speakerReq = models.ForeignKey(Speaker, on_delete=models.CASCADE, related_name="speakerReq", default = None, null=True, blank = True)
	imgurLReq  = models.CharField(max_length = 100, default=None, null=True, blank = True)

	intersection_max = 5
	citation_max = 50000
	h_index_max = 100
	i_index_max = 1000

	def generateRankingScore(self, user):
		speaker = self.speaker
		user_tags = set(user.tags.all())
		event_tags = set(self.tags.all())
		speaker_tags = set(speaker.tags.all())
		inters_event_num = min(self.intersection_max, len(user_tags.intersection(event_tags)))
		inters_event_num = inters_event_num / self.intersection_max
		inters_speaker_num = min(self.intersection_max, len(user_tags.intersection(speaker_tags)))
		inters_speaker_num = inters_speaker_num / self.intersection_max

		i_score = inters_event_num * 0.2 + inters_speaker_num * 0.2
		i_score += (speaker.citations / self.citation_max) * 0.2
		i_score += (speaker.h_index / self.h_index_max) * 0.2
		i_score += (speaker.i_index / self.i_index_max) * 0.2
		i_score = min(i_score, 1.0)
		return i_score
	
	def __str__(self):
		return "%s %s"%(self.creater, self.title)


