from django.db.models import Q
from django.views.decorators.cache import never_cache
from django.contrib.auth.decorators import login_required
from django.contrib.gis.geos import Point
from django.utils.decorators import method_decorator
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.filters import SearchFilter
from django_filters.rest_framework import DjangoFilterBackend
from django_filters import FilterSet

from users.models import Administrator
from language.models import (
    Language,
    PlaceName,
    CommunityMember,
    Media,
    PublicArtArtist
)
from language.notifications import inform_placename_rejected_or_flagged, inform_placename_to_be_verified
from language.filters import ListFilter
from language.views import BaseModelViewSet, BasePlaceNameListAPIView
from language.serializers import (
    PlaceNameSerializer,
    PlaceNameDetailSerializer,
    PlaceNameGeoSerializer,
    PlaceNameSearchSerializer,
    ArtPlaceNameSerializer,
    EventArtSerializer,
    ArtworkSerializer,
    ArtworkPlaceNameSerializer
)
from web.constants import *


class PlaceNameFilterSet(FilterSet):
    kinds = ListFilter(field_name='kind', lookup_expr='in')

    class Meta:
        model = PlaceName
        fields = ('kinds', 'taxonomies', 'creator', 'public_arts')


class PlaceNameArtistsFilterSet(FilterSet):
    artists = ListFilter(field_name='artists', lookup_expr='in')

    class Meta:
        model = PlaceName
        fields = ('artists', )


class PlaceNameViewSet(BaseModelViewSet):
    serializer_class = PlaceNameSerializer
    detail_serializer_class = PlaceNameDetailSerializer
    queryset = PlaceName.objects.all().order_by('name')

    # Allow filter by fields and search
    filter_backends = [DjangoFilterBackend, SearchFilter]

    # Search by kinds and taxonomies
    filterset_class = PlaceNameFilterSet

    # Search by name
    search_fields = ['name']

    @method_decorator(login_required)
    def create(self, request):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                required_fields_missing = False
                errors = {}

                kind = request.data.get('kind')
                kind_text = kind.replace('_', ' ').capitalize()

                # Required fields
                name = request.data.get('name')
                description = request.data.get('description')

                # Conditionally required fields
                language = request.data.get('language')
                non_bc_languages = request.data.get('non_bc_languages')
                community = request.data.get('community')
                other_community = request.data.get('other_community')

                if not name:
                    required_fields_missing = True
                    errors[kind_text + ' Name'] = 'This field may not be blank.'

                if not description:
                    required_fields_missing = True

                    if kind == 'artist':
                        kind_text = kind_text + ' Bio/Artist Statement'
                    else:
                        kind_text = kind_text + ' Description'

                    errors[kind_text] = 'This field may not be blank.'

                if kind == 'artist' or kind == 'organization':
                    if not language and not non_bc_languages:
                        required_fields_missing = True
                        errors['Language'] = 'This field may not be blank.'
                    if not community and not other_community:
                        required_fields_missing = True
                        errors['Community'] = 'This field may not be blank.'

                if required_fields_missing:
                    return Response(
                        errors,
                        status=status.HTTP_400_BAD_REQUEST
                    )
                return super().create(request)

        return Response({
            'success': False,
            'message': 'You need to log in in order to create a PlaceName.'
        })

    def perform_create(self, serializer):
        obj = serializer.save(creator=self.request.user)

        admin_communities = list(Administrator.objects.filter(
            user__id=int(self.request.user.id)).values_list('community', flat=True))
        admin_languages = list(Administrator.objects.filter(
            user__id=int(self.request.user.id)).values_list('language', flat=True))

        if (obj.community and obj.community.id in admin_communities) or \
                (obj.language and obj.language.id in admin_languages):
            obj.status = 'VE'
            obj.save()

    def update(self, request, *args, **kwargs):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                placename = PlaceName.objects.get(pk=kwargs.get('pk'))

                # Check if placename is owned by current user
                owned_placename = True if placename.creator == request.user else False

                # Check if this placename is a public art and the user is its artist
                artist_owned_placename = False
                artist_profile_ids = PlaceName.objects.filter(
                    kind='artist', creator=request.user).values_list('id', flat=True)

                if artist_profile_ids and placename.kind == 'public_art':
                    try:
                        owned_public_art = PublicArtArtist.objects.get(
                            artist__in=artist_profile_ids, public_art=placename)
                    except PublicArtArtist.DoesNotExist:
                        owned_public_art = None

                    if owned_public_art and owned_public_art.public_art == placename:
                        artist_owned_placename = True

                if owned_placename or artist_owned_placename:
                    return super().update(request, *args, **kwargs)
                else:
                    return Response({
                        'success': False,
                        'message': 'Only the owner or the artist can update this PlaceName.'
                    })

        return Response({
            'success': False,
            'message': 'You need to log in in order to update this PlaceName.'
        })

    def destroy(self, request, *args, **kwargs):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                placename = PlaceName.objects.get(pk=kwargs.get('pk'))

                # Check if placename is owned by current user
                owned_placename = True if placename.creator == request.user else False

                if owned_placename:
                    return super().destroy(request, *args, **kwargs)
                else:
                    return Response({
                        'success': False,
                        'message': 'Only the owner can delete this PlaceName.'
                    })

        return Response({
            'success': False,
            'message': 'You need to log in in order to delete this PlaceName.'
        })

    @action(detail=True, methods=['patch'])
    def verify(self, request, pk):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                try:
                    PlaceName.verify(int(pk))
                    return Response({
                        'success': True,
                        'message': 'Verified.'
                    })
                except PlaceName.DoesNotExist:
                    return Response({
                        'success': False,
                        'message': 'No PlaceName with the given id was found.'
                    })

        return Response({
            'success': False,
            'message': 'Only Administrators can verify contributions.'
        })

    @action(detail=True, methods=['patch'])
    def reject(self, request, pk):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                try:
                    if 'status_reason' in request.data.keys():
                        PlaceName.reject(
                            int(pk), request.data['status_reason'])

                        # Notifying the creator
                        try:
                            inform_placename_rejected_or_flagged(
                                int(pk), request.data['status_reason'], REJECTED)
                        except Exception as e:
                            pass

                        return Response({
                            'success': True,
                            'message': 'Rejected.'
                        })
                    else:
                        return Response({
                            'success': False,
                            'message': 'Reason must be provided.'
                        })
                except PlaceName.DoesNotExist:
                    return Response({
                        'success': False,
                        'message': 'No PlaceName with the given id was found.'
                    })

        return Response({
            'success': False,
            'message': 'Only Administrators can reject contributions.'
        })

    @action(detail=True, methods=['patch'])
    def flag(self, request, pk):
        try:
            placename = PlaceName.objects.get(pk=int(pk))
            if placename.status == VERIFIED:
                return Response({
                    'success': False,
                    'message': 'PlaceName has already been verified.'
                })
            else:
                if 'status_reason' in request.data.keys():
                    PlaceName.flag(int(pk), request.data['status_reason'])

                    # Notifying Administrators
                    try:
                        inform_placename_to_be_verified(int(pk))
                    except Exception as e:
                        pass

                    # Notifying the creator
                    try:
                        inform_placename_rejected_or_flagged(
                            int(pk), request.data['status_reason'], FLAGGED)
                    except Exception as e:
                        pass

                    return Response({
                        'success': True,
                        'message': 'Flagged.'
                    })
                else:
                    return Response({
                        'success': False,
                        'message': 'Reason must be provided.'
                    })
        except PlaceName.DoesNotExist:
            return Response({
                'success': False,
                'message': 'No PlaceName with the given id was found.'
            })

    @method_decorator(never_cache)
    def detail(self, request):
        return super().detail(request)

    @method_decorator(never_cache)
    def retrieve(self, request, *args, **kwargs):
        placename = PlaceName.objects.get(pk=kwargs.get('pk'))
        serializer = self.get_serializer(placename)
        serializer_data = serializer.data

        # CLEAN RELATED DATA - Set private data to confidential if necessary
        related_data = []
        for data in serializer_data['related_data']:
            # If value needs to be set to confidential, set it
            if data['value'] is not '' and data['is_private']:
                if request and hasattr(request, 'user') and request.user.is_authenticated:
                    # Only hide the data if the user accessing it is not the owner
                    if placename.creator and placename.creator.id is not request.user.id:
                        data['value'] = 'CONFIDENTIAL'
                else:
                    data['value'] = 'CONFIDENTIAL'

            if data['value'] is not '':
                related_data.append(data)

        serializer_data['related_data'] = related_data

        return Response(serializer_data)

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' PlaceNames do not need to the verified
        queryset = self.get_queryset().exclude(
            status__exact=VERIFIED).exclude(status__exact=REJECTED)

        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                admin_languages = Administrator.objects.filter(
                    user__id=int(request.user.id)).values('language')
                admin_communities = Administrator.objects.filter(
                    user__id=int(request.user.id)).values('community')

                if admin_languages and admin_communities:
                    # Filter Medias by admin's languages
                    queryset_places = queryset.filter(
                        language__in=admin_languages, community__in=admin_communities
                    )

                    serializer = self.serializer_class(
                        queryset_places, many=True)

                    return Response(serializer.data)
        return Response([])

    @method_decorator(never_cache)
    def list(self, request):
        """
        Rules based on User Login Status
        # 1)     If NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
        # 2)     If USER IS LOGGED IN, show:
        # 2.1)   User's contribution regardless the status
        # 2.2)   community_only content from user's communities. Rules:
        # 2.2.1) If NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
        # 2.2.2) If COMMUNITY ONLY
        # 2.3)   Everything from where user is Administrator (language/community pair)
        """
        queryset = self.get_queryset()
        queryset = self.filter_queryset(queryset)

        user_logged_in = False
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                user_logged_in = True

        if user_logged_in:

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
            queryset_community = queryset.filter(
                Q(community_only=False, status__exact=VERIFIED)
                | Q(community_only=False, status__exact=UNVERIFIED)
                | Q(community_only=False, status__isnull=True)
                | Q(community_only__isnull=True, status__exact=VERIFIED)
                | Q(community_only__isnull=True, status__exact=UNVERIFIED)
                | Q(community_only__isnull=True, status__isnull=True)
                | Q(community__in=user_communities)
            )

            # 2.3) everything from where user is Administrator (language/community pair)
            admin_languages = Administrator.objects.filter(
                user__id=int(request.user.id)).values('language')
            admin_communities = Administrator.objects.filter(
                user__id=int(request.user.id)).values('community')

            if admin_languages and admin_communities:
                # Filter PlaceNames by admin's languages
                queryset_admin = queryset.filter(
                    language__in=admin_languages, community__in=admin_communities
                )
                if queryset_admin:
                    queryset = queryset_user.union(
                        queryset_community).union(queryset_admin)
                else:
                    queryset = queryset_user.union(queryset_community)
            else:  # user is not Administrator of anything
                queryset = queryset_user.union(queryset_community)

        else:  # no user is logged in
            queryset = queryset.filter(
                Q(status__exact=VERIFIED)
                | Q(status__exact=UNVERIFIED)
                | Q(status__isnull=True)
            )

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


# GEO LIST APIVIEWS
class PlaceNameGeoList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(
        name__icontains='FirstVoices'
    ).filter(
        kind__in=['poi', ''],
        geom__isnull=False
    ).only('id', 'name', 'kind', 'community', 'geom')
    serializer_class = PlaceNameGeoSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['language', ]

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        """
        Rules based on User Login Status
        # 1)     If NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
        # 2)     If USER IS LOGGED IN, show:
        # 2.1)   User's contribution regardless the status
        # 2.2)   community_only content from user's communities. Rules:
        # 2.2.1) If NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
        # 2.2.2) If COMMUNITY ONLY
        # 2.3)   Everything from where user is Administrator (language/community pair)
        """
        queryset = self.get_queryset()
        queryset = self.filter_queryset(queryset)

        user_logged_in = False
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                user_logged_in = True

        if user_logged_in:

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
            queryset_community = queryset.filter(
                Q(community_only=False, status__exact=VERIFIED)
                | Q(community_only=False, status__exact=UNVERIFIED)
                | Q(community_only=False, status__isnull=True)
                | Q(community_only__isnull=True, status__exact=VERIFIED)
                | Q(community_only__isnull=True, status__exact=UNVERIFIED)
                | Q(community_only__isnull=True, status__isnull=True)
                | Q(community__in=user_communities)
            )

            # 2.3) everything from where user is Administrator (language/community pair)
            admin_languages = Administrator.objects.filter(
                user__id=int(request.user.id)).values('language')
            admin_communities = Administrator.objects.filter(
                user__id=int(request.user.id)).values('community')

            if admin_languages and admin_communities:
                # Filter PlaceNames by admin's languages
                queryset_admin = queryset.filter(
                    language__in=admin_languages, community__in=admin_communities
                )
                if queryset_admin:
                    queryset = queryset_user.union(
                        queryset_community).union(queryset_admin)
                else:
                    queryset = queryset_user.union(queryset_community)
            else:  # user is not Administrator of anything
                queryset = queryset_user.union(queryset_community)

        else:  # no user is logged in
            queryset = queryset.filter(
                Q(status__exact=VERIFIED)
                | Q(status__exact=UNVERIFIED)
                | Q(status__isnull=True)
            )

        if 'lang' in request.GET:
            language_id = request.GET.get('lang')
            language = Language.objects.get(pk=language_id)

            queryset = self.queryset.filter(
                Q(geom__intersects=language.geom) |
                Q(language=language)
            )

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


class ArtGeoList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind__in=['public_art', 'artist', 'organization',
                  'event', 'resource'],
        geom__isnull=False
    ).only('id', 'name', 'kind', 'community', 'geom')
    serializer_class = PlaceNameGeoSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['language', ]

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        """
        Rules based on User Login Status
        # 1)     If NO USER is logged in, only shows VERIFIED, UNVERIFIED or no status content
        # 2)     If USER IS LOGGED IN, show:
        # 2.1)   User's contribution regardless the status
        # 2.2)   community_only content from user's communities. Rules:
        # 2.2.1) If NOT COMMUNITY ONLY (False or NULL) but status is VERIFIED, UNVERIFIED or NULL
        # 2.2.2) If COMMUNITY ONLY
        # 2.3)   Everything from where user is Administrator (language/community pair)
        """
        queryset = self.get_queryset()
        queryset = self.filter_queryset(queryset)

        user_logged_in = False
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                user_logged_in = True

        if user_logged_in:

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
            queryset_community = queryset.filter(
                Q(community_only=False, status__exact=VERIFIED)
                | Q(community_only=False, status__exact=UNVERIFIED)
                | Q(community_only=False, status__isnull=True)
                | Q(community_only__isnull=True, status__exact=VERIFIED)
                | Q(community_only__isnull=True, status__exact=UNVERIFIED)
                | Q(community_only__isnull=True, status__isnull=True)
                | Q(community__in=user_communities)
            )

            # 2.3) everything from where user is Administrator (language/community pair)
            admin_languages = Administrator.objects.filter(
                user__id=int(request.user.id)).values('language')
            admin_communities = Administrator.objects.filter(
                user__id=int(request.user.id)).values('community')

            if admin_languages and admin_communities:
                # Filter PlaceNames by admin's languages
                queryset_admin = queryset.filter(
                    language__in=admin_languages, community__in=admin_communities
                )
                if queryset_admin:
                    queryset = queryset_user.union(
                        queryset_community).union(queryset_admin)
                else:
                    queryset = queryset_user.union(queryset_community)
            else:  # user is not Administrator of anything
                queryset = queryset_user.union(queryset_community)

        else:  # no user is logged in
            queryset = queryset.filter(
                Q(status__exact=VERIFIED)
                | Q(status__exact=UNVERIFIED)
                | Q(status__isnull=True)
            )

        if 'lang' in request.GET:
            language_id = request.GET.get('lang')
            language = Language.objects.get(pk=language_id)

            queryset = self.queryset.filter(
                Q(geom__intersects=language.geom) |
                Q(language=language)
            )

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


# SEARCH LIST APIVIEWS
class PlaceNameSearchList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind__in=['poi', '']
    ).only('id', 'name', 'other_names', 'kind', 'artists')
    serializer_class = PlaceNameSearchSerializer


class ArtSearchList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind__in=['public_art', 'artist', 'organization', 'event']
    ).only('id', 'name', 'other_names', 'kind', 'artists')
    serializer_class = PlaceNameSearchSerializer

    filter_backends = [DjangoFilterBackend]
    filterset_class = PlaceNameArtistsFilterSet


# ART TYPES
class PublicArtList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind='public_art',
        geom__isnull=False
    ).only('id', 'name', 'kind', 'image', 'taxonomies', 'geom')
    serializer_class = ArtPlaceNameSerializer


class ArtistList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind='artist',
        geom__isnull=False
    ).only('id', 'name', 'kind', 'image', 'taxonomies', 'geom')
    serializer_class = ArtPlaceNameSerializer


class EventList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind='event',
        geom__isnull=False
    )
    serializer_class = EventArtSerializer


class OrganizationList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind='organization',
        geom__isnull=False
    ).only('id', 'name', 'kind', 'image', 'taxonomies', 'geom')
    serializer_class = ArtPlaceNameSerializer


class ResourceList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind='resource',
        geom__isnull=False
    ).only('id', 'name', 'kind', 'image', 'taxonomies', 'geom')
    serializer_class = ArtPlaceNameSerializer


class GrantList(BasePlaceNameListAPIView):
    queryset = PlaceName.objects.exclude(
        Q(name__icontains='FirstVoices') | Q(geom__exact=Point(0.0, 0.0))
    ).filter(
        kind='grant',
        geom__isnull=False
    ).only('id', 'name', 'kind', 'image', 'taxonomies', 'geom')
    serializer_class = ArtPlaceNameSerializer


# ARTWORKS
class ArtworkList(generics.ListAPIView):
    queryset = Media.objects.exclude(
        Q(placename__name__icontains='FirstVoices')
    ).filter(is_artwork=True, placename__geom__isnull=False).select_related('placename')
    serializer_class = ArtworkSerializer

    @method_decorator(never_cache)
    def list(self, request):
        return super().list(request)


class ArtworkPlaceNameList(generics.ListAPIView):
    queryset = PlaceName.objects.exclude(Q(medias__isnull=True) | Q(
        geom__exact=Point(0.0, 0.0))).only(
            'id',
            'name',
            'image',
            'kind',
            'geom'
    )
    serializer_class = ArtworkPlaceNameSerializer

    @method_decorator(never_cache)
    def list(self, request):
        return super().list(request)
