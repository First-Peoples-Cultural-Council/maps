from django.core.management.base import BaseCommand, CommandError
from language.models import Art
from django.contrib.gis.geos import Point

import os
import sys
import json


class Command(BaseCommand):
    help = 'Loads arts from fixtures/arts.json.'

    def handle(self, *args, **options):

        load_arts()

def load_arts():

    # Removing every Art object from the database.
    # We are loading everything from the scratch
    arts = Art.objects.all()
    arts.delete()

    for rec in json.loads(open('./fixtures/arts.json').read())['features']:

        art = Art()
        
        # Geometry map point with latitude and longitude
        art.point = Point(float(rec['geometry']['coordinates'][0]), # latitude
                            float(rec['geometry']['coordinates'][1])) # longitude
        art.art_type = rec['properties']['type']
        art.title = rec['properties']['title']
        art.node_id = rec['properties']['node_id']
        
        art.save()
