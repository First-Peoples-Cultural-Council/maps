
def is_user_permitted(request, pk_to_compare):
    """
    Check if a user is permitted to perform an operation
    """
    if request and hasattr(request, "user"):
        if request.user.is_authenticated and request.user.id == int(pk_to_compare):
            return True
    
    return False