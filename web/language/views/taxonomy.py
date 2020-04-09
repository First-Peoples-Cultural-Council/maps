from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets, generics, mixins, status
from rest_framework.viewsets import GenericViewSet

from language.models import Taxonomy
from language.serializers import TaxonomySerializer


class TaxonomyViewSet(mixins.ListModelMixin, GenericViewSet):
    serializer_class = TaxonomySerializer
    queryset = Taxonomy.objects.all()

    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['name', 'parent']