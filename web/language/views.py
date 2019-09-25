import sys

from django.shortcuts import render
from django.db.models import Q

from users.models import User, Administrator
from .models import (
    Language,
    PlaceName,
    Community,
    CommunityMember,
    Champion,
    PlaceNameCategory,
    Media,
    Favourite,
    Notification,
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
    NotificationSerializer,
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
        # if LanguageMember.member_exists(user_id, language_id):
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

    @action(detail=True, methods=["post"])
    def create_membership(self, request, pk):
        if 'user_id' not in request.data.keys():
            return Response({"message": "No User was sent in the request"})
        if not pk:
            return Response({"message": "No Community was sent in the request"})
        user_id = int(request.data["user_id"])
        community_id = int(pk)
        community = Community.objects.get(pk=community_id)
        user = User.objects.get(pk=user_id)
        user.communities.add(community)
        user.save()
        return Response({"message": "Membership created"})

    @method_decorator(never_cache)
    @action(detail=False)
    def list_member_to_verify(self, request):
        # 'VERIFIED' 'REJECTED' members do not need to the verified
        members = CommunityMember.objects.exclude(status__exact=Media.VERIFIED).exclude(status__exact=Media.REJECTED)        
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                # Getting the communities of the admin
                admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')
                if admin_communities:                
                    # Filter members by user's communities 
                    members = members.filter(community__in=admin_communities)
                    serializer = CommunityMemberSerializer(members, many=True)                    
                    return Response(serializer.data)
        return Response([])

    @action(detail=False, methods=["patch"])
    def verify_member(self, request):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                user_id = int(request.data["user_id"])
                community_id = int(request.data["community_id"])
                if CommunityMember.member_exists(user_id, community_id):
                    member = CommunityMember.objects.filter(user__id=user_id).filter(
                        community__id=community_id
                    )
                    CommunityMember.verify_member(member[0].id)

                    return Response({"message": "Verified!"})
                else:
                    return Response({"message", "User is already a community member"})
        
        return Response({"message", "Only Administrators can verify community members"})

    @action(detail=False, methods=["patch"])
    def reject_member(self, request):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                if 'user_id' not in request.data.keys():
                    return Response({"message": "No User was sent in the request"})
                if 'community_id' not in request.data.keys():
                    return Response({"message": "No Community was sent in the request"})

                user_id = int(request.data["user_id"])
                community_id = int(request.data["community_id"])
                try:            
                    if CommunityMember.member_exists(user_id, community_id):
                        member = CommunityMember.objects.filter(user__id=user_id).filter(
                            community__id=community_id
                        )
                        CommunityMember.reject_member(member[0].id)

                        return Response({"message": "Rejected!"})
                    else:
                        return Response({"message", "Membership not found"})
                except User.DoesNotExist:
                    return Response({"message": "No User with the given id was found"})
                except Community.DoesNotExist:
                    return Response({"message": "No Community with the given id was found"})
        
        return Response({"message", "Only Administrators can reject community members"})


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

    @action(detail=True, methods=["patch"])
    def verify(self, request, pk):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                try:
                    PlaceName.verify(int(pk))
                    return Response({"message": "Verified!"})
                except PlaceName.DoesNotExist:
                    return Response({"message": "No PlaceName with the given id was found"})
        
        return Response({"message", "Only Administrators can verify contributions"})

    @action(detail=True, methods=["patch"])
    def reject(self, request, pk):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                try:
                    if 'status_reason' in request.data.keys():
                        PlaceName.reject(int(pk), request.data["status_reason"])
                        return Response({"message": "Rejected!"})
                    else:
                        return Response({"message": "Reason must be provided"})
                except PlaceName.DoesNotExist:
                    return Response({"message": "No PlaceName with the given id was found"})
        
        return Response({"message", "Only Administrators can reject contributions"})

    @action(detail=True, methods=["patch"])
    def flag(self, request, pk):
        try:
            placename = PlaceName.objects.get(pk=int(pk))
            if placename.status == PlaceName.VERIFIED:
                return Response({"message": "PlaceName has already been verified"})
            else:
                if 'status_reason' in request.data.keys():
                    PlaceName.flag(int(pk), request.data["status_reason"])
                    return Response({"message": "Flagged!"})
                else:
                    return Response({"message": "Reason must be provided"})
        except PlaceName.DoesNotExist:
            return Response({"message": "No PlaceName with the given id was found"})

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

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                admin_languages = Administrator.objects.filter(user__id=int(request.user.id)).values('language')
                admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')

                if admin_languages and admin_communities:
                    # Filter Medias by admin's languages 
                    queryset_places = queryset.filter(
                        language__in=admin_languages, community__in=admin_communities
                    )

                    serializer = self.serializer_class(queryset_places, many=True)
                    
                    return Response(serializer.data)
        return Response([])


# To enable only CREATE and DELETE, we create a custom ViewSet class...
class MediaCustomViewSet(
    mixins.CreateModelMixin, 
    mixins.DestroyModelMixin, 
    mixins.RetrieveModelMixin,
    GenericViewSet
):
    pass


class MediaViewSet(MediaCustomViewSet, GenericViewSet):
    serializer_class = MediaSerializer
    queryset = Media.objects.all()

    def perform_create(self, serializer):
        serializer.save(creator=self.request.user)

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' Media do not need to the verified
        queryset = self.get_queryset().exclude(status__exact=Media.VERIFIED)

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                admin_languages = Administrator.objects.filter(user__id=int(request.user.id)).values('language')
                admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')

                if admin_languages and admin_communities:
                    # Filter Medias by admin's languages 
                    queryset_places = queryset.filter(
                        placename__language__in=admin_languages, placename__community__in=admin_communities
                    )
                    queryset_communities = queryset.filter(
                        community__languages__in=admin_languages, community__in=admin_communities
                    )
                    queryset = queryset_communities.union(queryset_places)

                    serializer = self.serializer_class(queryset, many=True)
                    
                    return Response(serializer.data)
        return Response([])

    @action(detail=True, methods=["patch"])
    def verify(self, request, pk):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                try:
                    Media.verify(int(pk))
                    return Response({"message": "Verified!"})
                except Media.DoesNotExist:
                    return Response({"message": "No Media with the given id was found"})
        
        return Response({"message", "Only Administrators can verify contributions"})

    @action(detail=True, methods=["patch"])
    def reject(self, request, pk):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                try:
                    if 'status_reason' in request.data.keys():
                        Media.reject(int(pk), request.data["status_reason"])
                        return Response({"message": "Rejected!"})
                    else:
                        return Response({"message": "Reason must be provided"})
                except Media.DoesNotExist:
                    return Response({"message": "No Media with the given id was found"})
        
        return Response({"message", "Only Administrators can reject contributions"})

    @action(detail=True, methods=["patch"])
    def flag(self, request, pk):
        try:
            media = Media.objects.get(pk=int(pk))
            if media.status == Media.VERIFIED:
                return Response({"message": "Media has already been verified"})
            else:
                if 'status_reason' in request.data.keys():
                    Media.flag(int(pk), request.data["status_reason"])
                    return Response({"message": "Flagged!"})
                else:
                    return Response({"message": "Reason must be provided"})
        except Media.DoesNotExist:
            return Response({"message": "No Media with the given id was found"})


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


class NotificationViewSet(BaseModelViewSet):
    serializer_class = NotificationSerializer
    queryset = Notification.objects.all()

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


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
