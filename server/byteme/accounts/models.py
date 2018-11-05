from django.db import models
from django.contrib.auth.models import User
from byteme.events import Tag, Event
# TODO: import classes from events app

class Person(models.Model):
	univ = models.CharField(max_length=100)
	dept = models.CharField(max_length=100)
	tags = models.ManyToManyField(Tag)		# why do we need this

	class Meta:
		abstract = True

class Speaker(Person):
	name = models.CharField(max_length=50)
	speakerEmail = models.EmailField(unique=True)
	bio = models.TextField()

class UserProfile(Person):
	user = models.OneToOneField(User, on_delete=models.CASCADE)
	userEmail = models.EmailField(unique=True)
	isAdmin = models.BooleanField()
	attends = models.ManyToManyField(Event)

	def addTags(self, tags):
		pass

	def addAttend(self, identifier):
		pass

	def __str__(self):
		return "%s"%(self.user)

def createUser(email, username, password, isAdmin=False):
	pass
