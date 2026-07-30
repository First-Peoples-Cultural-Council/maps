from django.urls import re_path
from rest_framework import routers

from .views import (
    PlaceNameGeoList,
    ArtGeoList,
    LanguageGeoList,
    CommunityGeoList,
    LanguageSearchList,
    CommunitySearchList,
    PlaceNameSearchList,
    ArtSearchList,
    PublicArtList,
    ArtistList,
    EventList,
    OrganizationList,
    ResourceList,
    GrantList,
    ArtworkList,
    ArtworkPlaceNameList,
    LanguageViewSet,
    CommunityViewSet,
    PlaceNameViewSet,
    ChampionViewSet,
    MediaViewSet,
    FavouriteViewSet,
    NotificationViewSet,
    CommunityLanguageStatsViewSet,
    RecordingViewSet,
    TaxonomyViewSet,
)

router = routers.DefaultRouter()
# Used only for data managmement by admins
router.register(r"stats", CommunityLanguageStatsViewSet, basename="stats")
router.register(r"champion", ChampionViewSet, basename="champion")

# Used for data management and application usage
router.register(r"language", LanguageViewSet, basename="language")
router.register(r"community", CommunityViewSet, basename="community")
router.register(r"placename", PlaceNameViewSet, basename="placename")

# Only application usage
router.register(r"media", MediaViewSet, basename="media")
router.register(r"taxonomy", TaxonomyViewSet, basename="taxonomy")
router.register(r"favourite", FavouriteViewSet, basename="favourite")
router.register(r"notification", NotificationViewSet, basename="notification")
router.register(r"recording", RecordingViewSet, basename="recording")

urlpatterns = [
    re_path(r"language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    re_path(r"community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    re_path(r"placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
    re_path(r"art-geo/$", ArtGeoList.as_view(), name="art-geo"),
    re_path(r"language-search/$", LanguageSearchList.as_view(), name="language-search"),
    re_path(r"community-search/$", CommunitySearchList.as_view(), name="community-search"),
    re_path(r"placename-search/$", PlaceNameSearchList.as_view(), name="placename-search"),
    re_path(r"art-search/$", ArtSearchList.as_view(), name="art-search"),
    re_path(r"arts/public-art", PublicArtList.as_view(), name="arts-public-art"),
    re_path(r"arts/artist", ArtistList.as_view(), name="arts-artist"),
    re_path(r"arts/event", EventList.as_view(), name="arts-event"),
    re_path(r"arts/organization", OrganizationList.as_view(), name="arts-organization"),
    re_path(r"arts/resource", ResourceList.as_view(), name="arts-resource"),
    re_path(r"arts/grant", GrantList.as_view(), name="arts-grant"),
    re_path(r"arts/placename", ArtworkPlaceNameList.as_view(), name="artwork-placename"),
    re_path(r"arts/artwork", ArtworkList.as_view(), name="arts-artwork"),
] + router.urls
