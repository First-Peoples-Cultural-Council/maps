from django.core.management.base import BaseCommand, CommandError
from language.models import PlaceName
from django.contrib.gis.geos import Point

import os
import sys
import json


class Command(BaseCommand):
    help = 'Closes the specified poll for voting'

    def handle(self, *args, **options):

        for rec in json.loads(open('./fixtures/pois.json').read())['markers']['marker']:
            n=PlaceName(
                point=Point(rec['_loc_y'],rec['_loc_x']),
                name=rec['_name'],
                kind='poi'
            )
            n.save()
