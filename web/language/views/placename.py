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
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi

from users.models import Administrator
from language.models import Language, PlaceName, Media, PublicArtArtist
from language.filters import ListFilter
from language.views import (
    BaseModelViewSet,
    BasePlaceNameListAPIView,
    get_queryset_for_user,
)
from language.serializers import (
    PlaceNameSerializer,
    PlaceNameDetailSerializer,
    PlaceNameGeoSerializer,
    PlaceNameSearchSerializer,
    ArtPlaceNameSerializer,
    EventArtSerializer,
    ArtworkSerializer,
    ArtworkPlaceNameSerializer,
)

from web.constants import VERIFIED, REJECTED


class PlaceNameFilterSet(FilterSet):
    kinds = ListFilter(field_name="kind", lookup_expr="in")

    class Meta:
        model = PlaceName
        fields = ("kinds", "taxonomies", "creator", "public_arts")


class PlaceNameArtistsFilterSet(FilterSet):
    artists = ListFilter(field_name="artists", lookup_expr="in")

    class Meta:
        model = PlaceName
        fields = ("artists",)


class PlaceNameViewSet(BaseModelViewSet):
    serializer_class = PlaceNameSerializer
    detail_serializer_class = PlaceNameDetailSerializer
    queryset = PlaceName.objects.all().order_by("name")

    # Allow filter by fields and search
    filter_backends = [DjangoFilterBackend, SearchFilter]

    # Search by kinds and taxonomies
    filterset_class = PlaceNameFilterSet

    # Search by name
    search_fields = ["name"]

    @method_decorator(login_required)
    def create(self, request, *args, **kwargs):
        """
        Create a PlaceName of any `kind` (login required).
        """

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                required_fields_missing = False
                errors = {}

                kind = request.data.get("kind")
                kind_text = kind.replace("_", " ").capitalize()

                # Required fields
                name = request.data.get("name")
                description = request.data.get("description")

                # Conditionally required fields
                language = request.data.get("language")
                non_bc_languages = request.data.get("non_bc_languages")
                communities = request.data.get("communities")
                other_community = request.data.get("other_community")

                if not name:
                    required_fields_missing = True
                    errors[kind_text + " Name"] = "This field may not be blank."

                if not description:
                    required_fields_missing = True

                    if kind == "artist":
                        kind_text = kind_text + " Bio/Artist Statement"
                    else:
                        kind_text = kind_text + " Description"

                    errors[kind_text] = "This field may not be blank."

                if kind in ["artist", "organization"]:
                    if not language and not non_bc_languages:
                        required_fields_missing = True
                        errors["Language"] = "This field may not be blank."
                    if not communities and not other_community:
                        required_fields_missing = True
                        errors["Community"] = "This field may not be blank."

                if required_fields_missing:
                    return Response(errors, status=status.HTTP_400_BAD_REQUEST)
                return super().create(request)

        return Response(
            {
                "success": False,
                "message": "You need to log in in order to create a PlaceName.",
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    def perform_create(self, serializer):
        obj = serializer.save(creator=self.request.user)

        admin_communities = list(
            Administrator.objects.filter(
                user__id=int(self.request.user.id)
            ).values_list("community", flat=True)
        )
        admin_languages = list(
            Administrator.objects.filter(
                user__id=int(self.request.user.id)
            ).values_list("language", flat=True)
        )

        if (
            (
                obj.communities
                and obj.communities.filter(id__in=admin_communities).exists()
            )
            or (obj.language and obj.language.id in admin_languages)
            or (self.request.user.is_staff or self.request.user.is_superuser)
        ):
            obj.status = "VE"
            obj.save()

    def update(self, request, *args, **kwargs):
        """
        Update a PlaceName object (login/ownership required)
        """

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                placename = PlaceName.objects.get(pk=kwargs.get("pk"))

                # Check if placename is owned by current user
                owned_placename = placename.creator == request.user

                # Check if this placename is a public art and the user is its artist
                artist_owned_placename = False
                artist_profile_ids = PlaceName.objects.filter(
                    kind="artist", creator=request.user
                ).values_list("id", flat=True)

                if artist_profile_ids and placename.kind == "public_art":
                    try:
                        owned_public_art = PublicArtArtist.objects.get(
                            artist__in=artist_profile_ids, public_art=placename
                        )
                    except PublicArtArtist.DoesNotExist:
                        owned_public_art = None

                    if owned_public_art and owned_public_art.public_art == placename:
                        artist_owned_placename = True

                if owned_placename or artist_owned_placename:
                    return super().update(request, *args, **kwargs)

                return Response(
                    {
                        "success": False,
                        "message": "Only the owner or the artist can update this Place.",
                    }
                )

        return Response(
            {
                "success": False,
                "message": "You need to log in in order to update this Place.",
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    def destroy(self, request, *args, **kwargs):
        """
        Delete a PlaceName object (login/ownership required).
        """

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                placename = PlaceName.objects.get(pk=kwargs.get("pk"))

                # Check if placename is owned by current user
                owned_placename = placename.creator == request.user

                if owned_placename:
                    return super().destroy(request, *args, **kwargs)

                return Response(
                    {
                        "success": False,
                        "message": "Only the owner can delete this Place.",
                    }
                )

        return Response(
            {
                "success": False,
                "message": "You need to log in in order to delete this Place.",
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    @action(detail=True, methods=["patch"])
    def verify(self, request, *args, **kwargs):
        """
        Set the status of a PlaceName's status to `VERIFIED` (Django admin access required).
        """

        instance = self.get_object()
        if request and hasattr(request, "user") and request.user.is_authenticated:
            if instance.kind not in ["", "poi"]:
                return Response(
                    {"success": False, "message": "Invalid action."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            if instance.status == VERIFIED:
                return Response(
                    {"success": False, "message": "Place has already been verified."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            instance.verify()
            return Response({"success": True, "message": "Verified."})

        return Response(
            {
                "success": False,
                "message": "Only Administrators can verify contributions.",
            },
            status=status.HTTP_403_FORBIDDEN,
        )

    @action(detail=True, methods=["patch"])
    def reject(self, request, *args, **kwargs):
        """
        Sets the status of a PlaceName's status to `REJECTED` (Django admin access required).
        """

        instance = self.get_object()
        if request and hasattr(request, "user") and request.user.is_authenticated:
            if instance.kind not in ["", "poi"]:
                return Response(
                    {"success": False, "message": "Invalid action."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            if instance.status == VERIFIED:
                return Response(
                    {"success": False, "message": "Place has already been verified."}
                )

            if "status_reason" not in request.data.keys():
                return Response(
                    {"success": False, "message": "Reason must be provided."}
                )

            instance.reject(request.data["status_reason"])
            return Response({"success": True, "message": "Rejected."})

        return Response(
            {
                "success": False,
                "message": "Only Administrators can reject contributions.",
            },
            status=status.HTTP_403_FORBIDDEN,
        )

    @action(detail=True, methods=["patch"])
    def flag(self, request, *args, **kwargs):
        """
        Sets the status of a PlaceName's status to `FLAGGED`.
        """

        instance = self.get_object()
        if instance.kind not in ["", "poi"]:
            return Response(
                {"success": False, "message": "Invalid action."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if instance.status == VERIFIED:
            return Response(
                {"success": False, "message": "Place has already been verified."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if "status_reason" not in request.data.keys():
            return Response({"success": False, "message": "Reason must be provided."})

        instance.flag(request.data["status_reason"])
        return Response({"success": True, "message": "Flagged."})

    @method_decorator(never_cache)
    def detail(self, request):
        return super().detail(request)

    @method_decorator(never_cache)
    def retrieve(self, request, *args, **kwargs):
        """
        Retrieve a PlaceName object (viewable information may vary)
        """

        placename = PlaceName.objects.get(pk=kwargs.get("pk"))
        serializer = self.get_serializer(placename)
        serializer_data = serializer.data

        # CLEAN RELATED DATA - Set private data to confidential if necessary
        related_data = []
        for data in serializer_data["related_data"]:
            # If value needs to be set to confidential, set it
            if data["value"] != "" and data["is_private"]:
                if (
                    request
                    and hasattr(request, "user")
                    and request.user.is_authenticated
                ):
                    # Only hide the data if the user accessing it is not the owner
                    if (
                        placename.creator
                        and placename.creator.id is not request.user.id
                    ):
                        data["value"] = "CONFIDENTIAL"
                else:
                    data["value"] = "CONFIDENTIAL"

            if data["value"] != "":
                related_data.append(data)

        serializer_data["related_data"] = related_data

        return Response(serializer_data)

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' PlaceNames do not need to the verified
        queryset = (
            self.get_queryset()
            .filter(kind__in=["", "poi"])
            .exclude(status__exact=VERIFIED)
            .exclude(status__exact=REJECTED)
        )

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                admin_languages = Administrator.objects.filter(
                    user__id=int(request.user.id)
                ).values("language")
                admin_communities = Administrator.objects.filter(
                    user__id=int(request.user.id)
                ).values("community")

                if admin_languages or admin_communities:
                    queryset_places = queryset.filter(
                        Q(language__in=admin_languages)
                        | Q(communities__in=admin_communities)
                    )

                    serializer = self.serializer_class(queryset_places, many=True)

                    return Response(serializer.data)
        return Response([])

    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        queryset = get_queryset_for_user(self, request)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


# GEO LIST APIVIEWS
class PlaceNameGeoList(generics.ListAPIView):
    """
    List all POIs, in a geo format, to be used in the frontend's map.
    """

    queryset = (
        PlaceName.objects.exclude(name__icontains="FirstVoices")
        .filter(kind__in=["poi", ""], geom__isnull=False)
        .only("id", "name", "kind", "communities", "geom")
    )
    serializer_class = PlaceNameGeoSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = [
        "language",
    ]

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        queryset = get_queryset_for_user(self, request)

        if "lang" in request.GET:
            language_id = request.GET.get("lang")
            language = Language.objects.get(pk=language_id)

            queryset = self.queryset.filter(
                Q(geom__intersects=language.geom) | Q(language=language)
            )

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


class ArtGeoList(generics.ListAPIView):
    """
    List all arts in a geo format (can be filtered by language).
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(
            kind__in=["public_art", "artist", "organization", "event", "resource"],
            geom__isnull=False,
        )
        .only("id", "name", "kind", "communities", "geom")
    )
    serializer_class = PlaceNameGeoSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["language"]

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                "language",
                openapi.IN_QUERY,
                description="Filter results by language ID",
                type=openapi.TYPE_INTEGER,
                required=False,
            )
        ],
    )
    def get(self, request, *args, **kwargs):
        queryset = get_queryset_for_user(self, request)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)


# SEARCH LIST APIVIEWS
class PlaceNameSearchList(BasePlaceNameListAPIView):
    """
    List all POIs to be used in the frontend's search bar.
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind__in=["poi", ""])
        .only("id", "name", "other_names", "kind", "artists")
    )
    serializer_class = PlaceNameSearchSerializer


class ArtSearchList(BasePlaceNameListAPIView):
    """
    List all arts to be used in the frontend's search bar.
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind__in=["public_art", "artist", "organization", "event"])
        .prefetch_related("related_data")
    )
    serializer_class = PlaceNameSearchSerializer

    filter_backends = [DjangoFilterBackend]
    filterset_class = PlaceNameArtistsFilterSet


# ART TYPES
class PublicArtList(BasePlaceNameListAPIView):
    """
    List all public arts, in a geo format, to be used in the frontend's map.
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind="public_art", geom__isnull=False)
        .only("id", "name", "kind", "image", "taxonomies", "geom")
    )
    serializer_class = ArtPlaceNameSerializer


class ArtistList(BasePlaceNameListAPIView):
    """
    List all artists, in a geo format, to be used in the frontend's map.
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind="artist", geom__isnull=False)
        .only("id", "name", "kind", "image", "taxonomies", "geom")
    )
    serializer_class = ArtPlaceNameSerializer


class EventList(BasePlaceNameListAPIView):
    """
    List all events, in a geo format, to be used in the frontend's map.
    """

    queryset = PlaceName.objects.exclude(
        Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
    ).filter(kind="event", geom__isnull=False)
    serializer_class = EventArtSerializer


class OrganizationList(BasePlaceNameListAPIView):
    """
    List all organizations, in a geo format, to be used in the frontend's map.
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind="organization", geom__isnull=False)
        .only("id", "name", "kind", "image", "taxonomies", "geom")
    )
    serializer_class = ArtPlaceNameSerializer


class ResourceList(BasePlaceNameListAPIView):
    """
    List all resources, in a geo format, to be used in the frontend's map.
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind="resource", geom__isnull=False)
        .only("id", "name", "kind", "image", "taxonomies", "geom")
    )
    serializer_class = ArtPlaceNameSerializer


class GrantList(BasePlaceNameListAPIView):
    """
    List all grants in a geo format (deprecated).
    """

    queryset = (
        PlaceName.objects.exclude(
            Q(name__icontains="FirstVoices") | Q(geom__exact=Point(0.0, 0.0))
        )
        .filter(kind="grant", geom__isnull=False)
        .only("id", "name", "kind", "image", "taxonomies", "geom")
    )
    serializer_class = ArtPlaceNameSerializer


# ARTWORKS
class ArtworkList(generics.ListAPIView):
    """
    List all artworks, in a geo format, to be used in the frontend's map.
    """

    queryset = (
        Media.objects.exclude(Q(placename__name__icontains="FirstVoices"))
        .filter(is_artwork=True, placename__geom__isnull=False)
        .select_related("placename")
    )
    serializer_class = ArtworkSerializer

    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        return super().list(request)


class ArtworkPlaceNameList(generics.ListAPIView):
    """
    List all PlaceNames with media attached to it.
    """

    queryset = PlaceName.objects.exclude(
        Q(medias__isnull=True) | Q(geom__exact=Point(0.0, 0.0))
    ).only("id", "name", "image", "kind", "geom")
    serializer_class = ArtworkPlaceNameSerializer

    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        return super().list(request)
