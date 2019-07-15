import pymysql
from django.core.management.base import BaseCommand, CommandError
from language.models import Language, Community

import os
import sys
import json


class Client:
    def update(self):
        db = pymysql.connect(
            os.environ['ARTSMAP_HOST'],
            os.environ['ARTSMAP_USER'],
            os.environ['ARTSMAP_PW'],
            os.environ['ARTSMAP_DB'])

        # prepare a cursor object using cursor() method
        cursor = db.cursor()

        # Prepare SQL query to INSERT a record into the database.
        # sql = "SELECT * FROM node \
        #     WHERE type = 'art'"
        # sql = "show tables;"
        sql = """
        select distinct node.type, node.title, location.latitude, location.longitude, node.nid
        from node inner join location_instance on node.nid=location_instance.nid
            inner join location on location.lid=location_instance.lid
        where node.type = 'art' or node.type = 'event' or node.type = 'profile' or node.type = 'org';
        """
        # Execute the SQL command
        cursor.execute(sql)
        # Fetch all the rows in a list of lists.
        results = cursor.fetchall()

        geojson = {
            "type": "FeatureCollection",
            "features": [

            ]
        }

        for row in results:
            if float(row[2]) and float(row[3]):  # only want spatial data.
                geojson['features'].append({
                    "type": "Feature",
                    "properties": {
                        'type': row[0],
                        'title': row[1],
                        'node_id': row[4],
                    },
                    "geometry": {
                        "type": "Point",
                        "coordinates": [
                                float(row[3]),
                                float(row[2]),
                        ]
                    }
                })
        return geojson


class Command(BaseCommand):
    help = 'Closes the specified poll for voting'

    def handle(self, *args, **options):

        open('tmp/arts.json', 'w').write(json.dumps(Client().update()))
