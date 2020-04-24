from django.core.management.base import BaseCommand
from users.notifications import send_claim_profile_invites


class Command(BaseCommand):
    help = "Send out emails to registered users to claim their artist profiles."

    def handle(self, *args, **options):
        send_claim_profile_invites()
