from rest_framework import routers
from django.conf.urls import url

from grants.views.grant import GrantViewSet, GrantCategoryAPIView

router = routers.DefaultRouter()

router.register(r"grants", GrantViewSet)

app_name = "grants"
urlpatterns = [
    url("grants/category/", GrantCategoryAPIView.as_view(), name="grant-category"),
] + router.urls