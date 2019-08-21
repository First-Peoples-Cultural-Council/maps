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
    """
    A 2nd language geom source, for sleeping langs
    """
    for rec in json.loads(open("./fixtures/old-langs.json").read())["features"]:

        with transaction.atomic():
            try:
                lang = Language.objects.get(name=rec["properties"]["Name"])
            except Language.DoesNotExist:
                print(
                    "failed to import language, none with name {}".format(
                        rec["properties"]["Name"]
                    )
                )
            poly = GEOSGeometry(json.dumps(rec["geometry"]))
            # hardcode some known sleeping lang names overwrite those.
            if (
                not lang.geom
                or lang.name == "Wetalh"
                or lang.name == "Nicola"
                or lang.name == "Pəntl’áč"
            ):
                print(lang, "being imported")
                lang.geom = poly[0]
                lang.sleeping = True
                lang.bbox = Polygon.from_bbox(lang.geom.extent)
                lang.color = "RGB(1,1,1)"
            lang.save()
