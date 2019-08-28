from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import (
    PlaceNameGeoList,
    LanguageGeoList,
    CommunityGeoList,
    PlaceNamePolyList,
)


from .views import (
    LanguageViewSet,
    CommunityViewSet,
    PlaceNameViewSet,
    MediaViewSet,
    MediaFavouriteViewSet,
    CommunityLanguageStatsViewSet,
)

router = routers.DefaultRouter()
router.register(r"language", LanguageViewSet, basename="language")

router.register(r"community", CommunityViewSet, basename="community")

router.register(r"placename", PlaceNameViewSet, basename="placename")
router.register(r"stats", CommunityLanguageStatsViewSet, basename="placename")
router.register(r"media", MediaViewSet, basename="media")
router.register(r"mediafavourite", MediaFavouriteViewSet, basename="media-favourite")

urlpatterns = [
    url("language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    url("community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    url("placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
    url("placename-poly/$", PlaceNamePolyList.as_view(), name="placename-poly"),
] + router.urls
