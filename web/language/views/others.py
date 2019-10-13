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


    # def create(self, request, *args, **kwargs):
    #     print("User " + str(request.user.id))
    #     if 'media' in request.data.keys():
    #         media_id = int(request.data["media"])

    #         # Check if the favourite already exists
    #         if Favourite.favourite_media_already_exists(request.user.id, media_id):
    #             print('Conflict media ' + str(media_id))
    #             return Response({"message": "This media is already a favourite"}, 
    #                             status=status.HTTP_409_CONFLICT)
    #         else:
    #             print('Saving media ' + str(media_id))
    #             return super(FavouriteViewSet, self).create(request, *args, **kwargs)
    #     elif 'place' in request.data.keys():
    #         placename_id = int(request.data["place"])

    #         # Check if the favourite already exists
    #         if Favourite.favourite_place_already_exists(request.user.id, placename_id):
    #             print('Conflict place ' + str(placename_id))
    #             return Response({"message": "This placename is already a favourite"}, 
    #                             status=status.HTTP_409_CONFLICT)
    #         else:
    #             print('Saving place ' + str(placename_id))
    #             return super(FavouriteViewSet, self).create(request, *args, **kwargs)
    #     else:
    #         print('Saving')
    #         return super(FavouriteViewSet, self).create(request, *args, **kwargs)

    # def perform_create(self, serializer):
    #     if self.request and hasattr(self.request, "user"):
    #         if self.request.user.is_authenticated:
    #             user_id = self.request.user.id
    #             print("User id: " + str(user_id))
    #             if 'media' in self.request.data.keys():
    #                 media_id = int(self.request.data["media"])
    #                 print("Media id: " + str(media_id))

    #                 # Check if the favourite already exists
    #                 if Favourite.favourite_media_already_exists(user_id, media_id):
    #                     return Response({"message": "This media is already a favourite"}, 
    #                                     status=status.HTTP_409_CONFLICT)                                        
    #                 else:
    #                     print('Saving')
    #                     serializer.save(user=self.request.user)
    #             elif 'place' in self.request.data.keys():
    #                 placename_id = int(self.request.data["place"])
    #                 print("Place id: " + str(placename_id))
                    
    #                 # Check if the favourite already exists
    #                 if Favourite.favourite_place_already_exists(user_id, placename_id):
    #                     return Response({"message": "This placename is already a favourite"}, 
    #                                     status=status.HTTP_409_CONFLICT)
    #                 else:
    #                     print('Saving')
    #                     serializer.save(user=self.request.user)
    #             else:
    #                 print('Saving')
    #                 serializer.save(user=self.request.user)
    #         else:
    #             return Response({"message", "User must be logged in"}, 
    #                             status=status.HTTP_403_FORBIDDEN)
    #     else:
    #         return Response({"message", "User must be logged in"}, 
    #                         status=status.HTTP_403_FORBIDDEN)
