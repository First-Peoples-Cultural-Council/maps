from django.contrib.auth.models import User
from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("id", "username", "first_name", "last_name", "email", 
                    "is_staff", "is_active", "is_superuser", 
                    "last_login", "date_joined")
