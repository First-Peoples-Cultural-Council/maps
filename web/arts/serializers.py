from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer
from users.serializers import PublicUserSerializer

from .models import (
    Art,
    Association,
    ArtCategory,
    Artist,
    ArtistAward,
    ArtistLink,
    ArtistMedia,
)


class ArtSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = Art
        fields = ("id", "art_type", "name")
        geo_field = "point"


class ArtDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Art
        fields = ("id", "point", "art_type", "name", "node_id", "details")
        geo_field = "point"


class AssociationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Association
        fields = ("id", "name")


class ArtCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ArtCategory
        fields = ("id", "name", "category_type")


class ArtistSerializer(serializers.ModelSerializer):
    user = PublicUserSerializer(read_only=True)
    class Meta:
        model = Artist
        fields = (
            "id", 
            "subtitle",
            "statement",
            # "categories",
            # "associations",
            "user",
            "phone",
            "address"
        )
        geo_field = "point"


class ArtistLightSerializer(serializers.ModelSerializer):
    user = PublicUserSerializer(read_only=True)
    class Meta:
        model = Artist
        fields = (
            "id", 
            "user", 
        )
        geo_field = "point"


class ArtistAwardSerializer(serializers.ModelSerializer):
    artist = ArtistLightSerializer(read_only=True)
    class Meta:
        model = ArtistAward
        fields = ("id", "name", "artist")


class ArtistLinkSerializer(serializers.ModelSerializer):
    artist = ArtistLightSerializer(read_only=True)
    class Meta:
        model = ArtistLink
        fields = ("id", "name", "artist", "url")


class ArtistMediaSerializer(serializers.ModelSerializer):
    artist = ArtistLightSerializer(read_only=True)
    class Meta:
        model = ArtistMedia
        fields = (
            "id", 
            "name", 
            "artist", 
            "description", 
            "media_file", 
            "media_url", 
            "media_type"
        )

