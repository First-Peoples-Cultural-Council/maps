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
    inform_media_rejected_or_flagged,
    inform_media_to_be_verified,
)

from django.views.decorators.cache import never_cache
from rest_framework import viewsets, generics, mixins, status
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from language.views import BaseModelViewSet

from language.serializers import (
    MediaSerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from web.permissions import IsAdminOrReadOnly


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

    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['placename']

    def perform_create(self, serializer):
        serializer.save(creator=self.request.user)

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' Media do not need to the verified
        queryset = self.get_queryset().exclude(status__exact=Media.VERIFIED).exclude(status__exact=Media.REJECTED)

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

                        #Notifying the creator
                        try:
                            inform_media_rejected_or_flagged(int(pk), request.data["status_reason"], Media.REJECTED)
                        except Exception as e:
                            pass

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

                    #Notifying Administrators
                    try:
                        inform_media_to_be_verified(int(pk))
                    except Exception as e:
                        pass

                    #Notifying the creator
                    try:
                        inform_media_rejected_or_flagged(int(pk), request.data["status_reason"], Media.FLAGGED)
                    except Exception as e:
                        pass
                    
                    return Response({"message": "Flagged!"})
                else:
                    return Response({"message": "Reason must be provided"})
        except Media.DoesNotExist:
            return Response({"message": "No Media with the given id was found"})

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        queryset = self.get_queryset()
        queryset = self.filter_queryset(queryset)

        user_logged_in = False
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                user_logged_in = True

        # 1) if NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
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

            # 2.2.1) is NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
            # 2.2.2) is COMMUNITY ONLY
            queryset_community = queryset.filter(
                Q(community_only=False, status__exact=Media.VERIFIED)
                | Q(community_only=False, status__exact=Media.UNVERIFIED)
                | Q(community_only=False, status__isnull=True)
                | Q(community_only__isnull=True, status__exact=Media.VERIFIED)
                | Q(community_only__isnull=True, status__exact=Media.UNVERIFIED)
                | Q(community_only__isnull=True, status__isnull=True)
                | Q(community__in=user_communities)
                | Q(placename__community__in=user_communities)
            )

            # 2.3) everything from where user is Administrator (language/community pair)
            admin_languages = Administrator.objects.filter(user__id=int(request.user.id)).values('language')
            admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')

            if admin_languages and admin_communities:
                # Filter Medias by admin's languages 
                qry_adm_community = queryset.filter(
                    community__languages__in=admin_languages, community__in=admin_communities
                )
                qry_adm_places = queryset.filter(
                    placename__language__in=admin_languages, placename__community__in=admin_communities
                )
                if qry_adm_community and qry_adm_places:
                    queryset = queryset_user.union(queryset_community).union(qry_adm_community).union(qry_adm_places)
                elif qry_adm_community:
                    queryset = queryset_user.union(queryset_community).union(qry_adm_community)
                elif qry_adm_places:
                    queryset = queryset_user.union(qry_adm_community).union(qry_adm_places)
                else:
                    queryset = queryset_user.union(qry_adm_community)
            else: #user is not Administrator of anything
                queryset = queryset_user.union(queryset_community)

        else: #no user is logged in
            queryset = queryset.filter(
                Q(status__exact=Media.VERIFIED) 
                | Q(status__exact=Media.UNVERIFIED) 
                | Q(status__isnull=True)
            )

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)
