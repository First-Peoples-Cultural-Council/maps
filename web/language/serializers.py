from .models import Language, PlaceName, Community, Champion
from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer


class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ('name', 'other_names',
                  'fv_archive_link', 'color', 'sub_family', 'notes')


class PlaceNameSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = PlaceName
        fields = ('name', 'other_name',)
        geo_field = "point"


class CommunitySerializer(GeoFeatureModelSerializer):
    class Meta:
        model = Community
        fields = ('name', 'language',)
        geo_field = "point"


class ChampionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Champion
        fields = ('name', 'bio', 'job', 'community', 'language')
