from django.shortcuts import render
from django.contrib.auth.models import User

from rest_framework import viewsets, generics, mixins
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from .serializers import (
    UserSerializer,
)

from django.utils.decorators import method_decorator

from django.db.models import Q


# To enable only UPDATE and RETRIEVE, we create a custom ViewSet class...
class UserCustomViewSet(
    mixins.UpdateModelMixin, 
    mixins.ListModelMixin, 
    mixins.RetrieveModelMixin, 
    GenericViewSet
):
    pass


class UserViewSet(UserCustomViewSet, GenericViewSet):
    serializer_class = UserSerializer
    queryset = User.objects.all().order_by("first_name")

    @action(detail=False)
    def search(self, request):
        users_results = []
        params = request.GET.get("search_params")

        if params:
            qs = User.objects.filter(
                Q(first_name__icontains=params)
                | Q(last_name__icontains=params)
                | Q(email__icontains=params)
            )

            users_results = [{
                "id": user.id, 
                "first_name": user.first_name, 
                "last_name": user.last_name, 
                "email": user.email} for user in qs]

        return Response(users_results)
