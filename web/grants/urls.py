from rest_framework import routers

from grants.views.grant import GrantViewSet

router = routers.DefaultRouter()

router.register(r"grants", GrantViewSet)

app_name = "grants"
urlpatterns = router.urls