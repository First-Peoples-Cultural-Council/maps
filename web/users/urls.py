from django.urls import path

from rest_framework import routers

from .views import UserViewSet, ConfirmClaimView, ValidateInviteView

router = routers.DefaultRouter()
router.register(r"user", UserViewSet, basename='user')

urlpatterns = router.urls

urlpatterns = [
    path("profile/claim/confirm/", ConfirmClaimView.as_view(),
         name="confirm-profile-claim"),
    # path("profile/claim/", ClaimProfileView.as_view(), name="claim-artist-profile"),
    path("key/validate/", ValidateInviteView.as_view(), name="validate-key"),
] + router.urls
