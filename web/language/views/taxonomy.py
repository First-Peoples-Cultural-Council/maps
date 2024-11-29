from django.db.models import F
from django.views.decorators.cache import never_cache
from django.utils.decorators import method_decorator
from rest_framework import mixins
from rest_framework.viewsets import GenericViewSet
from django_filters.rest_framework import DjangoFilterBackend
from django_filters import FilterSet

from language.models import Taxonomy
from language.serializers import TaxonomySerializer
from language.filters import ListFilter


class TaxonomyFilterSet(FilterSet):
    names = ListFilter(field_name="name", lookup_expr="in")

    class Meta:
        model = Taxonomy
        fields = ("names", "parent")


class TaxonomyViewSet(mixins.ListModelMixin, GenericViewSet):
    serializer_class = TaxonomySerializer
    queryset = Taxonomy.objects.all().order_by(
        F(
            "parent__id",
        ).asc(nulls_first=True),
        F(
            "order",
        ).asc(nulls_last=True),
    )

    filter_backends = [DjangoFilterBackend]
    filterset_class = TaxonomyFilterSet

    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        """
        List all Taxonomies to be used in the frontend's filters.
        """
        return super().list(request)
