import sys

from django.shortcuts import render
from django.db.models import Q

from users.models import User, Administrator
from language.models import (
    Language,
    Community,
    Recording,
)

from django.views.decorators.cache import never_cache
from rest_framework import viewsets, generics, mixins, status
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from language.views import BaseModelViewSet

from language.serializers import (
    LanguageGeoSerializer,
    LanguageSerializer,
    LanguageDetailSerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
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

    @action(detail=True, methods=["patch"])
    def add_language_audio(self, request, pk):
        if 'recording_id' not in request.data.keys():
            return Response({"message": "No Recording was sent in the request"})
        if not pk:
            return Response({"message": "No Language was sent in the request"})
        recording_id = int(request.data["recording_id"])
        language_id = int(pk)
        language = Language.objects.get(pk=language_id)
        recording = Recording.objects.get(pk=recording_id)
        language.language_audio = recording
        language.save()
        return Response({"message": "Language audio associated"}, 
                        status=status.HTTP_200_OK)

    @action(detail=True, methods=["patch"])
    def add_greeting_audio(self, request, pk):
        if 'recording_id' not in request.data.keys():
            return Response({"message": "No Recording was sent in the request"})
        if not pk:
            return Response({"message": "No Language was sent in the request"})
        recording_id = int(request.data["recording_id"])
        language_id = int(pk)
        language = Language.objects.get(pk=language_id)
        recording = Recording.objects.get(pk=recording_id)
        language.greeting_audio = recording
        language.save()
        return Response({"message": "Greeting audio associated"}, 
                        status=status.HTTP_200_OK)

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


class LanguageGeoList(generics.ListAPIView):
    queryset = Language.objects.filter(geom__isnull=False)
    serializer_class = LanguageGeoSerializer
