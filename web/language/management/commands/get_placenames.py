from django.core.management.base import BaseCommand, CommandError
from language.models import PlaceName

import csv
import re

class Command(BaseCommand):
    help = 'Loads categories from the csv in '

    def handle(self, *args, **options):
        get_placenames()

# Fetch all placenames and print as CSV
def get_placenames():
    placenames = PlaceName.objects.all()

    print("Name,Kind")
    for placename in placenames:
        if not placename.kind or placename.kind == 'poi':
            placename.kind = 'Point Of Interest'
        else:
            placename.kind = placename.kind.replace('_', ' ').title()


        print("\"{}\",\"{}\"".format(placename.name, placename.kind))

