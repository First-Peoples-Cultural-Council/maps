from django.db.models import Q
from django.views.decorators.cache import never_cache
from django.utils.decorators import method_decorator
from rest_framework import mixins
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action
from django_filters.rest_framework import DjangoFilterBackend

from users.models import Administrator
from language.models import CommunityMember, Media, PlaceName
from language.notifications import inform_media_rejected_or_flagged, inform_media_to_be_verified
from language.serializers import MediaSerializer
from web.constants import *
from .base import get_queryset_for_user


# To enable only CREATE and DELETE, we create a custom ViewSet class...
class MediaCustomViewSet(
    mixins.CreateModelMixin,
    mixins.DestroyModelMixin,
    mixins.RetrieveModelMixin,
    mixins.UpdateModelMixin,
    GenericViewSet
):
    pass


class MediaViewSet(MediaCustomViewSet, GenericViewSet):
    serializer_class = MediaSerializer
    queryset = Media.objects.all()

    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['placename', 'community']

    def create(self, request):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                return super().create(request)

        return Response({
            'success': False,
            'message': 'You need to log in in order to create a Media record.'
        })

    def perform_create(self, serializer):
        obj = serializer.save(creator=self.request.user)

        admin_communities = list(Administrator.objects.filter(
            user__id=int(self.request.user.id)).values_list('community', flat=True))

        if (obj.community and obj.community.id in admin_communities):
            obj.status = 'VE'
            obj.save()

    def update(self, request, *args, **kwargs):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                media = Media.objects.get(pk=kwargs.get('pk'))

                # Check if media is owned by current user
                owned_media = True if media.creator == request.user else False

                if owned_media:
                    return super().update(request, *args, **kwargs)
                else:
                    return Response({
                        'success': False,
                        'message': 'Only the owner can update this Media record.'
                    })

        return Response({
            'success': False,
            'message': 'You need to log in in order to update this Media record.'
        })

    def destroy(self, request, *args, **kwargs):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                media = Media.objects.get(pk=kwargs.get('pk'))

                # Check if media is owned by current user
                owned_media = True if media.creator == request.user else False

                if owned_media:
                    return super().destroy(request, *args, **kwargs)
                else:
                    return Response({
                        'success': False,
                        'message': 'Only the owner can delete this Media record.'
                    })

        return Response({
            'success': False,
            'message': 'You need to log in in order to delete this Media record.'
        })

    @method_decorator(never_cache)
    @action(detail=False)
    def list_to_verify(self, request):
        # 'VERIFIED' Media do not need to the verified
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
                        Q(placename__language__in=admin_languages) | Q(
                            placename__community__in=admin_communities)
                    )
                    queryset_communities = queryset.filter(
                        Q(community__languages__in=admin_languages) | Q(
                            community__in=admin_communities)
                    )
                    queryset = queryset_communities.union(queryset_places)

                    serializer = self.serializer_class(queryset, many=True)

                    return Response(serializer.data)
        return Response([])

    @action(detail=True, methods=['patch'])
    def verify(self, request, pk):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                try:
                    Media.verify(int(pk))
                    return Response({
                        'success': True,
                        'message': 'Verified.'
                    })
                except Media.DoesNotExist:
                    return Response({
                        'success': False,
                        'message': 'No Media with the given id was found.'
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
                        Media.reject(int(pk), request.data['status_reason'])

                        # Notifying the creator
                        try:
                            inform_media_rejected_or_flagged(
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
                except Media.DoesNotExist:
                    return Response({
                        'success': False,
                        'message': 'No Media with the given id was found.'
                    })

        return Response({
            'success': False,
            'message': 'Only Administrators can reject contributions.'
        })

    @action(detail=True, methods=['patch'])
    def flag(self, request, pk):
        try:
            media = Media.objects.get(pk=int(pk))
            if media.status == VERIFIED:
                return Response({
                    'success': False,
                    'message': 'Media has already been verified.'
                })
            else:
                if 'status_reason' in request.data.keys():
                    Media.flag(int(pk), request.data['status_reason'])

                    # Notifying Administrators
                    try:
                        inform_media_to_be_verified(int(pk))
                    except Exception as e:
                        pass

                    # Notifying the creator
                    try:
                        inform_media_rejected_or_flagged(
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
        except Media.DoesNotExist:
            return Response({
                'success': False,
                'message': 'No Media with the given id was found.'
            })

    # Users can contribute this data, so never cache it.
    @method_decorator(never_cache)
    def list(self, request):
        queryset = get_queryset_for_user(self, request)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)
