from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from rest_framework import mixins, views
from rest_framework.response import Response

from grants.models import Grant
from grants.serializers import GrantSerializer, GrantDetailSerializer
from .base import BaseGenericViewSet

CATEGORIES = {
    'A': [
        'Arts One Time Grant',
        'Individual Artists Grant',
        'Sharing Traditional Arts Grant',
        'Organizations and Collectives Grant',
        'Arts Administration Internships Grant',
        'Aboriginal Youth Engaged in the Arts Grant',
        'Arts Micro Grants',
        'Community Land Based Arts Grant',
        'Emerging Music Industry Professionals Grant',
        'Expanding Capacity in the Indigenous Music Recording Industry Grant',
        'Touring, Promotion/Marketing and Performance Grant'
    ],
    'H': [
        'Indigenous Heritage Micro Grant',
        'Sense of Place Grant'
    ], 
    'L': [
        'Aboriginal Languages Initiative',
        'BC Language Initiative',
        'Digitization Program',
        'FirstVoices Program',
        'Indigenous Languages Grant',
        'Language One Time Grant',
        'Language Nest Program',
        'Language Revitalization Planning Program',
        'Mentor-Apprentice Program',
        'Pathways to Language Vitality Program',
        'Reclaiming My Language Program',
        'Language Technology Program',
        'Youth Empowered Speakers Program'
    ]
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
                # remove trailing whitespaces
                if category.strip() in v:
                    parent_category = k
                    break
            return parent_category

        parent_categories = list(CATEGORIES.keys())
        categories = Grant.objects.exclude(category__exact=''
            ).exclude(category__isnull=True
            ).order_by('category'
            ).values_list('category', flat=True
            ).distinct()

        categories_data = [
            {
                'id': 1,
                'name': 'Arts',
                'order': None,
                'parent': None
            },
            {
                'id': 2,
                'name': 'Heritage',
                'order': None,
                'parent': None
            },
            {
                'id': 3,
                'name': 'Language',
                'order': None,
                'parent': None
            }
        ]

        # start pk for subcategories after parent categories in categories_data
        pk = len(categories_data) + 1
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
