from rest_framework import serializers

from .models import User

from language.models import (
    Language,
    Community,
)


class CommunityUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "id")


class LanguageUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ("name", "id")


class UserSerializer(serializers.ModelSerializer):
    communities = CommunityUserSerializer(read_only=True, many=True)
    languages = LanguageUserSerializer(read_only=True, many=True)
    
    class Meta:
        model = User
        fields = ("id", "username", "first_name", "last_name", "email", 
                    "is_staff", "is_active", "is_superuser", 
                    "last_login", "date_joined", "communities", "languages")
