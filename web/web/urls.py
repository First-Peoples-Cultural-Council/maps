from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls import url
from django.conf.urls.static import static
from rest_framework import routers
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework_swagger.views import get_swagger_view
from web.sitemaps import *
from .views import PageViewSet

from django.contrib.sitemaps.views import sitemap

schema_view = get_swagger_view(title="FPCC API")

sitemaps = {
    'language': LanguageSitemap(),
    'community': CommunitySitemap(),
    'placename': PlaceNameSitemap(),
}

router = routers.DefaultRouter()
router.register(r"api/page", PageViewSet, basename="page")


def crash(request):
    """
    This is for checking error handling is working.
    """
    throw


urlpatterns = [
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
    url("docs/$", schema_view),
    path('sitemap.xml', sitemap, {'sitemaps': sitemaps},
         name='django.contrib.sitemaps.views.sitemap'),
] + router.urls + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
