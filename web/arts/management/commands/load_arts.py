from django.core.management.base import BaseCommand
from django.db import transaction
from arts.models import Art
from language.models import PlaceName
from django.contrib.gis.geos import Point

import os
import sys
import json

import pymysql
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


TYPE_MAP = {"art": "public_art", "org": "organization", "per": "artist"}


class Client(dedruplify.DeDruplifierClient):

    def load_arts(self):

        arts_geojson = self.nodes_to_geojson()
        # OLD IMPLEMENTATION FOR SAVING ARTS IN ART MODEL
        # TEMPORARILY COMMENTING BEFORE COMPLETELY OVERRIDING

        # Removing every Art object from the database.
        # We are loading everything from the scratch
        arts = Art.objects.all()
        arts.delete()

        error_log = []
        for rec in arts_geojson["features"]:

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

        # Removing every Art PlaceName object from the database.
        # We are loading everything from the scratch
        # arts = PlaceName.objects.filter(is_art=True)
        # arts.delete()

        # error_log = []
        # for rec in arts_geojson["features"]:

        #     with transaction.atomic():
        #         # avoid duplicates on remote data source.
        #         try:
        #             art = PlaceName.objects.get(name=rec["properties"]["name"])
        #         except PlaceName.DoesNotExist:
        #             art = PlaceName(name=rec["properties"]["name"])

        #         # Geometry map point with latitude and longitude
        #         art.geom = Point(
        #             float(rec["geometry"]["coordinates"][0]),  # latitude
        #             float(rec["geometry"]["coordinates"][1]),
        #         )  # longitude
        #         art.node_type = rec["properties"]["type"]
        #         art.ndoe_details = rec["properties"]["details"]
        #         art.node_id = rec["properties"]["node_id"]
        #         art.is_art = True

        #         art.save()

        if len(error_log) > 0:
            for error in error_log:
                print(error)
        else:
            print("Arts imported!")

    def nodes_to_geojson(self):
        db = pymysql.connect(
            os.environ["ARTSMAP_HOST"],
            os.environ["ARTSMAP_USER"],
            os.environ["ARTSMAP_PW"],
            os.environ["ARTSMAP_DB"],
        )

        # prepare a cursor object using cursor() method
        cursor = db.cursor()

        sql = """
        select distinct node.type, node.title, location.latitude, location.longitude, node.nid
        from node inner join location_instance on node.nid=location_instance.nid
            inner join location on location.lid=location_instance.lid
        where node.type = 'art' or node.type = 'per' or node.type = 'org';
        """
        # Execute the SQL command
        cursor.execute(sql)
        # Fetch all the rows in a list of lists.
        results = cursor.fetchall()

        geojson = {"type": "FeatureCollection", "features": []}

        _details = {}
        for node_type in ["art", "per", "org"]:
            _details[node_type] = json.loads(
                open("tmp/{}.json".format(node_type)).read()
            )

        for row in results:
            if float(row[2]) and float(row[3]):  # only want spatial data.
                name = row[1].strip()
                if float(row[3]) > -110:
                    print(row[3], "is outside the allowable area for this map, skip.")
                    # skip any features that are past Alberta,
                    # there seems to be junk in the arts db.
                    continue
                if (
                    name.lower().endswith("band")
                    or name.lower().endswith("nation")
                    or name.lower().endswith("council")
                    or name.lower().endswith("nations")
                ):
                    # bands are duplicated in other layers, skip them.
                    print(row[1], "is duplicated in another layer, skip.")
                    continue

                details = _details[row[0]][str(row[4])]
                if details.get('field_shared_privacy_value', ["1"])[0] == "0":
                    print(row[1], "is private.")
                    continue
                geojson["features"].append(
                    {
                        "type": "Feature",
                        "properties": {
                            "type": TYPE_MAP[row[0]],
                            "name": name,
                            "details": details.get("body_value", [""])[0],
                            "node_id": row[4],
                        },
                        "geometry": {
                            "type": "Point",
                            "coordinates": [float(row[3]), float(row[2])],
                        },
                    }
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
    (55, 1, "Cultural Centre", "", 1, None, "b4f62a90-3cd1-46b6-944e-3b54da996b1b"),
    (56, 1, "Arts Group", "", 0, None, "bafa558f-4afd-42bf-8b11-05076e7f37b5"),
    (58, 1, "Artists' Collective", "", 1, None, "893a3423-e745-49b6-9eba-030512d72f4e"),
    (59, 1, "Funder", "", 2, "1", "e70805ab-3330-4271-8275-d57261f0d21f"),
    (60, 1, "School", "", 5, "1", "0238377c-88e9-40ae-8072-1fa5e63b60f2"),
    (61, 1, "Venue", "", 4, None, "14f8f62f-b687-4d5f-9900-6481df130d61"),
    (62, 1, "Gallery", "", 3, "1", "09a59051-e22f-4a01-9f8e-20a71521e9ad"),
    (64, 1, "Other Organization", "", 6, None, "4f02e021-9eaf-426a-b4ed-f787e50ba9d3"),
    (
        69,
        1,
        "Event",
        "<p>The &lsquo;Event&rsquo; category includes Aboriginal or First Nations arts and culture events, or those events that include a strong arts component that people should know about. This includes all artistic disciplines.</p>",
        70,
        "1",
        "bbc036b8-b866-4865-ba0b-d186e9df3297",
    ),
    (70, 1, "Cultural Gathering", "", 4, None, "874820ae-1036-4300-a00d-94119e44cc24"),
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
    (118, 1, "Graphic Designer", "", 4, None, "e8277a9d-1a81-4f83-852b-10b9bfa0b87e"),
    (119, 1, "Visual - Other", "", 5, None, "14eb037b-ebe6-4c3a-93c2-d435faf6846f"),
    (120, 1, "Director", "", 3, None, "6af232e7-6d97-4897-9c14-77a267377d84"),
    (121, 1, "Musician", "", 5, None, "167a1ea9-a9ff-4450-b311-7d5fb2b560b1"),
    (122, 1, "Spoken Word Artist", "", 2, None, "8486782e-ed5e-4851-841d-ca2d77bc0f47"),
    (123, 1, "Children's Author", "", 3, None, "23e55af7-cbef-4b1d-bfe1-6e39856bf218"),
    (124, 1, "Graphic Novelist", "", 4, None, "d7887c5f-8965-4a4c-9a20-3a3bb61c732c"),
    (125, 1, "Photographer", "", 0, None, "86b63ecb-cf07-442a-bde5-58e8132f6451"),
    (126, 1, "Film and Video", "", 1, None, "43e1a633-d5bc-4972-a983-6c99552454a7"),
    (127, 1, "Animator", "", 2, None, "e8e16ceb-6886-42d5-ad2b-91ce5a10012a"),
    (128, 1, "New Media Artist", "", 3, None, "ce5f1f52-59ae-4e57-9c80-f95b8de2e301"),
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
