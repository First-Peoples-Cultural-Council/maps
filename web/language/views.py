from django.shortcuts import render

from .models import Language, PlaceName, Community, Champion
from rest_framework import viewsets
from .serializers import LanguageSerializer, PlaceNameSerializer, CommunitySerializer, ChampionSerializer


class LanguageViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows languages to be viewed or edited.
    """

    queryset = Language.objects.all()
    serializer_class = LanguageSerializer


class CommunityViewSet(viewsets.ModelViewSet):

    queryset = Community.objects.all()
    serializer_class = CommunitySerializer


class PlaceNameViewSet(viewsets.ModelViewSet):

    queryset = PlaceName.objects.all()
    serializer_class = PlaceNameSerializer


class ChampionViewSet(viewsets.ModelViewSet):

    queryset = PlaceName.objects.all()
    serializer_class = PlaceNameSerializer
