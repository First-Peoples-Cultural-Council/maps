from django.shortcuts import render

from .models import Language, PlaceName, Community, Champion, Media
from rest_framework import viewsets, generics, mixins
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from .serializers import (
    LanguageGeoSerializer,
    LanguageSerializer,
    LanguageDetailSerializer,
    PlaceNameSerializer,
    PlaceNameDetailSerializer,
    PlaceNameGeoSerializer,
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityGeoSerializer,
    ChampionSerializer,
    MediaSerializer,
)
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page


class BaseModelViewSet(viewsets.ModelViewSet):
    """
    Abstract base viewset that allows multiple serializers depending on action.
    """

    def get_serializer_class(self):
        if self.action == "retrieve" or self.action == "partial_update":
            if hasattr(self, "detail_serializer_class"):
                return self.detail_serializer_class

        return super().get_serializer_class()


class LanguageViewSet(BaseModelViewSet):
    serializer_class = LanguageSerializer
    detail_serializer_class = LanguageDetailSerializer
    queryset = (
        Language.objects.filter(geom__isnull=False)
        .select_related("family")
        .order_by("family", "name")
    )


class CommunityViewSet(BaseModelViewSet):
    serializer_class = CommunitySerializer
    detail_serializer_class = CommunityDetailSerializer
    queryset = Community.objects.all().order_by("name").exclude(point__isnull=True)

    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                languages=Language.objects.get(pk=request.GET.get("lang"))
            )
        serializer = CommunitySerializer(queryset, many=True)
        return Response(serializer.data)


class PlaceNameViewSet(BaseModelViewSet):
    serializer_class = PlaceNameSerializer
    detail_serializer_class = PlaceNameDetailSerializer
    queryset = PlaceName.objects.all().order_by("name")

    # def list(self, request):
    #     queryset = self.get_queryset()
    #     # if "lang" in request.GET:
    #     #     queryset = queryset.filter(
    #     #         languages=Language.objects.get(pk=request.GET.get("lang"))
    #     #     )
    #     serializer = PlaceNameSerializer(queryset, many=True)
    #     return Response(serializer.data)


# To enable onlye CREATE and DELETE, we create a custom ViewSet class...
class MediaCustomViewSet(mixins.CreateModelMixin, mixins.DestroyModelMixin, GenericViewSet):
    pass


class MediaViewSet(MediaCustomViewSet, BaseModelViewSet):
    serializer_class = MediaSerializer
    queryset = Media.objects.all()


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
        