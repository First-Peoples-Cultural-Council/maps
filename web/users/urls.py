from django.urls import include
from django.conf.urls import url

from rest_framework import routers

from .views import UserViewSet

router = routers.DefaultRouter()
router.register(r"user", UserViewSet, basename='user')

urlpatterns = router.urls

