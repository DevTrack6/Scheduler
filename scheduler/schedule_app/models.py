from django.db import models


# Create your models here.
class User(models.Model):
    name = models.CharField(max_length=200)
    nickname = models.CharField(max_length=200)
    password = models.CharField(max_length=200)
    friends = models.ManyToManyField("self", blank=True)


class Group(models.Model):
    name = models.CharField(max_length=200)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    description = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    member = models.ManyToManyField(User, blank=True, related_name="groups")


class Todo(models.Model):
    class Status(models.IntegerChoices):
        TODO = 0
        DOING = 1
        DONE = 2

    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, null=True)
    share_friends = models.BooleanField(default=False)
    title = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    status = models.IntegerField(choices=Status.choices, default=Status.TODO)
    start_todo = models.DateTimeField(null=True)
    end_todo = models.DateTimeField(null=True)
    content = models.TextField(null=True)
