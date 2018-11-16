from django.db import models

# Create your models here.
class Table(models.Model):
    table_name = models.CharField(max_length=200)
    create_time = models.DateTimeField('date published')

class Customer(models.Model):
    name = models.CharField(max_length=200)
    money = models.IntegerField(default=0)
    table = models.ForeignKey(Table, on_delete=models.CASCADE)
