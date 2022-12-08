from django.core.management.base import BaseCommand
from language.models import PlaceName


class Command(BaseCommand):
    help = 'Loads placenames from the csv in '

    def handle(self, *args, **options):
        get_placenames()


def get_placenames():
    placenames = PlaceName.objects.all()

    print("Name,Kind")
    for placename in placenames:
        if not placename.kind or placename.kind == 'poi':
            placename.kind = 'Point Of Interest'
        else:
            placename.kind = placename.kind.replace('_', ' ').title()

        print("\"{}\",\"{}\"".format(placename.name, placename.kind))
