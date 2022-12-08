from django.db.models import Q
from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def handle(self, *args, **options):
        dry_run = options.get('dry_run') == 1
        verify_fpcc_points(dry_run)

    def add_arguments(self, parser):
        parser.add_argument('--dry_run', type=int)


def verify_fpcc_points(dry_run):
    print(f'DRY RUN: {dry_run}')
    fpcc_admin = get_user_model().objects.filter(
        Q(is_staff=True) | Q(is_superuser=True)
    )

    for admin in fpcc_admin:
        print(admin)
        print('\nPLACENAMES')

        owned_placenames = admin.placename_set.exclude(status='VE')
        for placename in owned_placenames:
            if not dry_run:
                placename.status = 'VE'
                placename.save()
                print(
                    f'UPDATED - {placename.kind} - {placename} - {placename.status}')
            else:
                print(f'{placename.kind} - {placename} - {placename.status}')

        print('\nMEDIA')

        owned_media = admin.media_set.exclude(status='VE')
        for media in owned_media:

            if not dry_run:
                media.status = 'VE'
                media.save()
                print(f'UPDATED - {media} - {media.status}')
            else:
                print(f'{media} - {media.status}')

        print('\n------------------------\n')
