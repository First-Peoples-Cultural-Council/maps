import os
import requests

from django.core.management.base import BaseCommand
from django.contrib.gis.geos import Point

from grants.models import Grant


class Command(BaseCommand):
    help = "Load grants from old arts database."
    def add_arguments(self, parser):
        parser.add_argument("--starting_id", type=int)
        parser.add_argument("--GOOGLE_API_KEY", type=str)

    def handle(self, *args, **options):
        starting_id = options["starting_id"]
        google_api_key = options["GOOGLE_API_KEY"]
        geocode_grants(starting_id, google_api_key)


def geocode_grants(starting_id, google_api_key):
    grants = Grant.objects.filter(id__gte=starting_id).order_by("id")

    if not google_api_key:
        return print('NO GOOGLE API KEY')

    for grant in grants:
        full_address = []
        
        if grant.address:
            full_address.append(grant.address)
        if grant.city:
            full_address.append(grant.city)
        if grant.province:
            full_address.append(grant.province)
        if grant.postal_code:
            full_address.append(grant.postal_code)
        
        full_address_string = ', '.join(full_address).replace('#', '').replace('&', ' ')

        r = requests.get(f"https://maps.googleapis.com/maps/api/geocode/json?address={full_address_string}&sensor=false&key={google_api_key}")
        
        data = r.json()
        response_status = data.get("status")
        results = data.get("results")
        if response_status == "OK" and results:
            first_result = results[0]
            
            location = first_result.get("geometry").get("location")
            if location is not None and \
                location.get("lat") and \
                location.get("lng"):
                point = Point(
                    float(location.get("lng")),
                    float(location.get("lat"))
                )
                print(f'SAVING POINT -- {full_address_string}')
                grant.point = point
            else:
                print(f'--REMOVING POINT -- {full_address_string}')
                grant.point = None
        else:
            print(f'--REMOVING POINT -- {full_address_string}')
            grant.point = None

        grant.save()
