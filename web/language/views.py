from django.shortcuts import render

from .models import Language, PlaceName, Community, CommunityMember, Champion, Media
from rest_framework import viewsets, generics, mixins
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action
from .serializers import (
    LanguageGeoSerializer,
    LanguageSerializer,
    LanguageDetailSerializer,
    PlaceNameSerializer,
    PlaceNameDetailSerializer,
    PlaceNameGeoSerializer,
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityMemberSerializer,
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
        if self.action != "list":
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


class CommunityMemberViewSet(BaseModelViewSet):
    serializer_class = CommunityMemberSerializer
    queryset = CommunityMember.objects.all()


class PlaceNameViewSet(BaseModelViewSet):
    serializer_class = PlaceNameSerializer
    detail_serializer_class = PlaceNameDetailSerializer
    queryset = PlaceName.objects.all().order_by("name")

    @action(detail=True)
    def verify(self, request, pk):
        placename = PlaceName.objects.get(pk=int(pk))
        placename.status = PlaceName.VERIFIED
        placename.save()

        return Response({"message": "Verified!"})

    @action(detail=True)
    def flag(self, request, pk):
        placename = PlaceName.objects.get(pk=int(pk))
        if placename.status == PlaceName.VERIFIED:
            return Response({"message": "PlaceName has already been verified"})
        else:
            placename.status = PlaceName.FLAGGED
            placename.save()
            return Response({"message": "Flagged!"})


# To enable onlye CREATE and DELETE, we create a custom ViewSet class...
class MediaCustomViewSet(mixins.CreateModelMixin, mixins.DestroyModelMixin, GenericViewSet):
    pass


class MediaViewSet(MediaCustomViewSet, GenericViewSet):
    serializer_class = MediaSerializer
    queryset = Media.objects.all()


class LanguageGeoList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False)
    serializer_class = LanguageGeoSerializer


class CommunityGeoList(generics.ListAPIView):
    queryset = Community.objects.filter(point__isnull=False).order_by("name")
    serializer_class = CommunityGeoSerializer


class PlaceNameGeoList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(name__icontains="FirstVoices")
    serializer_class = PlaceNameGeoSerializer
