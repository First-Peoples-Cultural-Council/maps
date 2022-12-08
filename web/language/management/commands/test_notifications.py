from datetime import timedelta

from django.core.management.base import BaseCommand
from django.utils import timezone
from language.notifications import notify
from users.models import User



class Command(BaseCommand):
    def handle(self, *args, **options):
        print(args, options)
        test_notifications(options["email"], options["days"])

    def add_arguments(self, parser):
        parser.add_argument("--email", nargs="+")
        parser.add_argument("--days", nargs="+", type=int)


def test_notifications(emails, days):
    for email in emails:
        user = User.objects.get(email=email)
        notify(user, timezone.now() - timedelta(days=days[0]))
