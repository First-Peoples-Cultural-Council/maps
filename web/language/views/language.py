from django.views.decorators.cache import never_cache
from django.utils.decorators import method_decorator
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import action
from django_filters.rest_framework import DjangoFilterBackend

from users.models import User
from language.models import Language, Recording
from language.views import BaseModelViewSet
from language.serializers import (
    LanguageGeoSerializer,
    LanguageSerializer,
    LanguageDetailSerializer,
    LanguageSearchSerializer,
)
from web.permissions import IsAdminOrReadOnly


class LanguageViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = LanguageSerializer
    detail_serializer_class = LanguageDetailSerializer
    queryset = (
        Language.objects.filter(geom__isnull=False)
        .select_related("family")
        .order_by("family", "name")
    )

    @method_decorator(never_cache)
    def detail(self, request):
        return super().detail(request)

    @action(detail=True, methods=["patch"])
    def add_language_audio(self, request, pk):
        # TODO - Instead of refetching language using PK, use self.get_object()
        if "recording_id" not in request.data.keys():
            return Response({"message": "No Recording was sent in the request"})
        if not pk:
            return Response({"message": "No Language was sent in the request"})

        language_id = int(pk)
        language = Language.objects.get(pk=language_id)

        recording_id = int(request.data["recording_id"])
        recording = Recording.objects.get(pk=recording_id)

        language.language_audio = recording
        language.save()

        return Response(
            {"message": "Language audio associated"}, status=status.HTTP_200_OK
        )

    @action(detail=True, methods=["patch"])
    def add_greeting_audio(self, request, pk):
        # TODO - Instead of refetching language using PK, use self.get_object()
        if "recording_id" not in request.data.keys():
            return Response({"message": "No Recording was sent in the request"})
        if not pk:
            return Response({"message": "No Language was sent in the request"})

        language_id = int(pk)
        language = Language.objects.get(pk=language_id)

        recording_id = int(request.data["recording_id"])
        recording = Recording.objects.get(pk=recording_id)

        language.greeting_audio = recording
        language.save()

        return Response(
            {"message": "Greeting audio associated"}, status=status.HTTP_200_OK
        )

    def create_membership(self, request):
        # TODO - Instead of refetching language using PK, use self.get_object()
        language_id = int(request.data["language"]["id"])
        language = Language.objects.get(pk=language_id)

        user_id = int(request.data["user"]["id"])
        user = User.objects.get(pk=user_id)
        user.languages.add(language)
        user.save_m2m()


# Geo List APIViews
class LanguageGeoList(generics.ListAPIView):
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["name"]

    queryset = Language.objects.filter(geom__isnull=False).only(
        "name", "color", "sleeping", "geom"
    )
    serializer_class = LanguageGeoSerializer


# Search List APIViews
class LanguageSearchList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False).only(
        "name", "other_names", "family"
    )
    serializer_class = LanguageSearchSerializer
