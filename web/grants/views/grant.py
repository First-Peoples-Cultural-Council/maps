from django.db.models import F
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from rest_framework import mixins, views
from rest_framework.response import Response

from grants.models import Grant, GrantCategory
from grants.serializers import GrantSerializer, GrantDetailSerializer, GrantCategorySerializer
from .base import BaseGenericViewSet


class GrantViewSet(mixins.ListModelMixin,
                    mixins.RetrieveModelMixin,
                    BaseGenericViewSet):
    queryset = Grant.objects.filter(point__isnull=False, year__isnull=False).order_by('-year')
    serializer_class = GrantSerializer
    detail_serializer_class = GrantDetailSerializer
    lookup_field = 'id'

    def list(self, request):
        return super().list(request)


class GrantCategoryViewSet(mixins.ListModelMixin, BaseGenericViewSet):
    serializer_class = GrantCategorySerializer
    queryset = GrantCategory.objects.all().order_by(
        F('parent__id',).asc(nulls_first=True),
        F('order',).asc(nulls_last=True))

    def list(self, request):
        return super().list(request)
