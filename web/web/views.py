from .models import Page
from .serializers import PageSerializer
from rest_framework import viewsets


class PageViewSet(viewsets.ModelViewSet):
    """
    A simple ViewSet for viewing and editing accounts.
    """

    queryset = Page.objects.all()
    serializer_class = PageSerializer
