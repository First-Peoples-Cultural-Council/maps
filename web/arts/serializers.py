from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer
from .models import Art


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
