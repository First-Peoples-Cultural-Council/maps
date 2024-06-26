from rest_framework import viewsets

from web.models import Page
from web.serializers import PageSerializer


class PageViewSet(viewsets.ModelViewSet):
    """
    A simple ViewSet for viewing and editing accounts.
    """

    queryset = Page.objects.all()
    serializer_class = PageSerializer
