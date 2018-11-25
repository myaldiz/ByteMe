from django.db import models
from django.contrib.auth.models import User
from events.tag import Tag
# TODO: import classes from events app

class Person(models.Model):
	univ = models.CharField(max_length=100, null=True)
	dept = models.CharField(max_length=100, null=True)
	tags = models.ManyToManyField(Tag, default = None)

	class Meta:
		abstract = True

class Speaker(Person):
	name = models.CharField(max_length=50)
	speakerEmail = models.EmailField(primary_key = True, unique=True)
	bio = models.TextField(null=True)

	def __str__(self):
		return "%s"%(self.name)

class UserProfile(Person):
	user = models.OneToOneField(User, on_delete=models.CASCADE)	# email not saved in here
	# userEmail = models.EmailField(unique=True)
	isAdmin = models.BooleanField()

	def addTags(self, tags):
		pass

	def addAttend(self, identifier):
		pass

	def __str__(self):
		return "%s"%(self.user)
