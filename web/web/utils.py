from users.models import Administrator

def is_user_permitted(request, pk_to_compare):
    """
    Check if a user is permitted to perform an operation
    """
    if request and hasattr(request, "user"):
        if request.user.is_authenticated and request.user.id == int(pk_to_compare):
            return True
    
    return False

def is_user_community_admin(request, community):
    community_admins = list(Administrator.objects.filter(community=community).values_list('user', flat=True))
    
    if request and hasattr(request, "user"):
        if request.user.is_staff or request.user.id in community_admins:
            return True
    
    return False