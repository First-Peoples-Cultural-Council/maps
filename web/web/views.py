from rest_framework import viewsets

from web.models import Page
from web.serializers import PageSerializer
from web.permissions import IsAdminOrReadOnly


class PageViewSet(viewsets.ModelViewSet):
    """
    Get/Create/Update/Delete a Page object (read only/Django admin access required).
    """

    permission_classes = [IsAdminOrReadOnly]
    queryset = Page.objects.all()
    serializer_class = PageSerializer
