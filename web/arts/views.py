import os
import json

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page

from rest_framework import viewsets, generics, mixins, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import generics
from .models import (
    Art,
    Association,
    ArtCategory,
    Artist,
    ArtistAward,
    ArtistLink,
    ArtistMedia,
)
from users.models import User
from language.models import Language
from .serializers import (
    ArtSerializer, 
    ArtDetailSerializer,
    AssociationSerializer,
    ArtCategorySerializer,
    ArtistSerializer,
    ArtistAwardSerializer,
    ArtistLinkSerializer,
    ArtistMediaSerializer,
)


class ArtList(generics.ListAPIView):

    queryset = Art.objects.all()
    serializer_class = ArtSerializer

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            lang = Language.objects.get(pk=int(request.GET["lang"]))
            queryset = queryset.filter(point__intersects=lang.geom)
        serializer = ArtSerializer(queryset, many=True)
        return Response(serializer.data)


class ArtDetail(generics.RetrieveAPIView):    
    serializer_class = ArtDetailSerializer
    queryset = Art.objects.all()


class AssociationViewSet(generics.ListAPIView):
    serializer_class = AssociationSerializer
    queryset = Association.objects.all()

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        objects = []

        object01 = Association()
        object01.id = 1
        object01.name = "Coast Salish"
        objects.append(object01)
        
        object02 = Association()
        object02.id = 2
        object02.name = "Tahltan Nation"
        objects.append(object02)

        serializer = self.serializer_class(objects, many=True)
        return Response(serializer.data)


class ArtCategoryViewSet(generics.ListAPIView):
    serializer_class = ArtCategorySerializer
    queryset = ArtCategory.objects.all()

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        objects = []

        object01 = ArtCategory()
        object01.id = 1
        object01.name = "Artist"
        object01.category_type = "ART"
        objects.append(object01)
        
        object02 = ArtCategory()
        object02.id = 2
        object02.name = "Visual"
        object02.category_type = "VIS"
        objects.append(object02)
        
        object03 = ArtCategory()
        object03.id = 3
        object03.name = "Painter"
        object03.category_type = "PAI"
        objects.append(object03)
        
        object04 = ArtCategory()
        object04.id = 4
        object04.name = "Carver"
        object04.category_type = "CAR"
        objects.append(object04)

        serializer = self.serializer_class(objects, many=True)
        return Response(serializer.data)

    # class Meta:
    #     model = ArtCategory
    #     fields = ("id", "name", "category_type")


class ArtistViewSet(generics.ListAPIView):
    serializer_class = ArtistSerializer
    queryset = Artist.objects.all()

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        objects = []

        object01 = Artist()
        object01.id = 1
        object01.subtitle = "Hope (Status Krew)"
        object01.statement = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        object01.user = User()
        object01.user.id = 1
        object01.user.first_name = "Patrick"
        object01.user.last_name = "Kelly"
        object01.user.bio = "Born in Vancouver, BC, Canada, Hope is an underground rapper"
        object01.phone = "(668) 786 6583"
        object01.address = "Bella Coola, British Columbia, Canada"
        objects.append(object01)

        object02 = Artist()
        object02.id = 2
        object02.subtitle = "Danika Nolle"
        object02.statement = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        object02.user = User()
        object02.user.id = 2
        object02.user.first_name = "Danica"
        object02.user.last_name = "Naccarella"
        object02.user.bio = "Born in Vancouver, BC, Canada, Hope is an underground rapper"
        object02.phone = "(668) 786 6583"
        object02.address = "Bella Coola, British Columbia, Canada"
        objects.append(object01)

        serializer = self.serializer_class(objects, many=True)
        return Response(serializer.data)


class ArtistAwardViewSet(generics.ListAPIView):
    serializer_class = ArtistAwardSerializer
    queryset = ArtistAward.objects.all()

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        objects = []
       
        user = User()
        user.id = 1
        user.first_name = "Patrick"
        user.last_name = "Kelly"

        object01 = ArtistAward()
        object01.id = 1
        object01.name = "YVR Art Foundation Youth 2015"
        object01.artist = Artist()
        object01.artist.id = 1
        object01.artist.user = user
        objects.append(object01)

        object02 = ArtistAward()
        object02.id = 2
        object02.name = "BC Arts Council 2015"
        object02.artist = Artist()
        object02.artist.id = 1
        object02.artist.user = user
        objects.append(object02)

        serializer = self.serializer_class(objects, many=True)
        return Response(serializer.data)


class ArtistLinkViewSet(generics.ListAPIView):
    serializer_class = ArtistLinkSerializer
    queryset = ArtistLink.objects.all()

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        objects = []
       
        user = User()
        user.id = 1
        user.first_name = "Patrick"
        user.last_name = "Kelly"

        object01 = ArtistLink()
        object01.id = 1
        object01.url = "https://facebook.com/designs-by-danica-784678436/"
        object01.artist = Artist()
        object01.artist.id = 1
        object01.artist.user = user
        objects.append(object01)

        object02 = ArtistLink()
        object02.id = 2
        object02.url = "http://hyperurl.com/lq6w7890u"
        object02.artist = Artist()
        object02.artist.id = 1
        object02.artist.user = user
        objects.append(object02)

        serializer = self.serializer_class(objects, many=True)
        return Response(serializer.data)


class ArtistMediaViewSet(generics.ListAPIView):
    serializer_class = ArtistMediaSerializer
    queryset = ArtistMedia.objects.all()

    @method_decorator(cache_page(60 * 60 * 2))
    def list(self, request):
        objects = []
       
        user = User()
        user.id = 1
        user.first_name = "Patrick"
        user.last_name = "Kelly"

        object01 = ArtistMedia()
        object01.id = 1
        object01.name = "Lorem ipsum dolor sit amet"
        object01.artist = Artist()
        object01.artist.id = 1
        object01.artist.user = user
        object01.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        object01.media_url = ""
        object01.media_type = "AUD"
        objects.append(object01)

        object02 = ArtistMedia()
        object02.id = 2
        object02.name = "Consectetur adipiscing elit"
        object02.artist = Artist()
        object02.artist.id = 1
        object02.artist.user = user
        object02.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        object02.media_url = ""
        object02.media_type = "PHO"
        objects.append(object02)

        object03 = ArtistMedia()
        object03.id = 3
        object03.name = "Hope - Status Krew"
        object03.artist = Artist()
        object03.artist.id = 1
        object03.artist.user = user
        object03.media_url = "https://www.youtube.com/watch?v=sWnmd7h8ebo"
        object03.media_type = "VID"
        objects.append(object03)

        serializer = self.serializer_class(objects, many=True)
        return Response(serializer.data)
        