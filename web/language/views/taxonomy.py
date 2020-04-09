from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets, generics, mixins
from django_filters import FilterSet
from rest_framework.viewsets import GenericViewSet

from language.models import Taxonomy
from language.serializers import TaxonomySerializer
from language.filters import StringListFilter


class TaxonomyFilterSet(FilterSet):
    names = StringListFilter(field_name='name', lookup_expr='in')

    class Meta:
        model = Taxonomy
        fields = ('names', 'parent')


class TaxonomyViewSet(mixins.ListModelMixin, GenericViewSet):
    serializer_class = TaxonomySerializer
    queryset = Taxonomy.objects.all()

    filter_backends = [DjangoFilterBackend]
    filterset_class = TaxonomyFilterSet
