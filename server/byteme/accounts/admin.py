from django.contrib import admin
from .models import Speaker, UserProfile 
from rest_framework.authtoken.admin import TokenAdmin


# Register your models here.
admin.site.register(Speaker)
admin.site.register(UserProfile)
TokenAdmin.raw_id_fields = ('user',)