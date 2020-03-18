import sys

from django.shortcuts import render
from django.db.models import Q
from django_filters.rest_framework import DjangoFilterBackend

from users.models import User, Administrator
from language.models import (
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
from language.notifications import (
    inform_placename_rejected_or_flagged,
    inform_placename_to_be_verified,
)

from django.views.decorators.cache import never_cache
from rest_framework import viewsets, generics, mixins, status
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from language.views import BaseModelViewSet

from language.serializers import (
    PlaceNameSerializer,
    PlaceNameDetailSerializer,
    PlaceNameGeoSerializer,
    PlaceNameCategorySerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from web.permissions import IsAdminOrReadOnly


class PlaceNameCategoryViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = PlaceNameCategorySerializer
    detail_serializer_class = PlaceNameCategorySerializer
    queryset = PlaceNameCategory.objects.all()


class PlaceNameViewSet(BaseModelViewSet):
    serializer_class = PlaceNameSerializer
    detail_serializer_class = PlaceNameDetailSerializer
    queryset = PlaceName.objects.all().order_by("name")

    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['kind']

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

                        #Notifying the creator
                        try:
                            inform_placename_rejected_or_flagged(int(pk), request.data["status_reason"], PlaceName.REJECTED)
                        except Exception as e:
                            pass

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

                    #Notifying Administrators
                    try:
                        inform_placename_to_be_verified(int(pk))
                    except Exception as e:
                        pass

                    #Notifying the creator
                    try:
                        inform_placename_rejected_or_flagged(int(pk), request.data["status_reason"], PlaceName.FLAGGED)
                    except Exception as e:
                        pass

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
        queryset = self.filter_queryset(queryset)

        user_logged_in = False
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                user_logged_in = True
                
        # 1) if NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
        # 2) if USER IS LOGGED IN, shows:
        # 2.1) user's contribution regardless the status
        # 2.2) community_only content from user's communities. Rules:
        # 2.2.1) is NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
        # 2.2.2) is COMMUNITY ONLY
        # 2.3) everything from where user is Administrator (language/community pair)

        if user_logged_in:

            # 2.1) user's contribution regardless the status
            queryset_user = queryset.filter(creator__id = request.user.id)

            # 2.2) community_only content from user's communities
            user_communities = CommunityMember.objects.filter(
                user__id=int(request.user.id)
            ).filter(
                status__exact=CommunityMember.VERIFIED
            ).values('community')

            # 2.2.1) is NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
            # 2.2.2) is COMMUNITY ONLY
            queryset_community = queryset.filter(
                Q(community_only=False, status__exact=PlaceName.VERIFIED)
                | Q(community_only=False, status__exact=PlaceName.UNVERIFIED)
                | Q(community_only=False, status__isnull=True)
                | Q(community_only__isnull=True, status__exact=PlaceName.VERIFIED)
                | Q(community_only__isnull=True, status__exact=PlaceName.UNVERIFIED)
                | Q(community_only__isnull=True, status__isnull=True)
                | Q(community__in=user_communities)
            )

            # 2.3) everything from where user is Administrator (language/community pair)
            admin_languages = Administrator.objects.filter(user__id=int(request.user.id)).values('language')
            admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')

            if admin_languages and admin_communities:
                # Filter PlaceNames by admin's languages 
                queryset_admin = queryset.filter(
                    language__in=admin_languages, community__in=admin_communities
                )
                if queryset_admin:
                    queryset = queryset_user.union(queryset_community).union(queryset_admin)
                else:
                    queryset = queryset_user.union(queryset_community)
            else: #user is not Administrator of anything
                queryset = queryset_user.union(queryset_community)

        else: #no user is logged in
            queryset = queryset.filter(
                Q(status__exact=PlaceName.VERIFIED) 
                | Q(status__exact=PlaceName.UNVERIFIED) 
                | Q(status__isnull=True)
            )

        if "lang" in request.GET:
            queryset = queryset.filter(
                geom__intersects=Language.objects.get(pk=request.GET.get("lang")).geom
            )

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' PlaceNames do not need to the verified
        queryset = self.get_queryset().exclude(status__exact=PlaceName.VERIFIED).exclude(status__exact=PlaceName.REJECTED)

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


class PlaceNameGeoList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(
        name__icontains="FirstVoices", geom__isnull=False
    )
    serializer_class = PlaceNameGeoSerializer

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        queryset = self.get_queryset()
        
        user_logged_in = False
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                user_logged_in = True
                
        # 1) if NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
        # 2) if USER IS LOGGED IN, show:
        # 2.1) user's contribution regardless the status
        # 2.2) community_only content from user's communities. Rules:
        # 2.2.1) is NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
        # 2.2.2) is COMMUNITY ONLY
        # 2.3) everything from where user is Administrator (language/community pair)
        
        if user_logged_in:
            
            # 2.1) user's contribution regardless the status
            queryset_user = queryset.filter(creator__id = request.user.id)

            # 2.2) community_only content from user's communities
            user_communities = CommunityMember.objects.filter(
                user__id=int(request.user.id)
            ).filter(
                status__exact=CommunityMember.VERIFIED
            ).values('community')
            
            # 2.2.1) is NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
            # 2.2.2) is COMMUNITY ONLY
            queryset_community = queryset.filter(
                Q(community_only=False, status__exact=PlaceName.VERIFIED)
                | Q(community_only=False, status__exact=PlaceName.UNVERIFIED)
                | Q(community_only=False, status__isnull=True)
                | Q(community_only__isnull=True, status__exact=PlaceName.VERIFIED)
                | Q(community_only__isnull=True, status__exact=PlaceName.UNVERIFIED)
                | Q(community_only__isnull=True, status__isnull=True)
                | Q(community__in=user_communities)
            )
            
            # 2.3) everything from where user is Administrator (language/community pair)
            admin_languages = Administrator.objects.filter(user__id=int(request.user.id)).values('language')
            admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')
                
            if admin_languages and admin_communities:
                # Filter PlaceNames by admin's languages 
                queryset_admin = queryset.filter(
                    language__in=admin_languages, community__in=admin_communities
                )
                if queryset_admin:
                    queryset = queryset_user.union(queryset_community).union(queryset_admin)
                else:
                    queryset = queryset_user.union(queryset_community)
            else: #user is not Administrator of anything
                queryset = queryset_user.union(queryset_community)

        else: #no user is logged in
            queryset = queryset.filter(
                Q(status__exact=PlaceName.VERIFIED) 
                | Q(status__exact=PlaceName.UNVERIFIED) 
                | Q(status__isnull=True)
            )
            
        if "lang" in request.GET:
            queryset = queryset.filter(
                geom__intersects=Language.objects.get(pk=request.GET.get("lang")).geom
            )
            
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)
