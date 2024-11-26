from django.db.models import Q
from django.views.decorators.cache import never_cache
from django.utils.decorators import method_decorator
from rest_framework import mixins, status
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action
from django_filters.rest_framework import DjangoFilterBackend

from users.models import Administrator
from language.models import Media
from language.serializers import MediaSerializer
from language.views.base import get_queryset_for_user
from web.constants import VERIFIED, REJECTED


# To enable only CREATE and DELETE, we create a custom ViewSet class...
class MediaCustomViewSet(
    mixins.CreateModelMixin,
    mixins.DestroyModelMixin,
    mixins.RetrieveModelMixin,
    mixins.UpdateModelMixin,
    GenericViewSet,
):
    pass


class MediaViewSet(MediaCustomViewSet, GenericViewSet):
    serializer_class = MediaSerializer
    queryset = Media.objects.all()

    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["placename", "community"]

    def create(self, request, *args, **kwargs):
        """
        Create a Media object (automatically set to `VERIFIED` if the creator is a community admin).
        """

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                return super().create(request)

        return Response(
            {
                "success": False,
                "message": "You need to log in in order to create a Media record.",
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

        if (
            obj.community
            and obj.community.id in admin_communities
            or self.request.user.is_staff
            or self.request.user.is_superuser
        ):
            obj.status = "VE"
            obj.save()

    def update(self, request, *args, **kwargs):
        """
        Update a Media object (login/ownership required).
        """

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                media = Media.objects.get(pk=kwargs.get("pk"))

                # Check if media is owned by current user
                owned_media = media.creator == request.user

                if owned_media:
                    return super().update(request, *args, **kwargs)

                return Response(
                    {
                        "success": False,
                        "message": "Only the owner can update this Media record.",
                    }
                )

        return Response(
            {
                "success": False,
                "message": "You need to log in in order to update this Media record.",
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    def destroy(self, request, *args, **kwargs):
        """
        Destroy a Media object (login/ownership required).
        """

        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                media = Media.objects.get(pk=kwargs.get("pk"))

                # Check if media is owned by current user
                owned_media = media.creator == request.user

                if owned_media:
                    return super().destroy(request, *args, **kwargs)

                return Response(
                    {
                        "success": False,
                        "message": "Only the owner can delete this Media record.",
                    }
                )

        return Response(
            {
                "success": False,
                "message": "You need to log in in order to delete this Media record.",
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        """
        List all Media that are awaiting verification (community/language admin access required)
        """

        # 'VERIFIED' Media do not need to the verified
        queryset = (
            self.get_queryset()
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

                if admin_languages and admin_communities:
                    # Filter Medias by admin's languages
                    queryset_places = queryset.filter(
                        Q(placename__language__in=admin_languages)
                        | Q(placename__communities__in=admin_communities)
                    )
                    queryset_communities = queryset.filter(
                        Q(community__languages__in=admin_languages)
                        | Q(community__in=admin_communities)
                    )
                    queryset = queryset_communities.union(queryset_places)

                    serializer = self.serializer_class(queryset, many=True)

                    return Response(serializer.data)
        return Response([])

    @action(detail=True, methods=["patch"])
    def verify(self, request, *args, **kwargs):
        """
        Set the Media's status to `VERIFIED` (Django admin access required).
        """

        instance = self.get_object()

        if request and hasattr(request, "user") and request.user.is_authenticated:
            if instance.status == VERIFIED:
                return Response(
                    {"success": False, "message": "Media has already been verified."},
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
        Set the Media's status to `REJECTED` (Django admin access required).
        """

        instance = self.get_object()

        if request and hasattr(request, "user") and request.user.is_authenticated:
            if instance.status == VERIFIED:
                return Response(
                    {"success": False, "message": "Media has already been verified."},
                    status=status.HTTP_400_BAD_REQUEST,
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
        Set the Media's status to `FLAGGED`.
        """

        instance = self.get_object()

        if instance.status == VERIFIED:
            return Response(
                {"success": False, "message": "Media has already been verified."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if "status_reason" not in request.data.keys():
            return Response({"success": False, "message": "Reason must be provided."})

        instance.flag(request.data["status_reason"])
        return Response({"success": True, "message": "Flagged."})

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request, *args, **kwargs):
        """
        List all Media.
        """

        queryset = get_queryset_for_user(self, request)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)
