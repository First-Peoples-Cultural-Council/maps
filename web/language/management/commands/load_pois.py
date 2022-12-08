import json

from django.core.management.base import BaseCommand
from django.contrib.gis.geos import Point
from language.models import PlaceName


class Command(BaseCommand):
    help = 'Loads points of interest, from legacy custom json format out of drupal site.'

    def handle(self, *args, **options):

        for rec in json.loads(open('./fixtures/pois.json').read())['markers']['marker']:
            n = PlaceName(
                point=Point(float(rec['_loc_x']), float(rec['_loc_y'])),
                name=rec['_name'],
                kind='poi'
            )
            n.save()
