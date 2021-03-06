from django.db import models
from django.contrib.auth.models import User
from events.tag import Tag
# TODO: import classes from events app

class Person(models.Model):
	univ = models.CharField(max_length=100, null=True, default='KAIST')
	dept = models.CharField(max_length=100, null=True, default='Computer Science')
	tags = models.ManyToManyField(Tag, default = None)

	class Meta:
		abstract = True

class Speaker(Person):
	name = models.CharField(max_length=100)
	speakerEmail = models.EmailField(primary_key = True)
	bio = models.TextField(null=True)
	is_crawled = models.BooleanField(default=False)
	h_index = models.IntegerField(default=0)
	i_index = models.IntegerField(default=0)
	citations = models.IntegerField(default=0)

	def __str__(self):
		return "%s"%(self.name)

class UserProfile(Person):
	user = models.OneToOneField(User, on_delete=models.CASCADE)	# email not saved in here

	def __str__(self):
		return "%s, %s"%(self.user, self.univ)
