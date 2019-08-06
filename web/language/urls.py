from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import (
    LanguageList,
    CommunityList,
    PlaceNameGeoList,
    LanguageDetail,
    CommunityDetail,
    LanguageGeoList,
    CommunityGeoList,
)


urlpatterns = [
    url("language-geo/$", LanguageGeoList.as_view(), name="language-geo"),
    url("language/(?P<pk>\d+)/$", LanguageDetail.as_view(), name="language-detail"),
    url("language/$", LanguageList.as_view(), name="language-list"),
    url("community-geo/$", CommunityGeoList.as_view(), name="community-geo"),
    url("community/(?P<pk>\d+)/$", CommunityDetail.as_view(), name="community-detail"),
    url("community/$", CommunityList.as_view(), name="community-list"),
    url("placename-geo/$", PlaceNameGeoList.as_view(), name="placename-geo"),
]
