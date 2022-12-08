from django.conf import settings
from django.core.management.base import BaseCommand
from django.utils import timezone

from users.models import User
from language.notifications import send_apology_letter


class Command(BaseCommand):
    def handle(self, *args, **options):
        send_apology_letters(options["email"])

    def add_arguments(self, parser):
        parser.add_argument("--email", type=str)


def send_apology_letters(email=None):
    now = timezone.now()
    users = User.objects.filter(
        # TODO: allow arbitrary notification frequency from account setting instead of hardcoding 30 here?
        notification_frequency__gt=-1,
    )
    print('TRIGGERED send_apology_letters')

    if email:
        user = users.filter(email=email).first()
        if user:
            print('SENDING TO SPECIFIC EMAIL')
            send_apology_letter(user)
    else:
        for user in users:
            if user.email:
                print(f'SENDING TO USER: {user.email}')
                user_is_admin = user.email in [a[1] for a in settings.ADMINS] or user.email in [
                    a[1] for a in settings.FPCC_ADMINS]

                if not user_is_admin:
                    send_apology_letter(user)

                user.last_notified = now
                user.save()
