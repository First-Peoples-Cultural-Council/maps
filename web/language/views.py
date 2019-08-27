import sys

from django.shortcuts import render

from .models import (
    Language, 
    LanguageMember, 
    PlaceName, 
    Community, 
    CommunityMember, 
    Champion, 
    Media,
    MediaFavourite,
    CommunityLanguageStats,
)

from rest_framework import viewsets, generics, mixins
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from .serializers import (
    LanguageGeoSerializer,
    LanguageSerializer,
    LanguageDetailSerializer,
    LanguageMemberSerializer,
    PlaceNameSerializer,
    PlaceNameDetailSerializer,
    PlaceNameGeoSerializer,
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityMemberSerializer,
    CommunityGeoSerializer,
    ChampionSerializer,
    MediaSerializer,
    MediaFavouriteSerializer,
    CommunityLanguageStatsSerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from web.permissions import IsAdminOrReadOnly


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
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = LanguageSerializer
    detail_serializer_class = LanguageDetailSerializer
    queryset = (
        Language.objects.filter(geom__isnull=False)
        .select_related("family")
        .order_by("family", "name")
    )

    def create_membership(self, request):
        try:
            user_id = int(request.data['user']['id'])
            language_id = int(request.data['language']['id'])
            if LanguageMember.member_already_exists(user_id, language_id):
                return Response({"message", "User is already a language member"})
            else:
                member = LanguageMember.create_member(user_id, language_id)
                serializer = LanguageMemberSerializer(member)
                return Response(serializer.data)
        except:
            return Response("Unexpected error:", sys.exc_info()[0])


# class LanguageMemberViewSet(BaseModelViewSet):
#     serializer_class = LanguageMemberSerializer
#     queryset = LanguageMember.objects.all()

#     # def create(self, request):
#     #     try:
#     #         user_id = int(request.data['user']['id'])
#     #         language_id = int(request.data['language']['id'])
#     #         if LanguageMember.member_already_exists(user_id, language_id):
#     #             return Response({"message", "User is already a language member"})
#     #         else:
#     #             member = LanguageMember.create_member(user_id, language_id)
#     #             serializer = LanguageMemberSerializer(member)
#     #             return Response(serializer.data)
#     #     except:
#     #         return Response("Unexpected error:", sys.exc_info()[0])


class CommunityViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = CommunitySerializer
    detail_serializer_class = CommunityDetailSerializer
    queryset = Community.objects.all().order_by("name").exclude(point__isnull=True)

    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                languages=Language.objects.get(pk=request.GET.get("lang"))
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

    def create_membership(self, request):
        try:
            user_id = int(request.data['user']['id'])
            community_id = int(request.data['community']['id'])
            if CommunityMember.member_already_exists(user_id, community_id):
                return Response({"message", "User is already a community member"})
            else:
                member = CommunityMember.create_member(user_id, community_id)
                serializer = CommunityMemberSerializer(member)
                return Response(serializer.data)
        except:
            return Response("Unexpected error:", sys.exc_info()[0])


# class CommunityMemberViewSet(BaseModelViewSet):
#     serializer_class = CommunityMemberSerializer
#     queryset = CommunityMember.objects.all()

#     def create(self, request):
#         try:
#             user_id = int(request.data['user']['id'])
#             community_id = int(request.data['community']['id'])
#             if CommunityMember.member_already_exists(user_id, community_id):
#                 return Response({"message", "User is already a community member"})
#             else:
#                 member = CommunityMember.create_member(user_id, community_id)
#                 serializer = CommunityMemberSerializer(member)
#                 return Response(serializer.data)
#         except:
#             return Response("Unexpected error:", sys.exc_info()[0])


class CommunityLanguageStatsViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = CommunityLanguageStatsSerializer
    detail_serializer_class = CommunityLanguageStatsSerializer
    queryset = CommunityLanguageStats.objects.all()


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

    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                point__intersects=Language.objects.get(pk=request.GET.get("lang")).geom
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


# To enable only CREATE and DELETE, we create a custom ViewSet class...
class MediaCustomViewSet(
    mixins.CreateModelMixin, mixins.DestroyModelMixin, GenericViewSet
):
    pass


class MediaViewSet(MediaCustomViewSet, GenericViewSet):
    serializer_class = MediaSerializer
    queryset = Media.objects.all()


# To enable only CREATE and DELETE, we create a custom ViewSet class...
class MediaFavouriteCustomViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    mixins.DestroyModelMixin,
    GenericViewSet,
):
    pass


class MediaFavouriteViewSet(MediaFavouriteCustomViewSet, GenericViewSet):
    serializer_class = MediaFavouriteSerializer
    queryset = MediaFavourite.objects.all()

    def create(self, request):
        try:
            user_id = int(request.data["user"]["id"])
            media_id = int(request.data["media"]["id"])
            if MediaFavourite.favourite_already_exists(user_id, media_id):
                return Response({"message", "Media is already a user's favorite"})
            else:
                favourite = MediaFavourite.create_favourite(user_id, media_id)
                serializer = MediaFavouriteSerializer(favourite)
                return Response(serializer.data)
        except:
            return Response("Unexpected error:", sys.exc_info()[0])


class LanguageGeoList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False)
    serializer_class = LanguageGeoSerializer


class CommunityGeoList(generics.ListAPIView):
    queryset = Community.objects.filter(point__isnull=False).order_by("name")
    serializer_class = CommunityGeoSerializer


class PlaceNameGeoList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(name__icontains="FirstVoices")
    serializer_class = PlaceNameGeoSerializer

    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                point__intersects=Language.objects.get(pk=request.GET.get("lang")).geom
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)
