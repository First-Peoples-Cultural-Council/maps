from django.shortcuts import render

from .models import Language, PlaceName, Community, Champion
from rest_framework import viewsets, generics
from rest_framework.response import Response
from .serializers import (
    LanguageGeoSerializer, LanguageSerializer, PlaceNameSerializer, CommunitySerializer, ChampionSerializer
)
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page



class LanguageViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows languages to be viewed or edited.
    """

    queryset = Language.objects.all()
    serializer_class = LanguageSerializer

class LanguageGeoList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False)
    serializer_class = LanguageGeoSerializer
    
    @method_decorator(cache_page(60*60*2))
    def list(self, request):
        queryset = self.get_queryset()
        serializer = LanguageGeoSerializer(queryset, many=True)
        return Response(serializer.data)

class CommunityViewSet(viewsets.ModelViewSet):

    queryset = Community.objects.all()
    serializer_class = CommunitySerializer


class PlaceNameViewSet(viewsets.ModelViewSet):

    queryset = PlaceName.objects.all()
    serializer_class = PlaceNameSerializer


class ChampionViewSet(viewsets.ModelViewSet):

    queryset = Champion.objects.all()
    serializer_class = ChampionSerializer
