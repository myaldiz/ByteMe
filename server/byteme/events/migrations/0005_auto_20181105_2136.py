# -*- coding: utf-8 -*-
# Generated by Django 1.11 on 2018-11-05 12:36
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('events', '0004_auto_20181105_2027'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='attendant',
            field=models.ManyToManyField(default=None, related_name='attendant', to='accounts.UserProfile'),
        ),
    ]