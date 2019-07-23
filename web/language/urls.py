from django.urls import include
from django.conf.urls import url

from rest_framework import routers
from .views import (
    LanguageList,
    CommunityList,
    PlaceNameGeoList,
    LanguageDetail,
    CommunityDetail,
    PlaceNameDetail,
    LanguageGeoList,
)


urlpatterns = [
    url("language-geo/$", LanguageGeoList.as_view()),
    url("language/(?P<pk>\d+)/$", LanguageDetail.as_view()),
    url("language/$", LanguageList.as_view()),
    url("community/(?P<pk>\d+)/$", CommunityDetail.as_view()),
    url("community/$", CommunityList.as_view()),
    url("placename-geo/$", PlaceNameGeoList.as_view()),
    url("placename/(?P<pk>\d+)/$", PlaceNameDetail.as_view()),
]
