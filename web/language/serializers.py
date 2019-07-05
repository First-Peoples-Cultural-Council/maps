from .models import Language, PlaceName, Community, Champion
from rest_framework import serializers


class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ('name', 'other_names',
                  'fv_archive_link', 'color', 'sub_family', 'notes')


class PlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ('name', 'other_name')


class CommunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ('name', 'language')


class ChampionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Champion
        fields = ('name', 'bio', 'job', 'community', 'language')
