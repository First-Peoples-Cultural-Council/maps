from django.views.decorators.cache import never_cache
from django.utils.decorators import method_decorator
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import action
from django_filters.rest_framework import DjangoFilterBackend

from users.models import User, Administrator
from language.models import (
    Language,
    Community,
    CommunityMember,
    Champion,
    CommunityLanguageStats,
    Recording,
)
from language.views import BaseModelViewSet
from language.serializers import (
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityMemberSerializer,
    CommunityGeoSerializer,
    ChampionSerializer,
    CommunityLanguageStatsSerializer,
    CommunitySearchSerializer
)
from web.permissions import IsAdminOrReadOnly
from web.utils import is_user_community_admin
from web.constants import *


class CommunityViewSet(BaseModelViewSet):
    serializer_class = CommunitySerializer
    detail_serializer_class = CommunityDetailSerializer
    queryset = Community.objects.all().order_by('name').exclude(point__isnull=True)

    def list(self, request):
        queryset = self.get_queryset()
        if 'lang' in request.GET:
            queryset = queryset.filter(
                languages=Language.objects.get(pk=request.GET.get('lang'))
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

    @method_decorator(never_cache)
    def detail(self, request):
        return super().detail(request)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        if is_user_community_admin(request, instance):
            return super().update(request, *args, **kwargs)

        return Response(
            {'message': 'You are not authorized to perform this action.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if is_user_community_admin(request, instance):
            return super().update(request, *args, **kwargs)

        return Response(
            {'message': 'You are not authorized to perform this action.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

    @method_decorator(never_cache)
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = CommunityDetailSerializer(instance)
        serialized_data = serializer.data

        user_logged_in = False
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                user_logged_in = True

        if not user_logged_in:
            serialized_data['places'] = [
                place for place in serialized_data['places'] if not place['community_only']]
        else:
            user_communities = CommunityMember.objects.filter(
                user=request.user.id).values_list('community', flat=True)

            # Update list of places - exclude community_only if necessary
            updated_places = []
            for place in serialized_data['places']:
                if place['community_only'] and instance.id in user_communities:
                    # Append if the user is a member of this community
                    updated_places.append(place)
                elif not place['community_only']:
                    # Append if available to the public
                    updated_places.append(place)
            serialized_data['places'] = updated_places

            # Update list of medias - exclude community_only if necessary
            updated_medias = []
            for media in serialized_data['medias']:
                if media['community_only'] and instance.id in user_communities:
                    # Append if the user is a member of this community
                    updated_medias.append(media)
                elif not media['community_only']:
                    # Append if available to the public
                    updated_medias.append(media)
            serialized_data['medias'] = updated_medias
        return Response(serialized_data)

    @action(detail=True, methods=['patch'])
    def add_audio(self, request, pk):
        instance = self.get_object()
        if is_user_community_admin(request, instance):
            if 'recording_id' not in request.data.keys():
                return Response(
                    {'message': 'No Recording was sent in the request'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            if not pk:
                return Response(
                    {'message': 'No Community was sent in the request'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            recording_id = int(request.data['recording_id'])
            community_id = int(pk)
            community = Community.objects.get(pk=community_id)
            recording = Recording.objects.get(pk=recording_id)
            community.audio = recording
            community.save()
            return Response(
                {'message': 'Audio associated'},
                status=status.HTTP_200_OK
            )

        return Response(
            {'message': 'You are not authorized to perform this action.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

    @action(detail=True, methods=['post'])
    def create_membership(self, request, pk):
        instance = self.get_object()
        if is_user_community_admin(request, instance):
            if 'user_id' not in request.data.keys():
                return Response(
                    {'message': 'No User was sent in the request'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            if not pk:
                return Response(
                    {'message': 'No Community was sent in the request'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            user_id = int(request.data['user_id'])
            community_id = int(pk)
            community = Community.objects.get(pk=community_id)
            user = User.objects.get(pk=user_id)
            user.communities.add(community)
            user.save()
            return Response(
                {'message': 'Membership created'},
                status=status.HTTP_200_OK
            )

        return Response(
            {'message': 'You are not authorized to perform this action.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

    @method_decorator(never_cache)
    @action(detail=False)
    def list_member_to_verify(self, request):
        # 'VERIFIED' or 'REJECTED' members do not need to the verified
        members = CommunityMember.objects.exclude(
            status__exact=VERIFIED).exclude(status__exact=REJECTED)
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                # Getting the communities of the admin
                admin_communities = Administrator.objects.filter(
                    user__id=int(request.user.id)).values('community')
                if admin_communities:
                    # Filter members by user's communities
                    members = members.filter(community__in=admin_communities)
                    serializer = CommunityMemberSerializer(members, many=True)
                    return Response(serializer.data)
        return Response([])

    @action(detail=False, methods=['post'])
    def verify_member(self, request):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                user_id = int(request.data['user_id'])
                community_id = request.data['community_id']

                # Check if the current user is an admin for this community
                admin_communities = list(Administrator.objects.filter(
                    user=request.user.id).values_list('community', flat=True))

                if community_id in admin_communities:
                    if CommunityMember.member_exists(user_id, community_id):
                        member = CommunityMember.objects.filter(user__id=user_id).filter(
                            community__id=community_id
                        )
                        CommunityMember.verify_member(member[0].id)

                        return Response({'message': 'Verified!'})
                    else:
                        return Response({'message', 'User is already a community member'})
                else:
                    return Response({'message', 'Only Administrators can verify community members'})

        return Response({'message', 'You need to be logged in to verify community members'})

    @action(detail=False, methods=['post'])
    def reject_member(self, request):
        if request and hasattr(request, 'user'):
            if request.user.is_authenticated:
                if 'user_id' not in request.data.keys():
                    return Response({'message': 'No User was sent in the request'})
                if 'community_id' not in request.data.keys():
                    return Response({'message': 'No Community was sent in the request'})

                user_id = int(request.data['user_id'])
                community_id = int(request.data['community_id'])

                # Check if the current user is an admin for this community
                admin_communities = list(Administrator.objects.filter(
                    user=request.user.id).values_list('community', flat=True))

                if community_id in admin_communities:
                    try:
                        if CommunityMember.member_exists(user_id, community_id):
                            member = CommunityMember.objects.filter(user__id=user_id).filter(
                                community__id=community_id
                            )
                            CommunityMember.reject_member(member[0].id)

                            return Response({'message': 'Rejected!'})
                        else:
                            return Response({'message', 'Membership not found'})
                    except User.DoesNotExist:
                        return Response({'message': 'No User with the given id was found'})
                else:
                    return Response({'message', 'Only Administrators can reject community members'})

        return Response({'message', 'You need to be logged in to reject community members'})


class CommunityLanguageStatsViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = CommunityLanguageStatsSerializer
    detail_serializer_class = CommunityLanguageStatsSerializer
    queryset = CommunityLanguageStats.objects.all()

    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['community', 'language', ]


class ChampionViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = ChampionSerializer
    detail_serializer_class = ChampionSerializer
    queryset = Champion.objects.all()


# Geo List APIViews
class CommunityGeoList(generics.ListAPIView):
    queryset = Community.objects.filter(point__isnull=False).only(
        'name', 'other_names', 'point').order_by('name')
    serializer_class = CommunityGeoSerializer

    def get_queryset(self):
        language_query = self.request.GET.get('language')

        if language_query:
            language = Language.objects.get(name=language_query)
            return Community.objects.filter(languages=language.id)
        else:
            return super().get_queryset()


# Search List APIViews
class CommunitySearchList(generics.ListAPIView):
    queryset = Community.objects.filter(
        point__isnull=False).only('name').order_by('name')
    serializer_class = CommunitySearchSerializer
