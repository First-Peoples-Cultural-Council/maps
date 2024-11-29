from django.conf import settings
from django.conf.urls import url
from django.conf.urls.static import static
from django.contrib import admin
from django.contrib.sitemaps.views import sitemap
from django.urls import include, path
from rest_framework import routers, permissions
from rest_framework.authtoken.views import obtain_auth_token
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from web.sitemaps import LanguageSitemap, CommunitySitemap, PlaceNameSitemap
from web.views import PageViewSet


# schema_view = get_swagger_view(title="FPCC API")
schema_view = get_schema_view(
   openapi.Info(title="FPCC API", default_version='v1'),
   public=True,
   permission_classes=(permissions.IsAdminUser,),
)

sitemaps = {
    "language": LanguageSitemap(),
    "community": CommunitySitemap(),
    "placename": PlaceNameSitemap(),
}

router = routers.DefaultRouter()
router.register(r"api/page", PageViewSet, basename="page")


# pylint: disable=pointless-statement,undefined-variable
def crash(request):
    """
    This is meant to invoke a variable that's undefined to check if error handling is working.
    """
    throw


urlpatterns = (
    [
        path("admin/", admin.site.urls, name="admin"),
        path(
            "api/auth/",
            include("rest_framework.urls", namespace="rest_framework"),
            name="auth",
        ),  # for logging in and out as a user.
        url(r"api-token-auth/", obtain_auth_token),  # for token based api usage.
        path("api/", include("language.urls"), name="language"),
        path("api/", include("grants.urls"), name="grants"),
        path("api/", include("users.urls"), name="users"),
        url("docs/crash/$", crash),
        url("docs/$", schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
        path(
            "sitemap.xml",
            sitemap,
            {"sitemaps": sitemaps},
            name="django.contrib.sitemaps.views.sitemap",
        ),
    ]
    + router.urls
    + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
)
