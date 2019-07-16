from django.urls import include, path
from rest_framework import routers
from .views import LanguageViewSet, CommunityViewSet, PlaceNameViewSet, ChampionViewSet, LanguageGeoList

router = routers.DefaultRouter()
router.register(r"language", LanguageViewSet)
router.register(r"community", CommunityViewSet)
router.register(r"placename", PlaceNameViewSet)
router.register(r"champion", ChampionViewSet)

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path("", include(router.urls)),
    path("language-geo/", LanguageGeoList.as_view())
]
