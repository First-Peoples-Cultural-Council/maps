import os
import json
import pymysql
import requests
import glob
import shutil

from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import transaction
from django.contrib.gis.geos import Point
from language.models import PlaceName, Media, PublicArtArtist, Taxonomy, PlaceNameTaxonomy, RelatedData

from web import dedruplify


class Command(BaseCommand):
    help = "Loads arts from fixtures/arts.json."

    def handle(self, *args, **options):
        sync_arts()


def sync_arts():

    c = Client(
        os.environ["ARTSMAP_HOST"],
        os.environ["ARTSMAP_USER"],
        os.environ["ARTSMAP_PW"],
        os.environ["ARTSMAP_DB"],
    )
    c.update()
    c.load_arts()
    c.load_taxonomies()


TYPE_MAP = {
    "art": "public_art",
    "org": "organization",
    "per": "artist",
    "event": "event",
    "resource": "resource",
    "grant": "grant"
}

# Set this to TRUE if you want to re-download media
download_media = False

NODES_WITH_ARTWORK = ["public_art", "artist"]


class Client(dedruplify.DeDruplifierClient):

    def load_arts(self):
        # SETUP FOR SAVING MEDIA
        # Files url - source from which to download media files
        files_url = "https://www.fp-artsmap.ca/sites/default/files/"

        # Delete art artists
        art_artists = PublicArtArtist.objects.all()
        art_artists.delete()

        # Set artsmap path - directory for media files downloaded from fp-artsmap.ca
        artsmap_path = "{}{}{}".format(
            settings.BASE_DIR, settings.MEDIA_URL, "fp-artsmap")

        if download_media:
            # Delete fp-artsmap directory contents if it exists
            if os.path.exists(artsmap_path):
                files = glob.glob("{}/*".format(artsmap_path))
                for f in files:
                    if os.path.isfile(f):
                        os.remove(f)
                    elif os.path.isdir(f):
                        shutil.rmtree(f)

            # Create fp-artsmap directory
            if not os.path.exists(artsmap_path):
                os.mkdir(artsmap_path)

        # SETUP FOR SAVING PLACENAMES
        node_placenames_geojson = self.nodes_to_geojson()

        node_types = ["public_art", "artist",
                      "organization", "event", "resource", "grant"]

        # Removing every Node PlaceName object from the database.
        node_placenames = PlaceName.objects.filter(kind__in=node_types)
        node_placenames.delete()

        # Remove all related_data
        existing_related_data = RelatedData.objects.all()
        existing_related_data.delete()

        error_log = []

        print('----------CREATING PLACENAMES FROM NODES----------')

        # Loop through each record in geojson
        for rec in node_placenames_geojson["features"]:
            with transaction.atomic():
                node_placename = self.create_placename(rec)

                # If the record is a Public Art PlaceName, we should create the Art's Artist (also a placename)
                # then associate it with the Art PlaceName using the ArtArtist model

                # Conditions are kept relatively light to trap errors (e.g. non-existing Artist)
                if rec["properties"]["type"] == 'public_art' and rec.get("artists"):
                    for artist_id in rec.get("artists"):
                        if artist_id:
                            # Get the record for the associated artist
                            artist_list = [placename for placename in node_placenames_geojson["features"]
                                           if placename["properties"]["node_id"] == artist_id]

                            # Create the PlaceName for the artist - Only get first item (records may duplicate)
                            artist_placename = self.create_placename(
                                artist_list[0])

                            # Create relationship (ignore if it already exists)
                            PublicArtArtist.objects.get_or_create(
                                public_art=node_placename, artist=artist_placename)

            for data in rec["related_data"]:
                for value in data.get("value"):
                    RelatedData.objects.get_or_create(
                        data_type=data.get("key"),
                        label=data.get("label"),
                        is_private=data.get("private"),
                        value=value,
                        placename=node_placename
                    )

            # Add location as related_data
            if rec["location_id"]:
                for row in self.query("""
                SELECT
                    street,
                    city,
                    province,
                    postal_code,
                    location_country.name
                FROM
                    location
                    left join location_country on country = code
                WHERE
                    lid = %s;
                """ % rec["location_id"]):
                    value = ""

                    # Append street to value if it exists
                    if row.get("street"):
                        value += row.get("street")

                    # Conditional data based on postal code and city
                    if row.get("postal_code") and row.get("city"):
                        value += "\n{} {}".format(row.get("postal_code"),
                                                  row.get("city"))
                    elif row.get("postal_code"):
                        value += "\n{}".format(row.get("postal_code"))
                    elif row.get("city"):
                        value += "\n{}".format(row.get("city"))

                    # Append province if it exists
                    if row.get("province"):
                        value += "\n{}".format(row.get("province"))

                    # Append Country if it exists
                    if row.get("name"):
                        value += "\n{}".format(row.get("name"))

                    # Sanitize location data
                    if value.startswith("\n"):
                        value = value.strip()
                    if value.startswith(", "):
                        value.replace(", ", "", 1)

                    RelatedData.objects.get_or_create(
                        data_type="location",
                        label="Location",
                        is_private=False,
                        value=value,
                        placename=node_placename
                    )

            for fid in rec["files"]:
                for index, row in enumerate(self.query("""
                    SELECT
                        file_managed.*,
                        field_shared_image_gallery_title
                    FROM
                        file_managed
                        LEFT JOIN field_data_field_shared_image_gallery ON fid = field_shared_image_gallery_fid
                    WHERE fid = %s;
                """ % fid), start=1):
                    # Extract data from query row
                    filename = row.get("field_shared_image_gallery_title", '')
                    uri = row["uri"]
                    mime_type = row["filemime"]
                    file_type = row["type"]

                    media_path = None
                    media_url = None

                    if not filename:
                        if node_placename.kind in NODES_WITH_ARTWORK:
                            filename = "{} - {} {}".format(
                                node_placename.name, 'Artwork', index)
                        else:
                            filename = "{} - {}".format(
                                node_placename.name, index)

                    try:
                        existing_media = Media.objects.get(
                            name=filename, placename=node_placename)
                    except Media.DoesNotExist:
                        existing_media = None

                    if not existing_media:
                        print('--Processing File: {}'.format(filename))

                        # If the video is from youtube/vimeo, only store their url
                        # Else, download the file from fp-artsmap.ca and set the media_file
                        from_youtube = uri.startswith("youtube://v/")
                        from_vimeo = uri.startswith("vimeo://v/")

                        if from_youtube or from_vimeo:
                            if from_youtube:
                                media_url = uri.replace(
                                    "youtube://v/", "https://youtube.com/watch?v=")
                            elif from_vimeo:
                                media_url = uri.replace(
                                    "vimeo://v/", "https://vimeo.com/")
                        else:
                            # Set up paths
                            download_url = uri.replace("public://", files_url)
                            storage_path = "{}/{}".format(
                                artsmap_path, uri.replace("public://", ""))
                            media_path = "{}/{}".format("fp-artsmap",
                                                        uri.replace("public://", ""))

                            if download_media:
                                if not os.path.exists(os.path.dirname(storage_path)):
                                    print('Creating ' +
                                          os.path.dirname(storage_path))
                                    os.makedirs(os.path.dirname(
                                        storage_path), exist_ok=True)

                                response = requests.get(
                                    download_url, allow_redirects=True)
                                open(storage_path, 'wb').write(
                                    response.content)

                        # If the media is a display picture, save it in the PlaceName
                        if fid == rec["properties"]["display_picture"]:
                            node_placename.image = media_path
                            node_placename.save()
                        else:
                            # Instantiate Media object and fill data
                            current_media = Media()

                            current_media.name = filename
                            current_media.mime_type = mime_type
                            current_media.file_type = file_type
                            if node_placename.kind in NODES_WITH_ARTWORK:
                                current_media.is_artwork = True
                            else:
                                current_media.is_artwork = False
                            current_media.status = "VE"
                            current_media.placename = node_placename

                            if media_path:
                                current_media.media_file = media_path
                            elif media_url:
                                current_media.url = media_url

                            # Save Media
                            current_media.save()

                        print('--Done\n')

        print("Arts imported!")

    def load_taxonomies(self):
        print('----------CREATING TAXONOMIES AND RELATION----------')
        existing_taxonomies = Taxonomy.objects.all()
        existing_taxonomies.delete()

        taxonomy_data = self.query("SELECT * FROM taxonomy_term_data;")

        for data in taxonomy_data:
            taxonomy = Taxonomy()
            taxonomy.name = data["name"]
            taxonomy.description = data["description"]

            taxonomy.save()

        taxonomy_hierarchies = self.query("""
            SELECT
                taxonomy_term_data.name,
                taxonomy_term_hierarchy.*,
                parent_taxonomy.name as parent_name
            FROM
                taxonomy_term_data
                JOIN taxonomy_term_hierarchy ON taxonomy_term_data.tid = taxonomy_term_hierarchy.tid
                LEFT JOIN taxonomy_term_data AS parent_taxonomy ON taxonomy_term_hierarchy.parent = parent_taxonomy.tid;

        """)

        for hierarchy in taxonomy_hierarchies:
            if hierarchy["parent_name"]:
                try:
                    taxonomy = Taxonomy.objects.get(name=hierarchy["name"])
                    parent_taxonomy = Taxonomy.objects.get(
                        name=hierarchy["parent_name"])

                    taxonomy.parent = parent_taxonomy

                    taxonomy.save()

                    print('Parent Saved: %s' % hierarchy["name"])
                except Taxonomy.DoesNotExist:
                    print('Taxonomy not found: %s' % hierarchy["name"])
            else:
                print('Root Hierarchy - No Parent')

        # Map taxonomies to their node_placenames
        node_placenames_geojson = self.nodes_to_geojson()

        for rec in node_placenames_geojson["features"]:
            try:
                node_placename = PlaceName.objects.get(
                    name=rec["properties"]["name"], kind=rec["properties"]["type"])

                for taxonomy in rec["taxonomies"]:
                    if taxonomy:
                        try:
                            current_taxonomy = Taxonomy.objects.get(
                                name=taxonomy)

                            PlaceNameTaxonomy.objects.get_or_create(
                                placename=node_placename,
                                taxonomy=current_taxonomy)

                            print('Setting PlaceName Taxonomy for %s' %
                                  node_placename)
                        except Taxonomy.DoesNotExist:
                            print('Taxonomy not found %s' % taxonomy)

            except PlaceName.DoesNotExist:
                print('PlaceName not found %s' % rec["properties"]["name"])

    def create_placename(self, rec):
        # avoid duplicates on remote data source.
        try:
            node_placename = PlaceName.objects.get(
                name=rec["properties"]["name"])
            # print('Updating %s' % rec["properties"]["name"])
        except PlaceName.DoesNotExist:
            node_placename = PlaceName(name=rec["properties"]["name"])
            print('Creating %s' % rec["properties"]["name"])

        # Geometry map point with latitude and longitude
        node_placename.geom = Point(
            float(rec["geometry"]["coordinates"][0]),  # latitude
            float(rec["geometry"]["coordinates"][1]),
        ) if rec["geometry"] else None
        node_placename.description = rec["properties"]["details"]
        node_placename.kind = rec["properties"]["type"]

        node_placename.save()

        return node_placename

    def nodes_to_geojson(self):
        db = pymysql.connect(
            os.environ["ARTSMAP_HOST"],
            os.environ["ARTSMAP_USER"],
            os.environ["ARTSMAP_PW"],
            os.environ["ARTSMAP_DB"],
        )

        # prepare a cursor object using cursor() method
        cursor = db.cursor()

        nodes = self.query("""
            SELECT
                type,
                title,
                nid
            FROM
                node
            WHERE
                type = 'art' OR
                type = 'per' OR
                type = 'org' OR
                type = 'event' OR
                type = 'resource' OR
                type = 'grant';
        """)
        geojson = {"type": "FeatureCollection", "features": []}

        _details = {}
        for node_type in ["per", "art", "org", "event", "resource", "grant"]:
            _details[node_type] = json.loads(
                open("tmp/{}.json".format(node_type)).read()
            )
        counter = 1

        for node in nodes:
            location = self.query("""
                SELECT DISTINCT
                    latitude,
                    longitude,
                    location.lid
                FROM
                    location
                    JOIN location_instance on location.lid = location_instance.lid
                WHERE
                    nid=%s
                ORDER BY
                    location.lid DESC
                LIMIT
                    1;
            """ % node.get("nid"))

            name = node.get("title", "").strip()
            node_type = node.get("type")
            node_id = node.get("nid")
            coordinates = [float(location[0].get("longitude", "")), float(
                location[0].get("latitude", ""))] if location else None

            details = _details[node_type][str(node_id)]

            # Attach files to node
            file_ids = []
            for k, v in details.items():
                if k.endswith('_fid'):
                    file_ids += v
            file_ids.sort()

            # Attach taxonomy to node
            taxonomy_list = []
            for k, v in details.items():
                if k == 'taxonomy_list':
                    taxonomy_list += v
            taxonomy_list.sort()

            related_data = []
            for k, value in details.items():
                data_type = None
                label = None
                private = False

                # Format Data
                if k == "field_shared_access_value":
                    label = 'Access'
                    data_type = 'access'
                if k == "field_shared_website_url":
                    label = 'Website(s)'
                    data_type = 'website'
                if k == "field_shared_email_email":
                    label = "Email"
                    data_type = 'email'
                    private = True
                if k == "field_per_fn_value":
                    label = "Indigenous/First Nation Association(s)"
                    data_type = 'fn'
                if k == "field_shared_awards_value":
                    data_type = 'award'
                    label = "Award(s)"

                # If this is a field we customized for adding, include it
                if data_type and label:
                    related_data.append({
                        "key": data_type,
                        "label": label,
                        "value": value,
                        "private": private
                    })

            user_email = self.query("""
                SELECT 
                    mail
                FROM
                    users,
                    node
                WHERE
                    users.uid = node.uid
                AND
                    node.nid=%s
                LIMIT
                    1;
            """ % node.get("nid"))

            if user_email[0]:
                related_data.append({
                    "key": 'user_email',
                    "label": 'Old Artsmap User Email',
                    "value": [user_email[0].get('mail', '')],
                    "private": True
                })

            feature = {
                "type": "Feature",
                "properties": {
                    "type": TYPE_MAP[node_type],
                    "name": name,
                    "details": details.get("body_value", [""])[0],
                    "node_id": node_id,
                    "display_picture": details.get("field_shared_image_fid", [""])[0]
                },
                "geometry": {
                    "type": "Point",
                    "coordinates": coordinates
                } if location else None,
                "files": file_ids,
                "taxonomies": taxonomy_list,
                "related_data": related_data,
                "location_id": details.get("field_shared_location_lid", [""])[0]
            }

            if node_type == 'art' and details.get('field_art_artist_nid'):
                feature["artists"] = details.get("field_art_artist_nid", [])

            geojson["features"].append(feature)

        open("tmp/geojson.json", "w").write(
            json.dumps(geojson, indent=4, sort_keys=True)
        )
        return geojson
