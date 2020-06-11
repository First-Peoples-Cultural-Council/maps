from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import transaction
from language.models import PlaceName, Media, PublicArtArtist, Taxonomy, PlaceNameTaxonomy, RelatedData
from django.contrib.gis.geos import Point

import os
import sys
import json

import pymysql
import requests
import glob
import shutil
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
    c.load_nodes()
    c.load_taxonomies()


TYPE_MAP = {
    "art": "public_art",
    "org": "organization",
    "per": "artist",
    "event": "event",
    "resource": "resource",
    "grant": "grant"
}

NODES_WITH_ARTWORK = ["public_art", "artist"]


class Client(dedruplify.DeDruplifierClient):

    def load_nodes(self):
        # SETUP FOR SAVING MEDIA
        # Files url - source from which to download media files
        files_url = "https://www.fp-artsmap.ca/sites/default/files/"

        # Delete art artists
        art_artists = PublicArtArtist.objects.all()
        art_artists.delete()

        # Set artsmap path - directory for media files downloaded from fp-artsmap.ca
        artsmap_path = "{}{}{}".format(
            settings.BASE_DIR, settings.MEDIA_URL, "fp-artsmap")

        # # COMMENT IF MEDIA IS ALREADY DOWNLOADED
        # # Delete fp-artsmap directory contents if it exists
        # if os.path.exists(artsmap_path):
        #     files = glob.glob("{}/*".format(artsmap_path))
        #     for f in files:
        #         if os.path.isfile(f):
        #             os.remove(f)
        #         elif os.path.isdir(f):
        #             shutil.rmtree(f)

        # # Create fp-artsmap directory
        # if not os.path.exists(artsmap_path):
        #     os.mkdir(artsmap_path)
        # # END COMMENT

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
                        value += ", {}".format(row.get("province"))

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

                            # # COMMENT IF MEDIA IS ALREADY DOWNLOADED
                            # if not os.path.exists(os.path.dirname(storage_path)):
                            #     print('Creating ' + os.path.dirname(storage_path))
                            #     os.makedirs(os.path.dirname(storage_path), exist_ok=True)

                            # response = requests.get(download_url, allow_redirects=True)
                            # open(storage_path, 'wb').write(response.content)
                            # # END COMMENT

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


# TODO: move to db query.
TAX_TERMS = [
    (
        1,
        1,
        "Person",
        "<p>The &lsquo;Person&rsquo; category includes Aboriginal or First Nations people who are working as artists or arts administrators.</p>",
        68,
        "1",
        "faadf94e-9c1b-4bd9-90c0-c7afd6c2f9d2",
    ),
    (2, 1, "Artist", "", 0, None, "52e26958-a29e-4a11-b312-2d2acae041d4"),
    (8, 1, "Advisor", "", 1, None, "e941b703-f70b-4aa0-a92a-4f313ff20705"),
    (12, 1, "Supplier", "", 3, None, "51522412-8808-436c-8605-5d8ca1dfc413"),
    (
        15,
        1,
        "Public Art",
        "<p>The &ldquo;Public Art&rsquo; category includes any artworks that are installed in a place or manner that makes them accessible for viewing by the public. Includes publicly accessible sites of cultural significance.</p>",
        72,
        "1",
        "f3eaab78-2873-4e53-80ce-ffe21203682f",
    ),
    (16, 1, "Carving", "", 1, None, "f7edb0b5-235d-4e96-92bc-995274783512"),
    (24, 1, "Architectural", "", 0, None, "f2d3d149-b6bb-4d58-a6f5-16c2e5d052b4"),
    (27, 1, "Weaving", "", 0, None, "66a10968-2bee-4ab5-bc0b-012357800944"),
    (45, 1, "Poet", "", 1, None, "eb182bd1-ec26-4261-b5d8-c1001f866a05"),
    (53, 1, "Other Artwork", "", 5, None, "148eef06-f83d-47b2-ac21-e7297f5b6980"),
    (
        54,
        1,
        "Organization",
        "<p>The &lsquo;Organization&rsquo; category includes Aboriginal or First Nations arts groups or organizations working in all disciplines.</p>",
        69,
        "1",
        "4c796e30-3669-48d2-8eb4-660a80ed5752",
    ),
    (55, 1, "Cultural Centre", "", 1, None,
     "b4f62a90-3cd1-46b6-944e-3b54da996b1b"),
    (56, 1, "Arts Group", "", 0, None, "bafa558f-4afd-42bf-8b11-05076e7f37b5"),
    (58, 1, "Artists' Collective", "", 1, None,
     "893a3423-e745-49b6-9eba-030512d72f4e"),
    (59, 1, "Funder", "", 2, "1", "e70805ab-3330-4271-8275-d57261f0d21f"),
    (60, 1, "School", "", 5, "1", "0238377c-88e9-40ae-8072-1fa5e63b60f2"),
    (61, 1, "Venue", "", 4, None, "14f8f62f-b687-4d5f-9900-6481df130d61"),
    (62, 1, "Gallery", "", 3, "1", "09a59051-e22f-4a01-9f8e-20a71521e9ad"),
    (64, 1, "Other Organization", "", 6, None,
     "4f02e021-9eaf-426a-b4ed-f787e50ba9d3"),
    (
        69,
        1,
        "Event",
        "<p>The &lsquo;Event&rsquo; category includes Aboriginal or First Nations arts and culture events, or those events that include a strong arts component that people should know about. This includes all artistic disciplines.</p>",
        70,
        "1",
        "bbc036b8-b866-4865-ba0b-d186e9df3297",
    ),
    (70, 1, "Cultural Gathering", "", 4, None,
     "874820ae-1036-4300-a00d-94119e44cc24"),
    (71, 1, "Festival", "", 5, None, "fa762610-6085-4daa-b079-cb902c6ec51f"),
    (73, 1, "Conference", "", 6, None, "907b9087-973f-4fc2-b9f5-86e7f6840403"),
    (74, 1, "Pow-wow", "", 3, None, "7c9bd15c-289b-4562-9c7c-d8901e093f25"),
    (75, 1, "Workshop", "", 7, None, "f86a10bb-ca2a-447c-97ff-ac0e99f729ac"),
    (78, 1, "Performance", "", 2, None, "951dc141-64fa-49e0-920e-9d287a5fe986"),
    (79, 1, "Exhibition", "", 1, None, "ad773f6f-255d-4f53-941e-f187e6451617"),
    (80, 1, "Other Event", "", 8, None, "63404455-bdc6-429b-b7c7-7042f5a9e3ef"),
    (81, 1, "Actor", "", 0, None, "816648d1-482c-4272-802e-aae2e948e82b"),
    (
        82,
        1,
        "Administrator",
        "Arts Administrators are those who create and support opportunities for artists, including curators, producers, arts and culture managers, etc.",
        1,
        None,
        "f6b4b600-cac5-45e6-ab31-5b529b8aea1d",
    ),
    (83, 1, "Choreographer", "", 1, None, "6de956f3-c395-4386-b003-d9855275198d"),
    (84, 1, "Composer", "", 2, None, "bf2783ff-fbef-472f-b13e-b522bfee2c94"),
    (85, 1, "Curator", "", 0, None, "569bc37a-e23e-48f6-91c0-c1357f8f3c1a"),
    (86, 1, "Dancer", "", 4, None, "a86d683d-c395-446e-a093-59add8cdc13d"),
    (88, 1, "Producer", "", 3, None, "ca992499-0b40-4d66-9874-c8f43a2bc8aa"),
    (90, 1, "Storyteller", "", 0, None, "b662d6c7-0c29-4c01-a3de-b18ea37e3d77"),
    (96, 1, "Mural", "", 1, None, "649360b2-50d1-4d72-a10a-607151b308f3"),
    (99, 1, "Agent", "", 2, None, "a356a3a1-dfdb-4f92-bb4b-89ffea6bead2"),
    (101, 1, "Museum", "", 4, "1", "7fff27bf-ab7e-4485-abaa-de2e9aaad9cd"),
    (
        104,
        1,
        "Aboriginal Arts Organization",
        "An organization, group, or collective directed by Aboriginal people with a mandate to create or present works in any discipline. ",
        0,
        None,
        "b10558c3-9f25-4cce-84c6-674e12441fb3",
    ),
    (
        107,
        1,
        "Visual",
        "Visual artists including Painter, Weaver, Carver, Jeweler, Graphic Designer, and other visual artists",
        0,
        None,
        "4f0a6258-39b8-4e61-91f5-72ddcbf7cea7",
    ),
    (108, 1, "Performing", "", 1, None, "6787223d-7d80-409d-868a-e86cd7dc1af3"),
    (109, 1, "Words", "", 2, None, "298c79a3-88c1-4414-b5dc-bfb83b73e304"),
    (110, 1, "Media", "", 3, None, "34ebfc79-f20e-482f-8fa1-95f1840ada24"),
    (111, 1, "Other Artist", "", 4, None, "c178fb6e-0bad-467c-b232-60781b84a723"),
    (
        112,
        1,
        "Other Administrator",
        "",
        4,
        None,
        "71ab3e23-a0ae-4cbb-bab1-973394b242ae",
    ),
    (114, 1, "Painter", "", 0, None, "bf7ff480-ba96-41ee-94c5-7d1628c80eec"),
    (115, 1, "Weaver", "", 1, None, "101fbba1-5aaf-4e13-9651-298efdbf6367"),
    (116, 1, "Carver", "", 2, None, "c2efc650-2481-4b52-9ac2-b1205ce4a2e3"),
    (117, 1, "Jeweler", "", 3, None, "6e6e6bf6-21a1-4a9d-84e1-6b5207e42be4"),
    (118, 1, "Graphic Designer", "", 4, None,
     "e8277a9d-1a81-4f83-852b-10b9bfa0b87e"),
    (119, 1, "Visual - Other", "", 5, None,
     "14eb037b-ebe6-4c3a-93c2-d435faf6846f"),
    (120, 1, "Director", "", 3, None, "6af232e7-6d97-4897-9c14-77a267377d84"),
    (121, 1, "Musician", "", 5, None, "167a1ea9-a9ff-4450-b311-7d5fb2b560b1"),
    (122, 1, "Spoken Word Artist", "", 2, None,
     "8486782e-ed5e-4851-841d-ca2d77bc0f47"),
    (123, 1, "Children's Author", "", 3, None,
     "23e55af7-cbef-4b1d-bfe1-6e39856bf218"),
    (124, 1, "Graphic Novelist", "", 4, None,
     "d7887c5f-8965-4a4c-9a20-3a3bb61c732c"),
    (125, 1, "Photographer", "", 0, None, "86b63ecb-cf07-442a-bde5-58e8132f6451"),
    (126, 1, "Film and Video", "", 1, None,
     "43e1a633-d5bc-4972-a983-6c99552454a7"),
    (127, 1, "Animator", "", 2, None, "e8e16ceb-6886-42d5-ad2b-91ce5a10012a"),
    (128, 1, "New Media Artist", "", 3, None,
     "ce5f1f52-59ae-4e57-9c80-f95b8de2e301"),
    (
        129,
        1,
        "Resource",
        "<p>The &lsquo;Resource&rsquo; category includes those entities that provide resources, services or other support relevant to Aboriginal artists, and that may not be exclusively First Nation or Aboriginal directed.</p>",
        71,
        "1",
        "8cfdd967-7b7f-4e00-88eb-2eb2030c2e0c",
    ),
    (130, 1, "Service", "", 0, None, "498be8f9-b434-456a-b230-5067a81bfd10"),
    (131, 1, "Tools", "", 2, None, "a503e130-fab6-4132-a3ce-c2d2a10083a2"),
    (132, 1, "Training", "", 1, None, "6ef45995-fc6a-4192-a232-29c62eacc67f"),
    (133, 1, "Sculpture", "", 3, None, "45eb22e0-691c-4356-8b6f-a53af7168dc0"),
    (
        134,
        2,
        "First Peoples Arts Map news",
        "<p>An occasional Newsletter put out by the Arts Map moderators.</p>",
        0,
        "1",
        "1c485274-5fcc-49af-8a64-e8c3c4eb1d55",
    ),
    (
        135,
        1,
        "Arts and Crafts Show",
        "",
        0,
        None,
        "c11c8a9c-4e30-48b0-8bf3-bfd01b2a5f1d",
    ),
    (
        136,
        3,
        "Individual Emerging Artist",
        "",
        0,
        "1",
        "5520abc9-3a76-4ceb-97d1-33d4052e99f2",
    ),
    (
        137,
        3,
        "Sharing Traditional Arts",
        "",
        0,
        "1",
        "5be03cd7-1414-4026-8c61-115c19cec854",
    ),
    (
        138,
        3,
        "Organizations and Collectives",
        "",
        0,
        "1",
        "73eebe35-045b-4cd8-8493-58dc084b2c22",
    ),
    (
        139,
        3,
        "Arts Administrator Internships",
        "",
        0,
        "1",
        "53ace297-a60e-4d3c-a712-dbf3b9cb7022",
    ),
    (
        140,
        3,
        "Aboriginal Youth Engaged in the Arts",
        "",
        0,
        "1",
        "2604975c-4544-443c-ae3b-1886dec9370c",
    ),
    (142, 1, "Singer", "", 6, "1", "80c75f34-8310-4934-9a55-7f9b6cb12ab4"),
    (143, 1, "Pole", "", 0, "1", "89baad17-4f06-47d4-9d52-917b857c17b5"),
    (144, 1, "Portal", "", 0, "1", "0df29e6b-ab87-4f3f-860a-7cfaada09dcb"),
    (145, 1, "Textile", "", 4, "1", "b89d1d2d-26bc-4030-8ef5-9ec569fc593c"),
    (146, 1, "Painting", "", 2, "1", "cc46c13e-9674-4348-ae1b-fe270befe77d"),
    (147, 1, "Graffiti", "", 0, "1", "2bfb2385-447a-4266-bcf9-342ffcb213a7"),
    (
        148,
        3,
        "Music Industry Professionals",
        "",
        0,
        "1",
        "37403a4e-34c2-41c7-91b4-b55800cf6c54",
    ),
    (
        149,
        3,
        "Music Recording Industry",
        "",
        0,
        "1",
        "262750e3-e76d-4d00-8793-77708db80b8f",
    ),
]
