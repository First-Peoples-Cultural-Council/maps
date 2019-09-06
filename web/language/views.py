import sys

from django.shortcuts import render
from django.db.models import Q

from users.models import User
from .models import (
    Language,
    PlaceName,
    Community,
    CommunityMember,
    Champion,
    PlaceNameCategory,
    Media,
    Favourite,
    CommunityLanguageStats,
)

from django.views.decorators.cache import never_cache
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
    PlaceNameCategorySerializer,
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityMemberSerializer,
    CommunityGeoSerializer,
    ChampionSerializer,
    MediaSerializer,
    FavouriteSerializer,
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
        user_id = int(request.data["user"]["id"])
        language_id = int(request.data["language"]["id"])
        language = Language.objects.get(pk=language_id)
        user = User.objects.get(pk=user_id)
        user.languages.add(language)
        user.save_m2m()
        # TODO: use relationship here instead.
        # if LanguageMember.member_already_exists(user_id, language_id):
        #     return Response({"message", "User is already a language member"})
        # else:
        #     member = LanguageMember.create_member(user_id, language_id)
        #     serializer = LanguageMemberSerializer(member)
        #     return Response(serializer.data)


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

        user_id = int(request.data["user"]["id"])
        community_id = int(request.data["community"]["id"])
        community = Community.objects.get(pk=community_id)
        user = User.objects.get(pk=user_id)
        user.communities.add(community)
        user.save_m2m()

    @action(detail=False)
    def create_self_membership(self, request):
        if request.user.is_authenticated:
            request = self.context.get("request")
            if request and hasattr(request, "user"):
                user_id = request.user.id
                if user_id != request.GET.get("user")["id"]:
                    return Response(
                        {"message": "Can only add yourself, not others."},
                        status=status.HTTP_401_UNAUTHORIZED,
                    )
                community_id = int(request.data["community"]["id"])
                if CommunityMember.member_already_exists(user_id, community_id):
                    return Response({"message", "User is already a community member"})
                else:
                    member = CommunityMember.create_member(user_id, community_id)
                    serializer = CommunityMemberSerializer(member)
                    return Response(serializer.data)
            else:
                content = {"message": "User is not logged in"}
                return Response(content, status=status.HTTP_401_UNAUTHORIZED)
        else:
            content = {"message": "User is not logged in"}
            return Response(content, status=status.HTTP_401_UNAUTHORIZED)

    @action(detail=False)
    def verify_membership(self, request):
        user_id = int(request.data["user"]["id"])
        community_id = int(request.data["community"]["id"])
        if CommunityMember.member_already_exists(user_id, community_id):
            member = CommunityMember.objects.filter(user__id=user_id).filter(
                community__id=community_id
            )
            CommunityMember.verify_membership(member.id)

            return Response({"message": "Verified!"})
        else:
            return Response({"message", "User is already a community member"})


class CommunityLanguageStatsViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = CommunityLanguageStatsSerializer
    detail_serializer_class = CommunityLanguageStatsSerializer
    queryset = CommunityLanguageStats.objects.all()


class ChampionViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = ChampionSerializer
    detail_serializer_class = ChampionSerializer
    queryset = Champion.objects.all()


class PlaceNameCategoryViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = PlaceNameCategorySerializer
    detail_serializer_class = PlaceNameCategorySerializer
    queryset = PlaceNameCategory.objects.all()


class PlaceNameViewSet(BaseModelViewSet):
    serializer_class = PlaceNameSerializer
    detail_serializer_class = PlaceNameDetailSerializer
    queryset = PlaceName.objects.all().order_by("name")

    def perform_create(self, serializer):
        serializer.save(creator=self.request.user)

    # def create(self, request):
    #     community_id = int(request.data["community"]["id"])
    #     language_id = int(request.data["language"]["id"])

    #     community = Community.objects.get(pk=community_id)
    #     language = Language.objects.get(pk=language_id)

    #     serializer = PlaceNameSerializer(data=request.data)
    #     serializer.language = language
    #     serializer.community = community

    #     serializer.is_valid(raise_exception=True)

    #     serializer.save()
    #     return Response(serializer.data)

    @action(detail=True)
    def verify(self, request, pk):
        placename = PlaceName.objects.get(pk=int(pk))
        placename.status = PlaceName.VERIFIED
        placename.status_reason = ""
        placename.save()

        return Response({"message": "Verified!"})

    @action(detail=True, methods=["patch"])
    def flag(self, request, pk):
        placename = PlaceName.objects.get(pk=int(pk))
        if placename.status == PlaceName.VERIFIED:
            return Response({"message": "PlaceName has already been verified"})
        else:
            placename.status = PlaceName.FLAGGED
            placename.status_reason = request.data["status_reason"]
            placename.save()
            return Response({"message": "Flagged!"})

    @method_decorator(never_cache)
    def detail(self, request):
        return super().detail(request)

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        queryset = self.get_queryset()

        # Testing if user is VERIFIED
        user_is_verified = False
        if request.user.is_authenticated:
            if request and hasattr(request, "user"):
                user = User.objects.get(pk=int(request.user.id))

        if user_is_verified:
            queryset = queryset.filter(
                Q(community_only=False)
                | Q(community_only__isnull=True)
                | Q(community=user.communities_set)
            )
        else:
            queryset = queryset.filter(
                Q(community_only=False) | Q(community_only__isnull=True)
            )

        if "lang" in request.GET:
            queryset = queryset.filter(
                point__intersects=Language.objects.get(pk=request.GET.get("lang")).geom
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' PlaceNames do not need to the verified
        queryset = self.get_queryset().exclude(status__exact=PlaceName.VERIFIED)

        # Testing if user is VERIFIED        
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:                
                user = User.objects.get(pk=int(request.user.id))

                # Fetch all user's languages
                languages = user.languages.all()

                if languages:
                    # Filter VERIFIED PlaceNames by user's languages 
                    queryset = queryset.filter(language__in=languages)

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
class FavouriteCustomViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    mixins.DestroyModelMixin,
    GenericViewSet,
):
    pass


class FavouriteViewSet(FavouriteCustomViewSet, GenericViewSet):
    serializer_class = FavouriteSerializer
    queryset = Favourite.objects.all()

    # def create(self, request):
    #     user_id = int(request.data["user"]["id"])
    #     media_id = int(request.data["media"]["id"])
    #     if Favourite.favourite_already_exists(user_id, media_id):
    #         return Response({"message", "Media is already a user's favorite"})
    #     else:
    #         favourite = Favourite.create_favourite(user_id, media_id)
    #         serializer = FavouriteSerializer(favourite)
    #         return Response(serializer.data)


class LanguageGeoList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False)
    serializer_class = LanguageGeoSerializer


class CommunityGeoList(generics.ListAPIView):
    queryset = Community.objects.filter(point__isnull=False).order_by("name")
    serializer_class = CommunityGeoSerializer


class PlaceNameGeoList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(
        name__icontains="FirstVoices", geom__isnull=False
    )
    serializer_class = PlaceNameGeoSerializer

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                geom__intersects=Language.objects.get(pk=request.GET.get("lang")).geom
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

