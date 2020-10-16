from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from rest_framework import mixins, views
from rest_framework.response import Response

from grants.models import Grant
from grants.serializers import GrantSerializer, GrantDetailSerializer
from .base import BaseGenericViewSet

CATEGORIES = {
    'A': ['ARTS', 'AIND', 'ASHR', 'AORG', 'AADM', 'AMIC', 'ALND', 'AEMIP', 'AECMR', 'ATPMP'],
    'H': ['HMIC', 'HSOP'], 
    'L': ['LALI', 'LBCLI', 'LDIGI', 'LFV', 'LILG', 'LANG', 'LLN', 'LLRPP', 'LMAP', 'LPATH', 'LRML', 'LTECH', 'LYES']
}


class GrantViewSet(mixins.ListModelMixin,
                    mixins.RetrieveModelMixin,
                    BaseGenericViewSet):
    queryset = Grant.objects.filter(point__isnull=False)
    serializer_class = GrantSerializer
    detail_serializer_class = GrantDetailSerializer
    lookup_field = 'id'

    @method_decorator(never_cache)
    def list(self, request):
        return super().list(request)


class GrantCategoryAPIView(views.APIView):
    def get(self, request):
        def get_parent_category(category):
            parent_category = None
            for k, v in CATEGORIES.items():
                if category in v:
                    parent_category = k
                    break
            return parent_category

        parent_categories = list(CATEGORIES.keys())
        categories_data = []
        categories = Grant.objects.order_by('category').values_list('category', flat=True).distinct()

        # start pk for subcategories after parent categories
        pk = len(parent_categories) + 1
        for category in categories:
            parent_category = get_parent_category(category)
            data = {
                'id': pk,
                'name': category,
                'order': CATEGORIES[parent_category].index(category) + 1 if parent_category else None,
                'parent': parent_categories.index(parent_category) + 1 if parent_category else None
            }
            pk += 1
            categories_data.append(data)

        return Response(categories_data)
