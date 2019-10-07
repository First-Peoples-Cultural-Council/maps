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
    FavouriteSerializer,
    NotificationSerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from web.permissions import IsAdminOrReadOnly


class NotificationViewSet(BaseModelViewSet):
    serializer_class = NotificationSerializer
    queryset = Notification.objects.all()

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


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


class FavouriteViewSet(FavouriteCustomViewSet, GenericViewSet):
    serializer_class = FavouriteSerializer
    queryset = Favourite.objects.all()

    def create(self, request):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:

                if 'place' in request.data.keys() or 'media' in request.data.keys():

                    if 'media' in request.data.keys():
                        media_id = int(request.data["media"])

                        # Check if the favourite already exists
                        if Favourite.favourite_media_already_exists(request.user.id, media_id):
                            return Response({"message": "This media is already a favourite"}, 
                                            status=status.HTTP_409_CONFLICT)
                        else:
                            media = Media.objects.get(pk=media_id)
                            user = User.objects.get(pk=request.user.id)
                            favourite = Favourite()
                            favourite.user = user
                            favourite.media = media
                            favourite.save()
                            content = {"id": favourite.id, "message": "Favourite saved!"}
                            return Response(content, status=status.HTTP_201_CREATED)

                    if 'place' in request.data.keys():
                        placename_id = int(request.data["place"])

                        # Check if the favourite already exists
                        if Favourite.favourite_place_already_exists(request.user.id, placename_id):
                            return Response({"message": "This placename is already a favourite"}, 
                                            status=status.HTTP_409_CONFLICT)
                        else:
                            placename = PlaceName.objects.get(pk=placename_id)
                            user = User.objects.get(pk=request.user.id)
                            favourite = Favourite()
                            favourite.user = user
                            favourite.place = placename
                            favourite.save()
                            content = {"id": favourite.id, "message": "Favourite saved!"}
                            return Response(content, status=status.HTTP_201_CREATED)
                else:
                    return Response({"message": "A placename or a media must be provided"}, 
                                    status=status.HTTP_404_NOT_FOUND)
            else:
                return Response({"message", "User must be logged in"}, 
                                status=status.HTTP_403_FORBIDDEN)
        else:
            return Response({"message", "User must be logged in"}, 
                            status=status.HTTP_403_FORBIDDEN)
