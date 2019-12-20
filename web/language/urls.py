from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import PlaceNameGeoList, LanguageGeoList, CommunityGeoList

from .views import (
    LanguageViewSet,
    CommunityViewSet,
    PlaceNameViewSet,
    PlaceNameCategoryViewSet,
    ChampionViewSet,
    MediaViewSet,
    FavouriteViewSet,
    NotificationViewSet,
    CommunityLanguageStatsViewSet,
    RecordingViewSet,
)

router = routers.DefaultRouter()
# Used only for data managmement by admins
router.register(r"stats", CommunityLanguageStatsViewSet, basename="placename")
router.register(r"champion", ChampionViewSet, basename="champion")
router.register(r"placenamecategory", PlaceNameCategoryViewSet, basename="placename")

# Used for data management and application usage
router.register(r"language", LanguageViewSet, basename="language")
router.register(r"community", CommunityViewSet, basename="community")
router.register(r"placename", PlaceNameViewSet, basename="placename")

# Only application usage
router.register(r"media", MediaViewSet, basename="media")
router.register(r"favourite", FavouriteViewSet, basename="favourite")
router.register(r"notification", NotificationViewSet, basename="notification")
router.register(r"recording", RecordingViewSet, basename="recording")

urlpatterns = [
    url("language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    url("community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    url("placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
] + router.urls
