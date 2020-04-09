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
    Recording,
)

from django.views.decorators.cache import never_cache
from rest_framework import viewsets, generics, mixins, status
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from language.views import BaseModelViewSet

from language.serializers import (
    FavouriteSerializer,
    NotificationSerializer,
    RecordingSerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from web.permissions import IsAdminOrReadOnly


class RecordingViewSet(BaseModelViewSet):
    serializer_class = RecordingSerializer
    queryset = Recording.objects.all()


class NotificationViewSet(BaseModelViewSet):
    serializer_class = NotificationSerializer
    queryset = Notification.objects.all()

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @method_decorator(never_cache)
    def list(self, request):
        queryset = self.get_queryset()
        
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                queryset = queryset.filter(user__id = request.user.id)
                serializer = self.serializer_class(queryset, many=True)
                return Response(serializer.data)        

        return Response({"message": "Only logged in users can view theirs favourites"}, 
                        status=status.HTTP_401_UNAUTHORIZED)


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

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def create(self, request, *args, **kwargs):
        if 'place' in request.data.keys() or 'media' in request.data.keys():

            if 'media' in request.data.keys():
                media_id = int(request.data["media"])

                # Check if the favourite already exists
                if Favourite.favourite_media_already_exists(request.user.id, media_id):
                    return Response({"message": "This media is already a favourite"}, 
                                    status=status.HTTP_409_CONFLICT)
                else:
                    return super(FavouriteViewSet, self).create(request, *args, **kwargs)

            if 'place' in request.data.keys():
                placename_id = int(request.data["place"])

                # Check if the favourite already exists
                if Favourite.favourite_place_already_exists(request.user.id, placename_id):
                    return Response({"message": "This placename is already a favourite"}, 
                                    status=status.HTTP_409_CONFLICT)
                else:
                    return super(FavouriteViewSet, self).create(request, *args, **kwargs)
        else:
            return super(FavouriteViewSet, self).create(request, *args, **kwargs)

    @method_decorator(never_cache)
    def list(self, request):
        queryset = self.get_queryset()
        
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                queryset = queryset.filter(user__id = request.user.id)
                serializer = self.serializer_class(queryset, many=True)
                return Response(serializer.data)
        # Unauthenticated users have zero favourites, instead of returning 401 because it
        # simplifies client implementations.      
        return Response([])
