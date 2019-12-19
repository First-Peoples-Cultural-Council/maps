import sys

from django.shortcuts import render
from django.db.models import Q

from users.models import User, Administrator
from language.models import (
    Language,
    Community,
    CommunityMember,
    Champion,
    CommunityLanguageStats,
    Recording,
)

from django.views.decorators.cache import never_cache
from rest_framework import viewsets, generics, mixins, status
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from language.views import BaseModelViewSet

from language.serializers import (
    CommunitySerializer,
    CommunityDetailSerializer,
    CommunityMemberSerializer,
    CommunityGeoSerializer,
    ChampionSerializer,
    CommunityLanguageStatsSerializer,
)

from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from web.permissions import IsAdminOrReadOnly


class CommunityViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = CommunitySerializer
    detail_serializer_class = CommunityDetailSerializer
    queryset = Community.objects.all().order_by("name").exclude(point__isnull=True)

    def list(self, request):
        queryset = self.get_queryset()
        if "lang" in request.GET:
            queryset = queryset.filter(
                languages=Language.objects.get(pk=request.GET.get("lang"))
            )
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=["patch"])
    def add_audio(self, request, pk):
        if 'recording_id' not in request.data.keys():
            return Response({"message": "No Recording was sent in the request"})
        if not pk:
            return Response({"message": "No Community was sent in the request"})
        recording_id = int(request.data["recording_id"])
        community_id = int(pk)
        community = Community.objects.get(pk=community_id)
        recording = Recording.objects.get(pk=recording_id)
        community.audio = recording
        community.save()
        return Response({"message": "Audio associated"}, 
                        status=status.HTTP_200_OK)

    @action(detail=True, methods=["post"])
    def create_membership(self, request, pk):
        if 'user_id' not in request.data.keys():
            return Response({"message": "No User was sent in the request"})
        if not pk:
            return Response({"message": "No Community was sent in the request"})
        user_id = int(request.data["user_id"])
        community_id = int(pk)
        community = Community.objects.get(pk=community_id)
        user = User.objects.get(pk=user_id)
        user.communities.add(community)
        user.save()
        return Response({"message": "Membership created"})

    @method_decorator(never_cache)
    @action(detail=False)
    def list_member_to_verify(self, request):
        # 'VERIFIED' 'REJECTED' members do not need to the verified
        members = CommunityMember.objects.exclude(status__exact=CommunityMember.VERIFIED).exclude(status__exact=CommunityMember.REJECTED)        
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                # Getting the communities of the admin
                admin_communities = Administrator.objects.filter(user__id=int(request.user.id)).values('community')
                if admin_communities:                
                    # Filter members by user's communities 
                    members = members.filter(community__in=admin_communities)
                    serializer = CommunityMemberSerializer(members, many=True)                    
                    return Response(serializer.data)
        return Response([])

    @action(detail=False, methods=["patch"])
    def verify_member(self, request):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                user_id = int(request.data["user_id"])
                community_id = int(request.data["community_id"])
                if CommunityMember.member_exists(user_id, community_id):
                    member = CommunityMember.objects.filter(user__id=user_id).filter(
                        community__id=community_id
                    )
                    CommunityMember.verify_member(member[0].id)

                    return Response({"message": "Verified!"})
                else:
                    return Response({"message", "User is already a community member"})
        
        return Response({"message", "Only Administrators can verify community members"})

    @action(detail=False, methods=["patch"])
    def reject_member(self, request):
        if request and hasattr(request, "user"):
            if request.user.is_authenticated:
                if 'user_id' not in request.data.keys():
                    return Response({"message": "No User was sent in the request"})
                if 'community_id' not in request.data.keys():
                    return Response({"message": "No Community was sent in the request"})

                user_id = int(request.data["user_id"])
                community_id = int(request.data["community_id"])
                try:            
                    if CommunityMember.member_exists(user_id, community_id):
                        member = CommunityMember.objects.filter(user__id=user_id).filter(
                            community__id=community_id
                        )
                        CommunityMember.reject_member(member[0].id)

                        return Response({"message": "Rejected!"})
                    else:
                        return Response({"message", "Membership not found"})
                except User.DoesNotExist:
                    return Response({"message": "No User with the given id was found"})
                except Community.DoesNotExist:
                    return Response({"message": "No Community with the given id was found"})
        
        return Response({"message", "Only Administrators can reject community members"})


class CommunityLanguageStatsViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = CommunityLanguageStatsSerializer
    detail_serializer_class = CommunityLanguageStatsSerializer
    queryset = CommunityLanguageStats.objects.all()


class ChampionViewSet(BaseModelViewSet):
    permission_classes = [IsAdminOrReadOnly]

    serializer_class = ChampionSerializer
    detail_serializer_class = ChampionSerializer
    queryset = Champion.objects.all()


class CommunityGeoList(generics.ListAPIView):
    queryset = Community.objects.filter(point__isnull=False).order_by("name")
    serializer_class = CommunityGeoSerializer
