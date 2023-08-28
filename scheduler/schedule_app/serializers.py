from .models import User, Group, Todo
from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["name", "nickname"]


class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = ["name", "owner", "description", "created_at", "updated_at", "member"]
        read_only_fields = ["owner", "created_at", "updated_at"]


class TodoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = "__all__"
        read_only_fields = ["owner", "created_at", "updated_at"]
