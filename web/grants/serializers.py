from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer

from .models import Grant


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
