# -*- coding: utf-8 -*-
# Generated by Django 1.11 on 2018-11-05 14:21
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('events', '0006_auto_20181105_2231'),
    ]

    operations = [
        migrations.AlterField(
            model_name='tag',
            name='rankingScore',
            field=models.DecimalField(decimal_places=2, max_digits=5),
        ),
    ]
