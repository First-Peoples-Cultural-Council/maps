
from django.core.management.base import BaseCommand, CommandError
from language.models import Language
from django.contrib.gis.geos import GEOSGeometry, Polygon

import os
import sys
import json


class Command(BaseCommand):
    help = 'Loads geometry into languages (pre-existing in db)'
    
    def handle(self, *args, **options):

        for rec in json.loads(open('./fixtures/langs.json').read())['features']:
            lang = Language.objects.get(name=rec['properties']['title'])
            print(rec['properties']['title'], 'geom being loaded.')
            lang.geom = GEOSGeometry(json.dumps(rec['geometry']))
            lang.bbox = Polygon.from_bbox(lang.geom.extent)
            lang.color = rec['properties']['color'].replace(' ','')
            lang.save()
