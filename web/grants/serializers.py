from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer

from .models import Grant, GrantCategory


class GrantSerializer(GeoFeatureModelSerializer):
    category = serializers.CharField(source="grant_category.name", allow_null=True)
    category_abbreviation = serializers.CharField(
        source="grant_category.abbreviation", allow_null=True
    )

    class Meta:
        model = Grant
        fields = (
            "id",
            "grant",
            "recipient",
            "project_brief",
            "category",
            "amount",
            "category_abbreviation",
            "community_affiliation",
            "year",
        )
        geo_field = "point"


class GrantDetailSerializer(serializers.ModelSerializer):
    category = serializers.CharField(source="grant_category.name", allow_null=True)

    class Meta:
        model = Grant
        exclude = ("grant_category",)
        geo_field = "point"


class GrantCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = GrantCategory
        exclude = ()
