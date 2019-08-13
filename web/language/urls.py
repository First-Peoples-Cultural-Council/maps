from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import PlaceNameGeoList, LanguageGeoList, CommunityGeoList


from .views import LanguageViewSet, CommunityViewSet

router = routers.DefaultRouter()
router.register(r"language", LanguageViewSet, basename="language")
router.register(r"community", CommunityViewSet, basename="community")

urlpatterns = [
    url("language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    url("community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    url("placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
] + router.urls
