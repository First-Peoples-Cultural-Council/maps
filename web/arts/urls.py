from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import ArtList, ArtDetail


urlpatterns = [
    url("art/$", ArtList.as_view()),
    url(
        "arts/$", ArtList.as_view()
    ),  # TODO: this is oddly cached and broken on the FE. it's not referenced but is called anyway.
    url("art/(?P<pk>\d+)/$", ArtDetail.as_view()),
]
