from django.urls import include, path
from django.conf.urls import url

from rest_framework import routers

from .views import UserViewSet, ClaimArtistProfileView

router = routers.DefaultRouter()
router.register(r"user", UserViewSet, basename='user')

urlpatterns = router.urls

urlpatterns = [
    path("invite/confirm/<str:email>/<str:key>", ClaimArtistProfileView.as_view(), name="claim-artist-profile"),
] + router.urls