from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from language.models import Language
from django.contrib.gis.geos import MultiPolygon, Polygon, fromstr, GEOSGeometry

import os
import sys
import json


class Command(BaseCommand):
    help = "Loads arts from fixtures/arts.json."

    def handle(self, *args, **options):

        load_sleeping()


def load_sleeping():

    for rec in json.loads(open("./fixtures/old-langs.json").read())["features"]:

        with transaction.atomic():

            lang = Language.objects.get(name=rec["properties"]["Name"])
            poly = GEOSGeometry(json.dumps(rec["geometry"]))
            print(poly)
            lang.geom = poly[0]
            print(lang)
            # lang.save()
