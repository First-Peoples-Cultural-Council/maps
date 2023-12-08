from django.db.models import Q
from django.views.decorators.cache import never_cache
from django.utils.decorators import method_decorator
from rest_framework import viewsets, generics
from rest_framework.response import Response

from users.models import Administrator
from language.models import CommunityMember, PlaceName, Media
from web.constants import *


class BaseModelViewSet(viewsets.ModelViewSet):
    """
    Abstract base viewset that allows multiple serializers depending on action.
    """

    def get_serializer_class(self):
        if self.action != "list":
            if hasattr(self, "detail_serializer_class"):
                return self.detail_serializer_class

        return super().get_serializer_class()


class BasePlaceNameListAPIView(generics.ListAPIView):
    """
    Abstract list API view that allows multiple serializers.
    """

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        queryset = get_queryset_for_user(self, request)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


def get_queryset_for_user(view, request):
    """
    Rules based on User Login Status
    1)     If NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
    2)     If USER IS LOGGED IN, show:
    2.1)   User's contribution regardless the status
    2.2)   community_only content from user's communities. Rules:
    2.2.1) If NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
    2.2.2) If COMMUNITY ONLY
    2.3)   Everything from where user is Administrator (language/community pair)
    """

    queryset = view.get_queryset()
    queryset = view.filter_queryset(queryset)

    user_logged_in = False
    if request and hasattr(request, "user"):
        if request.user.is_authenticated:
            user_logged_in = True

    filter_media = user_logged_in and queryset.model is Media and not request.GET.get(
        'placename')
    filter_placenames = user_logged_in and queryset.model is PlaceName

    if filter_media or filter_placenames:
        # 2.1) user's contribution regardless the status
        queryset_user = queryset.filter(creator__id=request.user.id)

        # 2.2) community_only content from user's communities
        user_communities = CommunityMember.objects.filter(
            user__id=int(request.user.id)
        ).filter(
            status__exact=VERIFIED
        ).values('community')

        # 2.2.1) is NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
        # 2.2.2) is COMMUNITY ONLY
        if filter_placenames:
            filter_query = (
                Q(creator=request.user) |
                Q(status=None) |
                Q(status__in=[VERIFIED, UNVERIFIED]) |
                Q(status__in=[FLAGGED, REJECTED],
                  communities__in=user_communities)
            )
            exclude_query = (
                Q(community_only=True) &
                ~Q(communities__in=user_communities)
            )
        else:
            filter_query = (
                Q(creator=request.user) |
                Q(status=None) |
                Q(status__in=[VERIFIED, UNVERIFIED]) |
                Q(status__in=[FLAGGED, REJECTED],
                  placename__communities__in=user_communities)
            )
            exclude_query = (
                Q(community_only=True) &
                ~Q(community__in=user_communities) &
                ~Q(placename__communities__in=user_communities)
            )

        queryset_community = queryset.filter(filter_query).exclude(
            exclude_query
        )

        # 2.3) everything from where user is Administrator (language/community pair)
        admin_languages = Administrator.objects.filter(
            user__id=int(request.user.id)).values('language')
        admin_communities = Administrator.objects.filter(
            user__id=int(request.user.id)).values('community')

        if admin_languages and admin_communities and filter_placenames:
            queryset = _filter_placename_queryset_for_admin(
                queryset, queryset_user, queryset_community, admin_languages, admin_communities)
        elif admin_languages and admin_communities and filter_media:
            queryset = _filter_media_queryset_for_admin(
                queryset, queryset_user, queryset_community, admin_languages, admin_communities)
        else:
            queryset = queryset_user.union(queryset_community)

    else:  # no user is logged in
        queryset = queryset.exclude(
            Q(community_only=True) |
            Q(status=FLAGGED) |
            Q(status=REJECTED)
        )

    return queryset


def _filter_placename_queryset_for_admin(
        queryset, queryset_user, queryset_community, admin_languages, admin_communities):
    # Filter PlaceNames by admin's languages
    queryset_admin = queryset.filter(
        language__in=admin_languages, communities__in=admin_communities
    )
    if queryset_admin:
        queryset = queryset_user.union(
            queryset_community).union(queryset_admin)
    else:
        queryset = queryset_user.union(queryset_community)
    return queryset


def _filter_media_queryset_for_admin(
        queryset, queryset_user, queryset_community, admin_languages, admin_communities):
    # Filter Medias by admin's languages
    qry_adm_community = queryset.filter(
        community__languages__in=admin_languages, community__in=admin_communities
    )
    qry_adm_places = queryset.filter(
        placename__language__in=admin_languages, placename__communities__in=admin_communities
    )
    if qry_adm_community and qry_adm_places:
        queryset = queryset_user.union(queryset_community).union(
            qry_adm_community).union(qry_adm_places)
    elif qry_adm_community:
        queryset = queryset_user.union(
            queryset_community).union(qry_adm_community)
    elif qry_adm_places:
        queryset = queryset_user.union(
            qry_adm_community).union(qry_adm_places)
    else:
        queryset = queryset_user.union(qry_adm_community)
    return queryset
