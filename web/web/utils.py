import re

from django.conf import settings

from users.models import Administrator, User


def format_fpcc(s):

    s = s.strip().lower()
    s = re.sub(
        r"\\|\/|>|<|\?|\)|\(|~|!|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|'|\"",
        "",
        s,
    )
    s = re.sub(r"\s+", "-", s)
    return s


def get_lang_link(l):
    return '<a href="{}/languages/{}">{}</a>'.format(
        settings.HOST, format_fpcc(l.name), l.name
    )


def get_comm_link(c):
    return '<a href="{}/content/{}">{}</a>'.format(
        settings.HOST, format_fpcc(c.name), c.name
    )


def get_place_link(p):
    return '<a href="{}/place-names/{}">{}</a>'.format(
        settings.HOST, format_fpcc(p.name), p.name
    )


def get_art_link(p):
    return '<a href="{}/art/{}">{}</a>'.format(
        settings.HOST, format_fpcc(p.name), p.name
    )


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

def get_admin_email_list():
    # Return Test Email if in DEBUG mode [TODO: Make configurable in the future]
    if settings.DEBUG:
        return ['justin@countable.ca']

    # FPCC ADMINS that are registered in the site and are also assigned a superuser status
    registered_admins = list(User.objects.filter(
        is_superuser=True,
        email__isnull=False,
    ).exclude(email='').values_list('email', flat=True) or [])

    # FPCC ADMINS that don't necessarily need to be registered but are required to be notified
    fpcc_admins = [j[1] for j in settings.FPCC_ADMINS]

    # DEVELOPERS who should receive system logs
    dev_admins = [i[1] for i in settings.ADMINS]

    # Remove duplicates from the Admin List
    admin_list_with_dupes = registered_admins + dev_admins + fpcc_admins
    admin_list = list(set(admin_list_with_dupes))

    # If the designated SERVER_EMAIL is in the list, remove it
    if settings.SERVER_EMAIL in admin_list:
        admin_list = admin_list.remove(settings.SERVER_EMAIL)

    return admin_list