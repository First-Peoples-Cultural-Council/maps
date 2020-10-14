from rest_framework import mixins

from grants.models import Grant
from grants.serializers import GrantSerializer, GrantDetailSerializer
from .base import BaseGenericViewSet


class GrantViewSet(mixins.ListModelMixin,
                    mixins.RetrieveModelMixin,
                    BaseGenericViewSet):
    queryset = Grant.objects.all()
    serializer_class = GrantSerializer
    detail_serializer_class = GrantDetailSerializer
    lookup_field = 'id'