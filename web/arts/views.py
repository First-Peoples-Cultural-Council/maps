import os
import json

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import generics

from .management.commands.cache_arts import Client
from .models import Art
from language.models import Language
from .serializers import ArtSerializer, ArtDetailSerializer


@api_view()
def all(request):
    if not os.path.exists("web/static/web/arts1.json"):
        open("web/static/web/arts1.json", "w").write(json.dumps(Client().update()))
    arts = json.loads(open("web/static/web/arts1.json", "r").read())

    # if "lang" in request.GET:
    #     languages=Language.objects.get(pk=request.GET.get("lang"))
    #     language.geom.contains()
    return Response(arts)


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
