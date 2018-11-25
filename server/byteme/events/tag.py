from django.db import models

class Tag(models.Model):
	name = models.CharField(max_length=30)
	rankingScore = models.DecimalField(decimal_places=2, max_digits=5, default = 5.0)

	def __str__(self):
		return "%s  %s"%(self.name, self.rankingScore)

	def calculateRankingScore():
		pass

	