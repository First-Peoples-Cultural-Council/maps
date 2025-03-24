import os
import hashlib
import copy

from rest_framework import mixins
from rest_framework.views import APIView
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import status

from django.db import transaction
from django.views.decorators.cache import never_cache
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.db.models import Q
from django.contrib.auth import login, logout

from users.models import User, Administrator
from users.serializers import UserSerializer
from users.cognito import verify_token

from language.models import RelatedData
from language.serializers import PlaceNameLightSerializer


def validate_key(encoded_email, key):
    if not os.environ["INVITE_SALT"]:
        raise Exception("INVITE_SALT environment variable not set up.")

    invite_salt = os.environ["INVITE_SALT"].encode("utf-8")

    # Confirmation key used to check against submitted key
    confirmation_key = hashlib.sha256(invite_salt + encoded_email).hexdigest()

    # Value would be true if key and confirmation key are equal; false otherwise
    return key == confirmation_key


# To enable only UPDATE and RETRIEVE, we create a custom ViewSet class...
class UserCustomViewSet(
    mixins.UpdateModelMixin,
    mixins.RetrieveModelMixin,
    GenericViewSet,
):
    pass


class UserViewSet(UserCustomViewSet, GenericViewSet):
    serializer_class = UserSerializer
    queryset = User.objects.all().order_by("first_name")

    @method_decorator(never_cache)
    def retrieve(self, request, *args, **kwargs):
        """
        Retrieve a User object (only supports retrieving current user info).
        """
        if request and hasattr(request, "user"):
            # Safely attempt to get user_id from kwargs and convert to an integer
            user_id_str = kwargs.get("pk")

            try:
                # Attempt to convert 'pk' to an integer
                user_id = int(user_id_str)
            except (TypeError, ValueError):
                # If the conversion fails (e.g., 'undefined'), return a 400 Bad Request
                return Response(
                    {"message": f"Invalid user ID: {user_id_str}. It must be an integer."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Signed in but attempting to retrieve a different user
            if request.user.is_authenticated and request.user.id != user_id:
                return Response(
                    {"message": "You do not have access to this user's info."},
                    status=status.HTTP_403_FORBIDDEN,
                )

            if request.user.is_authenticated and request.user.id == user_id:
                return super().retrieve(request)

        return Response(
            {"message": "You are not authorized to view this info."},
            status=status.HTTP_401_UNAUTHORIZED,
        )

    @method_decorator(never_cache)
    def partial_update(self, request, *args, **kwargs):
        """
        Partially update User object
        """

        if request and hasattr(request, "user"):
            # Safely attempt to get user_id from kwargs and convert to an integer
            user_id_str = kwargs.get("pk")

            try:
                # Attempt to convert 'pk' to an integer
                user_id = int(user_id_str)
            except (TypeError, ValueError):
                # If the conversion fails (e.g., 'undefined'), return a 400 Bad Request
                return Response(
                    {"message": f"Invalid user ID: {user_id_str}. It must be an integer."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Signed in but attempting to patch a different user
            if request.user.is_authenticated and request.user.id != user_id:
                return Response(
                    {"message": "You do not have access to update this user's info."},
                    status=status.HTTP_403_FORBIDDEN,
                )

            if request.user.is_authenticated and request.user.id == user_id:
                return super().partial_update(request)

        return Response(
            {"message": "You are not authorized to update this user."},
            status=status.HTTP_401_UNAUTHORIZED,
        )

    @method_decorator(never_cache)
    @action(detail=False)
    def auth(self, request):
        """
        Retrieve authentication information.
        """

        if not request.user.is_authenticated:
            return Response({"is_authenticated": False})

        return Response(
            {
                "is_authenticated": True,
                "user": UserSerializer(request.user).data,
                "administration_list": Administrator.objects.filter(
                    user=request.user
                ).count(),
            }
        )

    @method_decorator(never_cache)
    @action(detail=False)
    def login(self, request):
        """
        Allow a user to log in by consuming a JWT from AWS Cognito
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
                    picture=result.get("picture", None),  # unused, default to None
                    first_name=result["given_name"],
                    last_name=result["family_name"],
                )
                user.save()
                is_new = True

            login(request, user)
            return Response(
                {"success": True, "email": user.email, "id": user.id, "new": is_new}
            )

        return Response({"success": False})

    @action(detail=False)
    def logout(self, request):
        """
        Log the current User out and invalidates the JWT in Cognito
        """
        # TODO: invalidate the JWT on cognito
        logout(request)
        return Response({"success": True})


class ConfirmClaimView(APIView):
    def get(self, request):
        """
        Get all Artist profiles to be claimed, based on the invite link.
        """

        data = request.GET

        if "email" in data and "key" in data:
            email = data.get("email")
            encoded_email = data.get("email").encode("utf-8")
            key = data.get("key")

            is_valid = validate_key(encoded_email, key)

            if is_valid:
                email_data = RelatedData.objects.exclude(
                    (Q(value="") | Q(placename__kind__in=["resource", "grant"]))
                ).filter(
                    (Q(data_type="email") | Q(data_type="user_email")),
                    placename__creator__isnull=True,
                    value=email,
                )
                email_data_copy = copy.deepcopy(email_data)

                # Exclude data if there is an actual_email. Used to give notif to
                # the actual email rather than the FPCC admin who seeded the profile
                for data in email_data:
                    if data.data_type == "user_email":
                        actual_email = RelatedData.objects.exclude(value="").filter(
                            placename=data.placename, data_type="email"
                        )

                        if actual_email:
                            email_data_copy = email_data_copy.exclude(id=data.id)

                email_data = email_data_copy

                if email_data.count() == 0:
                    return Response(
                        {"message": "No profiles to claim"},
                        status=status.HTTP_404_NOT_FOUND,
                    )

                places = []
                for data in email_data:
                    serializer = PlaceNameLightSerializer(data.placename)
                    places.append(serializer.data)

                return Response({"places": places})

        return Response(
            {"message": "Invalid claim request."}, status=status.HTTP_400_BAD_REQUEST
        )

    @method_decorator(never_cache, login_required)
    def post(self, request):
        """
        Confirm Artist profiles claim action, and sets the current user as the creator for said profiles.
        """

        data = request.data

        if "email" in data and "key" in data and "user_id" in data:
            # Actual Post Data
            user_id = data.get("user_id")
            email = data.get("email")
            encoded_email = data.get("email").encode("utf-8")
            key = data.get("key")

            is_valid = validate_key(encoded_email, key)
            if is_valid:
                user = User.objects.get(id=user_id)

                with transaction.atomic():
                    email_data = RelatedData.objects.exclude(
                        (Q(value="") | Q(placename__kind__in=["resource", "grant"]))
                    ).filter(
                        (Q(data_type="email") | Q(data_type="user_email")),
                        placename__creator__isnull=True,
                        value=email,
                    )
                    email_data_copy = copy.deepcopy(email_data)

                    # Exclude data if there is an actual_email. Used to give notif to
                    # the actual email rather than the FPCC admin who seeded the profile
                    for data in email_data:
                        if data.data_type == "user_email":
                            actual_email = RelatedData.objects.exclude(value="").filter(
                                placename=data.placename, data_type="email"
                            )

                            if actual_email:
                                email_data_copy = email_data_copy.exclude(id=data.id)

                    email_data = email_data_copy

                    if email_data.count() == 0:
                        return Response(
                            {"message": "No profiles to claim"},
                            status=status.HTTP_404_NOT_FOUND,
                        )

                    for data in email_data:
                        profile = data.placename

                        if not profile.creator:
                            profile.creator = user
                            profile.save()

                    return Response(
                        {"message": "You have successfully claimed your profile(s)!"}
                    )

        return Response(
            {"message": "Invalid claim request."}, status=status.HTTP_400_BAD_REQUEST
        )


class ValidateInviteView(APIView):
    def post(self, request):
        """
        Validates the key in the invitation link sent to artists.
        """

        data = request.data

        if "email" in data and "key" in data:
            # Actual Post Data
            encoded_email = data.get("email").encode("utf-8")
            key = data.get("key")

            is_valid = validate_key(encoded_email, key)

            return Response({"valid": is_valid})

        return Response({"valid": False})
