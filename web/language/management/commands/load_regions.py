import json

from django.core.management.base import BaseCommand
from language.models import Language
from django.contrib.gis.geos import GEOSGeometry, Polygon


class Command(BaseCommand):
    help = 'Loads geometry into languages (pre-existing in db)'

    def handle(self, *args, **options):

        for rec in json.loads(open('./fixtures/langs.json').read())['features']:
            lang = Language.objects.get(name=rec['properties']['title'])
            print(rec['properties']['title'], 'geom being loaded.')
            lang.geom = GEOSGeometry(json.dumps(rec['geometry']))
            lang.bbox = Polygon.from_bbox(lang.geom.extent)
            lang.color = rec['properties']['color'].replace(' ', '')
            lang.save()
