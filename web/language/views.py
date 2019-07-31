from django.shortcuts import render

from .models import Language, PlaceName, Community, Champion, Art
from rest_framework import viewsets, generics
from rest_framework.response import Response
from .serializers import (
    LanguageGeoSerializer,
    LanguageSerializer,
    LanguageDetailSerializer,
    PlaceNameGeoSerializer,
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityGeoSerializer,
    ChampionSerializer,
    ArtSerializer,
    ArtDetailSerializer,
)
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page


class LanguageList(generics.ListAPIView):
    """
    API endpoint that allows languages to be viewed or edited.
    """

    queryset = (
        Language.objects.filter(geom__isnull=False)
        .select_related("sub_family", "sub_family__family")
        .order_by("sub_family__family", "name")
    )
    serializer_class = LanguageSerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        serializer = LanguageSerializer(queryset, many=True)
        return Response(serializer.data)


class LanguageDetail(generics.RetrieveAPIView):
    serializer_class = LanguageDetailSerializer
    queryset = Language.objects.all()


class LanguageGeoList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False)
    serializer_class = LanguageGeoSerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        serializer = LanguageGeoSerializer(queryset, many=True)
        return Response(serializer.data)


class CommunityGeoList(generics.ListAPIView):
    queryset = Community.objects.filter(point__isnull=False).order_by("name")
    serializer_class = CommunityGeoSerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        serializer = CommunityGeoSerializer(queryset, many=True)
        return Response(serializer.data)


class CommunityList(generics.ListAPIView):

    queryset = Community.objects.all().order_by("name").exclude(point__isnull=True)
    serializer_class = CommunitySerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                languages=Language.objects.get(pk=request.GET.get("lang"))
            )
        serializer = CommunitySerializer(queryset, many=True)
        return Response(serializer.data)


class CommunityDetail(generics.RetrieveAPIView):
    serializer_class = CommunityDetailSerializer
    queryset = Community.objects.all()


class PlaceNameGeoList(generics.ListAPIView):

    queryset = PlaceName.objects.exclude(name__icontains="FirstVoices")
    serializer_class = PlaceNameGeoSerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            lang = Language.objects.get(pk=int(request.GET["lang"]))
            print(lang.geom)
            queryset = queryset.filter(point__intersects=lang.geom)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


class ArtList(generics.ListAPIView):

    queryset = Art.objects.all()
    serializer_class = ArtSerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            lang = Language.objects.get(pk=int(request.GET["lang"]))
            queryset = queryset.filter(point__intersects=lang.geom)
        serializer = ArtSerializer(queryset, many=True)
        return Response(serializer.data)


class ArtDetail(generics.RetrieveAPIView):
    serializer_class = ArtDetailSerializer
    queryset = Art.objects.all()
