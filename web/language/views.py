from django.shortcuts import render

from .models import Language
from rest_framework import viewsets
from .serializers import LanguageSerializer


class LanguageViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows languages to be viewed or edited.
    """

    queryset = Language.objects.all()
    serializer_class = LanguageSerializer
