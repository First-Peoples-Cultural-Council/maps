from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer

from .models import Grant, GrantCategory


class GrantSerializer(GeoFeatureModelSerializer):

    class Meta:
        model = Grant
        fields = ("id", "grant", "recipient", "project_brief",
                  "category", "community_affiliation", "year")
        geo_field = "point"


class GrantDetailSerializer(serializers.ModelSerializer):

    class Meta:
        model = Grant
        fields = "__all__"
        geo_field = "point"


class GrantCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = GrantCategory
        exclude = ("abbreviation",)