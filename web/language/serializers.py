from .models import Language, PlaceName, Community, Champion, LanguageSubFamily, LanguageFamily
from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer


class LanguageFamilySerializer(serializers.ModelSerializer):

    class Meta:
        model = LanguageFamily
        fields = ('name',)


class LanguageSubFamilySerializer(serializers.ModelSerializer):
    family = LanguageFamilySerializer(read_only=True)
    class Meta:
        model = LanguageSubFamily
        fields = ('name','family')


class LanguageSerializer(serializers.ModelSerializer):
    sub_family = LanguageSubFamilySerializer(read_only=True)
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
