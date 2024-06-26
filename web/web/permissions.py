from rest_framework.permissions import BasePermission, SAFE_METHODS

from users.models import Administrator


class IsAdminOrReadOnly(BasePermission):
    """
    The request is authenticated as a user, or is a read-only request.
    """

    def has_permission(self, request, view):
        return bool(
            request.method in SAFE_METHODS or request.user and request.user.is_staff
        )


class IsLanguageAdminOrReadOnly(BasePermission):
    """
    The request is authenticated as a user, or is a read-only request.
    """

    def has_permission(self, request, view):
        return bool(
            request.method in SAFE_METHODS or request.user and request.user.is_staff
        )


class IsCommunityMemberOrReadOnly(BasePermission):
    """
    The request is authenticated as a user, or is a read-only request.
    """

    def has_permission(self, request, view):
        return bool(
            request.method in SAFE_METHODS or request.user and request.user.is_staff
        )


class IsAuthenticatedUserOrReadOnly(BasePermission):
    """
    The request is authenticated as a user, or is a read-only request.
    """

    def has_permission(self, request, view):
        return bool(request.method in SAFE_METHODS or request.user)


def is_user_permitted(request, pk_to_compare):
    """
    Check if a user is permitted to perform an operation
    """
    if request and hasattr(request, "user"):
        if request.user.is_authenticated and request.user.id == int(pk_to_compare):
            return True

    return False


def is_user_community_admin(request, community):
    community_admins = list(
        Administrator.objects.filter(community=community).values_list("user", flat=True)
    )

    if request and hasattr(request, "user"):
        if request.user.is_staff or request.user.id in community_admins:
            return True

    return False
