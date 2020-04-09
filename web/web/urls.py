"""web URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls import url
from django.conf.urls.static import static
from rest_framework import routers
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework_swagger.views import get_swagger_view
from web import jobs
from web.sitemaps import *
from .views import PageViewSet

from django.contrib.sitemaps.views import sitemap
from django.contrib.sitemaps import GenericSitemap

schema_view = get_swagger_view(title="FPCC API")

sitemaps = {
    'language' : LanguageSitemap(),
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
    path("api/", include("language.urls"), name="language"),
    path("api/", include("arts.urls"), name="arts"),
    path("api/", include("users.urls"), name="users"),
    url(r"api-token-auth/", obtain_auth_token),  # for token based api usage.
    url("docs/crash/$", crash),
    url("docs/$", schema_view),
    path('sitemap.xml', sitemap, {'sitemaps': sitemaps}, name='django.contrib.sitemaps.views.sitemap'),
] + router.urls + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
