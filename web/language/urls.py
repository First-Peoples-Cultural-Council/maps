from django.urls import include, path
from rest_framework import routers
from .views import LanguageList, CommunityList, PlaceNameList, ChampionList, LanguageGeoList

urlpatterns = [
    path("language-geo/", LanguageGeoList.as_view()),
    path("language/", LanguageList.as_view()),
    path("community/", CommunityList.as_view()),
    path("placename/", PlaceNameList.as_view()),
    path("champion/", ChampionList.as_view()),
]
