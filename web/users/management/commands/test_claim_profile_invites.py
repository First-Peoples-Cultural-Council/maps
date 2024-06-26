from django.core.management.base import BaseCommand
from users.notifications import send_claim_profile_invites


class Command(BaseCommand):
    help = "Test sending out emails to registered users to claim their artist profiles."

    def handle(self, *args, **options):
        if options["email"]:
            send_claim_profile_invites((options["email"][0]))

    def add_arguments(self, parser):
        parser.add_argument("--email", nargs="+")
