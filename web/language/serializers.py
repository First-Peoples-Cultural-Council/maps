from .models import (
    Language,
    PlaceName,
    Community,
    Champion,
    LanguageSubFamily,
    LanguageFamily,
    LanguageLink,
    Dialect,
    CommunityLink,
)
from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer


class LanguageFamilySerializer(serializers.ModelSerializer):
    class Meta:
        model = LanguageFamily
        fields = ("name",)


class LanguageSubFamilySerializer(serializers.ModelSerializer):
    family = LanguageFamilySerializer(read_only=True)

    class Meta:
        model = LanguageSubFamily
        fields = ("name", "family")


class ChampionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Champion
        fields = ("name", "bio", "job", "community")


class LanguageLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = LanguageLink
        fields = ("title", "url")


class DialectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dialect
        fields = ("name",)


class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ("name",)


class LanguageDetailSerializer(serializers.ModelSerializer):
    sub_family = LanguageSubFamilySerializer(read_only=True)
    champion_set = ChampionSerializer(read_only=True, many=True)
    languagelink_set = LanguageLinkSerializer(read_only=True, many=True)
    dialect_set = DialectSerializer(read_only=True, many=True)

    class Meta:
        model = Language
        fields = (
            "id",
            "name",
            "other_names",
            "regions",
            "champion_set",
            "languagelink_set",
            "dialect_set",
            "fv_archive_link",
            "color",
            "sub_family",
            "notes",
            "fluent_speakers",
            "learners",
            "some_speakers",
            "pop_total_value",
            "bbox",
        )


class LanguageGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = Language
        fields = ("name", "color")
        geo_field = "geom"


class PlaceNameGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "other_name", "id")
        geo_field = "point"


class PlaceNameDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "other_name", "id")


class CommunityLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityLink
        fields = ("title", "url")


class CommunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name",)


class CommunityDetailSerializer(serializers.ModelSerializer):
    champion_set = ChampionSerializer(read_only=True, many=True)
    communitylink_set = CommunityLinkSerializer(read_only=True, many=True)

    class Meta:
        model = Community
        fields = (
            "id",
            "name",
            "languages",
            "regions",
            "champion_set",
            "communitylink_set",
            "english_name",
            "other_names",
            "internet_speed",
            "population",
            "email",
            "website",
            "phone",
            "alt_phone",
            "fax",
        )
        geo_field = "point"
