from django.db.models import F
from rest_framework import mixins

from grants.models import Grant, GrantCategory
from grants.serializers import (
    GrantSerializer,
    GrantDetailSerializer,
    GrantCategorySerializer,
)
from grants.views.base import BaseGenericViewSet


class GrantViewSet(
    mixins.ListModelMixin, mixins.RetrieveModelMixin, BaseGenericViewSet
):
    queryset = Grant.objects.filter(point__isnull=False, year__isnull=False).order_by(
        "-year", "recipient", "grant"
    )
    serializer_class = GrantSerializer
    detail_serializer_class = GrantDetailSerializer
    lookup_field = "id"

    def list(self, request, *args, **kwargs):
        """
        List all Grants, in a geo format, to be used in the frontend's map.
        """
        return super().list(request)


class GrantCategoryViewSet(mixins.ListModelMixin, BaseGenericViewSet):
    serializer_class = GrantCategorySerializer
    queryset = GrantCategory.objects.all().order_by(
        F(
            "parent__id",
        ).asc(nulls_first=True),
        F(
            "order",
        ).asc(nulls_last=True),
    )

    def list(self, request, *args, **kwargs):
        """
        List all grant categories.
        """
        return super().list(request)
