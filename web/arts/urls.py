from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import (
    ArtList, 
    ArtDetail,
    AssociationViewSet,
    ArtCategoryViewSet,
    ArtistViewSet,
    ArtistAwardViewSet,
    ArtistLinkViewSet,
    ArtistMediaViewSet,
)

urlpatterns = [
    # url("art/$", ArtList.as_view(), name="art-list"),
    url(
        "arts/$", ArtList.as_view(), name="arts-list"
    ),  # TODO: this is oddly cached and broken on the FE. it's not referenced but is called anyway.
    url("art/(?P<pk>\d+)/$", ArtDetail.as_view(), name="art-detail"),
    url("arts/associations/$", AssociationViewSet.as_view(), name="associations"),
    url("arts/categories/$", ArtCategoryViewSet.as_view(), name="categories"),
    url("arts/artist/$", ArtistViewSet.as_view(), name="artists"),
    url("arts/artist/awards/$", ArtistAwardViewSet.as_view(), name="artist-awards"),
    url("arts/artist/links/$", ArtistLinkViewSet.as_view(), name="artist-links"),
    url("arts/artist/medias/$", ArtistMediaViewSet.as_view(), name="artist-media"),
]
