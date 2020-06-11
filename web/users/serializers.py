from rest_framework import serializers

from .models import User, Administrator

from language.models import Language, Community, PlaceName


class CommunityUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "id")


class LanguageUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ("name", "id")


class PlaceNameUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "id", "kind")


class AdministratorUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Administrator
        fields = ("id", )


class UserSerializer(serializers.ModelSerializer):
    communities = CommunityUserSerializer(read_only=True, many=True)
    languages = LanguageUserSerializer(read_only=True, many=True)
    placename_set = PlaceNameUserSerializer(read_only=True, many=True)
    administrator_set = AdministratorUserSerializer(read_only=True, many=True)

    community_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Community.objects.all(),
        write_only=True,
        source="communities",
        required=False,
    )
    language_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Language.objects.all(),
        write_only=True,
        source="languages",
        required=False,
    )

    class Meta:
        model = User
        fields = (
            "id",
            "username",
            "first_name",
            "last_name",
            "email",
            "bio",
            "is_staff",
            "is_active",
            "is_superuser",
            "last_login",
            "date_joined",
            "communities",
            "languages",
            "placename_set",
            "administrator_set",
            "community_ids",
            "language_ids",
            "notification_frequency",
            "picture",
        )


class PublicUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("id", "username", "first_name", "last_name", "picture")

