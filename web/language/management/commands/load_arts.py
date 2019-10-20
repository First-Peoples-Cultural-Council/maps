from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from arts.models import Art
from django.contrib.gis.geos import Point

import os
import sys
import json


class Command(BaseCommand):
    help = "Loads arts from fixtures/arts.json."

    def handle(self, *args, **options):

        load_arts()


def load_arts():

    # Removing every Art object from the database.
    # We are loading everything from the scratch
    arts = Art.objects.all()
    arts.delete()

    error_log = []

    for rec in json.loads(open("./web/static/web/arts1.json").read())["features"]:

        # try:
        with transaction.atomic():
            # avoid duplicates on remote data source.
            try:
                art = Art.objects.get(name=rec["properties"]["name"])
            except Art.DoesNotExist:
                art = Art(name=rec["properties"]["name"])

            # Geometry map point with latitude and longitude
            art.point = Point(
                float(rec["geometry"]["coordinates"][0]),  # latitude
                float(rec["geometry"]["coordinates"][1]),
            )  # longitude
            art.art_type = rec["properties"]["type"]
            art.details = rec["properties"]["details"]
            art.node_id = rec["properties"]["node_id"]

            art.save()

    # except Exception as e:
    #     error_log.append(
    #         "Node Id "
    #         + str(rec["properties"]["node_id"])
    #         + ", unexpected error: "
    #         + str(e)
    #     )

    if len(error_log) > 0:
        for error in error_log:
            print(error)
    else:
        print("Arts imported!")
