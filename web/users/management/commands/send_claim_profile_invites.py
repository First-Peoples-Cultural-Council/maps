from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Send out emails to registered users to claim their artist profiles."

    def handle(self, *args, **options):
        send_notifications()


def send_notifications():
    print('SENDING NOTIFICATIONS')
