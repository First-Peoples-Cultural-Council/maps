from django.conf import settings
from django.db import transaction
from django.shortcuts import render

from rest_framework import viewsets, generics, mixins
from rest_framework.views import APIView
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action

from django.views.decorators.cache import never_cache
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.db.models import Q
from django.contrib.auth import login, logout

from .models import User, Administrator, ArtistProfileClaimRecord
from .notifications import _format_fpcc, claim_profile
from .serializers import UserSerializer
from .cognito import verify_token

from language.models import PlaceName, RelatedData


# To enable only UPDATE and RETRIEVE, we create a custom ViewSet class...
class UserCustomViewSet(
    mixins.UpdateModelMixin,
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    GenericViewSet,
):
    pass


class UserViewSet(UserCustomViewSet, GenericViewSet):
    serializer_class = UserSerializer
    queryset = User.objects.all().order_by("first_name")

    @method_decorator(never_cache)
    def detail(self, request):
        return super().detail(request)

    @method_decorator(never_cache)
    @action(detail=False)
    def login(self, request):
        """
        This API expects a JWT from AWS Cognito, which it uses to authenticate our user
        """
        id_token = request.GET.get("id_token")
        result = verify_token(id_token)
        if "email" in result:
            try:
                user = User.objects.get(email=result["email"].strip())
                is_new = False
            except User.DoesNotExist:
                user = User(
                    email=result["email"].strip(),
                    username=result["email"].replace("@", "__"),
                    password="",
                    picture=result['picture'],
                    first_name=result['given_name'],
                    last_name=result['family_name']
                )
                user.save()
                is_new = True
            login(request, user)
            return Response(
                {"success": True, "email": user.email, "id": user.id, "new": is_new}
            )
        else:
            return Response({"success": False})

    @method_decorator(never_cache)
    @action(detail=False)
    def auth(self, request):
        context = {}
        if request.user.is_authenticated:
            return Response(
                {
                    "is_authenticated": True,
                    "user": UserSerializer(request.user).data,
                    "administration_list": Administrator.objects.filter(
                        user=request.user
                    ).count(),
                }
            )
        else:
            return Response({"is_authenticated": False})

    @action(detail=False)
    def logout(self, request):
        # TODO: invalidate the JWT on cognito ?
        logout(request)
        return Response({"success": True})

    @action(detail=False)
    def search(self, request):
        users_results = []
        params = request.GET.get("search_params")

        if params:
            qs = User.objects.filter(
                Q(first_name__icontains=params)
                | Q(last_name__icontains=params)
                | Q(email__icontains=params)
            )

            users_results = [
                {
                    "id": user.id,
                    "first_name": user.first_name,
                    "last_name": user.last_name,
                    "email": user.email,
                }
                for user in qs
            ]

        return Response(users_results)


class ConfirmClaimView(APIView):
    @method_decorator(never_cache)
    def get(self, request, email, key):
        # If record exists set is_claimed to true and assign user to placename
        try:
            record = ArtistProfileClaimRecord.objects.get(artist_profile_email=email)

            with transaction.atomic():
                print(record.is_claimed)
                if not record.is_claimed:
                    # Update Artist Profile's owner
                    user = User.objects.get(email=record.user_email)

                    artist_profile = record.profile
                    artist_profile.owner = user
                    artist_profile.save()


                    # Update and Save record
                    record.is_claimed = True
                    record.save()

                    return Response({
                        'success': True,
                        'message': 'You have successfully claimed your profile!',
                        'profile': '{}/art/{}'.format(settings.HOST, _format_fpcc(record.profile.name))
                    })
                else:
                    return Response({
                        'success': False,
                        'message': 'This profile was already claimed.',
                    })
        except ArtistProfileClaimRecord.DoesNotExist:
            return Response({
                'success': False,
                'message': 'This profile claiming link is invalid.'
            })
        except Exception as e:
            return Response({
                'success': False,
                'message': str(e)
            })


class ClaimArtistProfileView(APIView):
    @method_decorator(login_required)
    def post(self, request):
        data = request.data

        # Login required would make sure this works
        user = request.user

        if 'placename' in data:
            placename_id = data.get('placename')
            placename = PlaceName.objects.get(id=placename_id)

            if placename.owner is None:
                email_data = RelatedData.objects.get(data_type='email', placename=placename)

                claim_profile(user.email, email_data)
                return Response({
                    'success': True,
                    'message': 'Claim request has been sent to %s' % email_data.value
                })
            else:
                return Response({
                    'success': False,
                    'message': 'This profile has already been claimed'
                })
        else:
            return Response({
                'success': False,
                'message': 'Invalid request.'
            })