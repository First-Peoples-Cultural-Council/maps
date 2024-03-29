from django.conf.urls import url
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
router.register(r"stats", CommunityLanguageStatsViewSet, basename="placename")
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
    url("language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    url("community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    url("placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
    url("art-geo/$", ArtGeoList.as_view(), name="art-geo"),
    url("language-search/$", LanguageSearchList.as_view(), name="language-search"),
    url("community-search/$", CommunitySearchList.as_view(), name="community-search"),
    url("placename-search/$", PlaceNameSearchList.as_view(), name="placename-search"),
    url("art-search/$", ArtSearchList.as_view(), name="art-search"),
    url("arts/public-art", PublicArtList.as_view(), name="arts-public-art"),
    url("arts/artist", ArtistList.as_view(), name="arts-artist"),
    url("arts/event", EventList.as_view(), name="arts-event"),
    url("arts/organization", OrganizationList.as_view(), name="arts-organization"),
    url("arts/resource", ResourceList.as_view(), name="arts-resource"),
    url("arts/grant", GrantList.as_view(), name="arts-grant"),
    url("arts/placename", ArtworkPlaceNameList.as_view(), name="artwork-placename"),
    url("arts/artwork", ArtworkList.as_view(), name="arts-artwork")
] + router.urls
