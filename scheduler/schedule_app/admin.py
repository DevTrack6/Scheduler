from django.contrib import admin

from .models import Group, Todo, User

# Register your models here.
admin.site.register(User)
admin.site.register(Group)
admin.site.register(Todo)
