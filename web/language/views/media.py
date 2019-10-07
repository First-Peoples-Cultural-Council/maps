import sys

from django.shortcuts import render
from django.db.models import Q

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
