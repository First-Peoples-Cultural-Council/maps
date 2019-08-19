from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import PlaceNameGeoList, LanguageGeoList, CommunityGeoList


from .views import (
    LanguageViewSet, 
    LanguageMemberViewSet, 
    CommunityViewSet, 
    CommunityMemberViewSet, 
    PlaceNameViewSet, 
    MediaViewSet
)

router = routers.DefaultRouter()
router.register(r"language", LanguageViewSet, basename="language")
router.register(r"languagemember", LanguageMemberViewSet, basename='language-member')

router.register(r"community", CommunityViewSet, basename="community")
router.register(r"communitymember", CommunityMemberViewSet, basename='community-member')

router.register(r"placename", PlaceNameViewSet, basename="placename")
router.register(r"placename/<int:pk>/verify/", PlaceNameViewSet, basename='placename-verify')
router.register(r"placename/<int:pk>/flag/", PlaceNameViewSet, basename='placename-flag')

router.register(r"media", MediaViewSet, basename="media")

urlpatterns = [
    url("language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    url("community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    url("placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
] + router.urls
