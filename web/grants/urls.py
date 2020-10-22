from rest_framework import routers
from django.conf.urls import url

from grants.views.grant import GrantViewSet, GrantCategoryViewSet

router = routers.DefaultRouter()

router.register(r"grants", GrantViewSet)
router.register(r"grant-categories", GrantCategoryViewSet)

app_name = "grants"
urlpatterns = router.urls
