from rest_framework.test import APITestCase
from rest_framework import status
from django.utils import timezone

from users.models import User, Administrator
from django.contrib.gis.geos import GEOSGeometry

from language.models import (
    Language,
    PlaceName,
    Community,
    CommunityMember,
    Media,
    Recording,
    RelatedData,
    PublicArtArtist,
    Taxonomy,
    PlaceNameTaxonomy
)
from web.constants import *

class BaseTestCase(APITestCase):
    def setUp(self):
        # Create an Admin Type User
        self.admin_user = User.objects.create(
            username="admin_user",
            first_name="Admin",
            last_name="User",
            email="admin@countable.ca",
            is_staff=True,
            is_superuser=True,
        )
        self.admin_user.set_password("password")
        self.admin_user.save()

        # Create a Regular User with no Privileges
        self.regular_user = User.objects.create(
            username="regular_user",
            first_name="Regular",
            last_name="User",
            email="regular@countable.ca"
        )
        self.regular_user.set_password("password")
        self.regular_user.save()


class PlaceNameAPIRouteTests(APITestCase):
    def test_placename_detail_route_exists(self):
        """
        Ensure PlaceName details API route exists
        """
        test_placename00 = PlaceName.objects.create(
            name="test place00"
        )
        response = self.client.get("/api/placename/{}/".format(test_placename00.id), format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_placename_list_route_exists(self):
        """
        Ensure PlaceName list API route exists
        """
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    # GEO APIs
    def test_placename_geo_route_exists(self):
        """
        Ensure PlaceName Geo API route exists
        """
        response = self.client.get("/api/placename-geo/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_art_geo_route_exists(self):
        """
        Ensure Art Geo API route exists
        """
        response = self.client.get("/api/art-geo/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    # Search APIs
    def test_placename_search_route_exists(self):
        """
        Ensure PlaceName Search API route exists
        """
        response = self.client.get("/api/placename-search/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_art_search_route_exists(self):
        """
        Ensure Art Search API route exists
        """
        response = self.client.get("/api/art-search/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    # Lists for Arts tab
    def test_public_art_list_route_exists(self):
        """
        Ensure Public Arts List API route exists
        """
        response = self.client.get("/api/arts/public-art/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_artist_list_route_exists(self):
        """
        Ensure Artist List API route exists
        """
        response = self.client.get("/api/arts/artist/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_event_list_route_exists(self):
        """
        Ensure Event List API route exists
        """
        response = self.client.get("/api/arts/event/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_organization_list_route_exists(self):
        """
        Ensure Organization API route exists
        """
        response = self.client.get("/api/arts/organization/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_resource_list_route_exists(self):
        """
        Ensure Resource List API route exists
        """
        response = self.client.get("/api/arts/resource/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_grant_list_route_exists(self):
        """
        Ensure Grant List API route exists
        """
        response = self.client.get("/api/arts/grant/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_artwork_list_route_exists(self):
        """
        Ensure Artwork List API route exists
        """
        response = self.client.get("/api/arts/artwork/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_poi_list_route_exists(self):
        """
        Ensure Art Search API route exists
        """
        response = self.client.get("/api/arts/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class PlaceNameAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.now = timezone.now()

        self.community = Community.objects.create(name="Test Community")
        self.community2 = Community.objects.create(name="Test Community 02")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.language2 = Language.objects.create(name="Test Language 02")
        self.taxonomy = Taxonomy.objects.create(name="Test Taxonomy", description="Test taxonomy desc.")

        self.user2 = User.objects.create(
            username="testuser002",
            first_name="Test2",
            last_name="user 002",
            email="test2@countable.ca",
            is_staff=True,
            is_superuser=True,
        )
        self.user2.set_password("password")
        self.user2.save()

        self.recording = Recording.objects.create(
            speaker="Test recording",
            recorder="Test recording",
            created=self.now,
            date_recorded=self.now,
        )

    """
    ONE TEST TESTS ONLY ONE SCENARIO
    """
    def test_placename_detail(self):
        """
        Ensure we can retrieve a newly created placename object.
        """
        test_placename = PlaceName.objects.create(
            name="Test placename 001",
        )
        response = self.client.get(
            "/api/placename/{}/".format(test_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Test placename 001")

    def test_placename_detail_returned_fields(self):
        """
            Ensure we can retrieve a newly created placename object.
        """
        test_placename = PlaceName.objects.create(
            name="Test placename 001",
            audio=self.recording,
            audio_name="string",
            audio_description="string",
            language=self.language1,
        )
        test_placename.communities.set([self.community])
        response = self.client.get(
            "/api/placename/{}/".format(test_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Test placename 001")
        self.assertEqual(response.data["audio"], self.recording.id)
        self.assertEqual(len(response.data["communities"]), 1)
        self.assertEqual(response.data["language"], self.language1.id)
        self.assertEqual(response.data["audio_obj"]["speaker"], self.recording.speaker)
        self.assertEqual(response.data["audio_obj"]["recorder"], self.recording.recorder)

    def test_placename_list_not_logged_in(self):
        """
        Ensure placename list API brings newly created data
        """
        # VERIFIED Placename
        test_placename01 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
            status=VERIFIED
        )
        test_placename01.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED Placename
        test_placename02 = PlaceName.objects.create(
            name="test place02",
            language=self.language1,
            status=UNVERIFIED
        )
        test_placename02.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED Placename
        test_placename03 = PlaceName.objects.create(
            name="test place03",
            language=self.language1,
            status=REJECTED
        )
        test_placename03.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # FLAGGED Placename
        test_placename04 = PlaceName.objects.create(
            name="test place04",
            language=self.language1,
            status=FLAGGED
        )
        test_placename04.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_placename_list_logged_in_creator(self):
        """
        Ensure placename list API brings newly created data
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED Placename
        test_placename01 = PlaceName.objects.create(
            name="test place01",
            creator=self.admin_user,
            language=self.language1,
            community_only=True,
        )
        test_placename01.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED Placename
        test_placename02 = PlaceName.objects.create(
            name="test place02",
            creator=self.admin_user,
            language=self.language1,
            community_only=True,
            status=UNVERIFIED
        )
        test_placename02.communities.set([self.community2])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED Placename
        test_placename03 = PlaceName.objects.create(
            name="test place03",
            creator=self.admin_user,
            language=self.language1,
            community_only=True,
            status=REJECTED
        )
        test_placename03.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED Placename
        test_placename04 = PlaceName.objects.create(
            name="test place04",
            creator=self.admin_user,
            language=self.language1,
            community_only=True,
            status=FLAGGED
        )
        test_placename04.communities.set([self.community2])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # REJECTED Placename from another user
        test_placename05 = PlaceName.objects.create(
            name="test place05",
            creator=self.user2,
            language=self.language1,
            status=REJECTED
        )
        test_placename05.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_placename_list_logged_in_member(self):
        """
        Ensure placename list API brings newly created data
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED COMMUNITY_ONLY Placename
        test_placename01 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
            community_only=True,
            status=VERIFIED
        )
        test_placename01.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # UNVERIFIED CommunityMember MATCHING users's community
        member_same01 = CommunityMember.objects.create(
            user=self.admin_user,
            community=self.community,
            status=UNVERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # After the community member is VERIFIED
        member_same01.status = VERIFIED
        member_same01.save()
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED COMMUNITY_ONLY Placename
        test_placename02 = PlaceName.objects.create(
            name="test place02",
            language=self.language1,
            community_only=True,
            status=UNVERIFIED
        )
        test_placename02.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED COMMUNITY_ONLY Placename
        test_placename03 = PlaceName.objects.create(
            name="test place03",
            language=self.language1,
            community_only=True,
            status=REJECTED
        )
        test_placename03.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED COMMUNITY_ONLY Placename
        test_placename04 = PlaceName.objects.create(
            name="test place04",
            language=self.language1,
            community_only=True,
            status=FLAGGED
        )
        test_placename04.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # VERIFIED COMMUNITY_ONLY Placename from another community
        test_placename05 = PlaceName.objects.create(
            name="test place05",
            language=self.language1,
            community_only=True,
            status=VERIFIED
        )
        test_placename05.communities.set([self.community2])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_placename_list_logged_in_administrator(self):
        """
        Ensure placename list API brings newly created data
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED COMMUNITY_ONLY Placename
        test_placename01 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
            community_only=True,
            status=VERIFIED
        )
        test_placename01.communities.set([self.community])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # Administrator of the pair language/community
        admin = Administrator.objects.create(
            user=self.admin_user,
            community=self.community,
            language=self.language1,
        )

        # After the user became an Administrator
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED COMMUNITY_ONLY Placename
        test_placename02 = PlaceName.objects.create(
            name="test place02",
            language=self.language1,
            community_only=True,
            status=UNVERIFIED
        )
        test_placename02.communities.set([self.community2])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # After changing the placename to the Administrator community
        test_placename02.communities.set([self.community])

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED COMMUNITY_ONLY Placename
        test_placename03 = PlaceName.objects.create(
            name="test place03",
            language=self.language1,
            community_only=True,
            status=REJECTED
        )
        test_placename03.communities.set([self.community2])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # After changing the placename to the Administrator community
        test_placename03.communities.set([self.community])

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED COMMUNITY_ONLY Placename
        test_placename04 = PlaceName.objects.create(
            name="test place04",
            language=self.language1,
            community_only=True,
            status=FLAGGED
        )
        test_placename04.communities.set([self.community2])
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # After changing the placename to the Administrator community
        test_placename04.communities.set([self.community])

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_placename_list_to_verify(self):
        """
        Ensure placename list API brings newly created data which needs to be verified
        """
        admin = Administrator.objects.create(
            user=self.admin_user,
            language=self.language1,
            community=self.community
        )

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # VERIFIED Placename MATCHING user's language. It MUST NOT be returned by the route
        test_placename01 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
            status=VERIFIED
        )
        test_placename01.communities.set([self.community])
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # UNVERIFIED Placename MATCHING user's language. It MUST be returned by the route
        test_placename02 = PlaceName.objects.create(
            name="test place02",
            language=self.language1,
            status=UNVERIFIED,
            status_reason="string"
        )
        test_placename02.communities.set([self.community])
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        assert len(response.data[0]['status_reason']) > 0

        # FLAGGED Placename MATCHING user's language. It MUST be returned by the route
        test_placename03 = PlaceName.objects.create(
            name="test place03",
            language=self.language1,
            status=FLAGGED,
            status_reason="string"
        )
        test_placename03.communities.set([self.community])
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # UNVERIFIED Placename NOT MATCHING user's language and community. It MUST NOT be returned by the route
        test_placename04 = PlaceName.objects.create(
            name="test place04",
            language=self.language2,
            status=UNVERIFIED,
            status_reason="string"
        )

        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_placename_post(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/placename/",
            {
                "name": "test place",
                "kind": "poi",
                "other_names": "string",
                "common_name": "string",
                "community_only": True,
                "description": "string",
                "communities": [self.community.id],
                "language": self.language1.id,
                "audio": self.recording.id,
            },
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.name, "test place")
        self.assertEqual(place.communities.count(), 1)
        self.assertEqual(place.language_id, self.language1.id)
        self.assertEqual(place.audio_id, self.recording.id)

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/".format(created_id),
            {"other_names": "updated other names"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.other_names, "updated other names")
        self.assertEqual(place.communities.count(), 1)
        self.assertEqual(place.language_id, self.language1.id)
        self.assertEqual(place.audio_id, self.recording.id)

    def test_placename_verify(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.language = self.language1
        placename.save()
        placename.communities.set([self.community])

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/verify/".format(created_id),
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, VERIFIED)

    def test_placename_reject(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.creator = self.admin_user
        placename.language = self.language1
        placename.save()
        placename.communities.set([self.community])

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/reject/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, REJECTED)

    def test_placename_flag(self):
        placename = PlaceName()
        placename.name = "test place"
        placename.creator = self.admin_user
        placename.language = self.language1
        placename.save()
        placename.communities.set([self.community])

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/flag/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, FLAGGED)

    def test_placename_public_arts(self):
        """
        Ensure we can retrieve the public_arts data of a placename
        """
        artist = PlaceName.objects.create(
            name="Arist",
            kind="artist"
        )
        public_art = PlaceName.objects.create(
            name="Test Public Art",
            description="A test public art description.",
            kind="public_art"
        )
        # Create relationship between the two placenames
        PublicArtArtist.objects.create(
            public_art=public_art,
            artist=artist
        )

        response = self.client.get(
            "/api/placename/{}/".format(artist.id), format="json"
        )

        data = response.json()

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(["public_arts"]), 1)
        self.assertEqual(data["public_arts"][0]["id"], public_art.id)

    def test_placename_artists(self):
        """
        Ensure we can retrieve the artsist data of a placename
        """
        public_art = PlaceName.objects.create(
            name="Public Art",
            kind="public_art"
        )
        artist = PlaceName.objects.create(
            name="Test Arist",
            description="A test artist description.",
            kind="artist"
        )
        # Create relationship between the two placenames
        PublicArtArtist.objects.create(
            public_art=public_art,
            artist=artist
        )

        response = self.client.get(
            "/api/placename/{}/".format(public_art.id), format="json"
        )

        data = response.json()

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(["artists"]), 1)
        self.assertEqual(data["artists"][0]["id"], artist.id)

    def test_placename_taxonomy(self):
        """
        Ensure we can retrieve the taxonomies attached to each placename
        """
        test_placename06 = PlaceName.objects.create(
            name="test place06"
        )

        PlaceNameTaxonomy.objects.create(
            placename=test_placename06,
            taxonomy=self.taxonomy
        )

        response = self.client.get(
            "/api/placename/{}/".format(test_placename06.id), format="json"
        )

        data = response.json()

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(["taxonomies"]), 1)
        self.assertEqual(data["taxonomies"][0]["id"], self.taxonomy.id)

    def test_placename_related_data(self):
        """
        Ensure we can retrieve the related_data attached to each placename
        """
        test_placename07 = PlaceName.objects.create(
            name="test place07"
        )

        location = RelatedData.objects.create(
            data_type="location",
            value="Test Address",
            placename=test_placename07
        )

        response = self.client.get(
            "/api/placename/{}/".format(test_placename07.id), format="json"
        )

        data = response.json()

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(["related_data"]), 1)
        self.assertEqual(data["related_data"][0]["id"], location.id)

    def test_art_geo(self):
        """
        Ensure we only retrieve node_placenames from art-geo API
        """
        # This placename should not be a part of the result
        # because this does not have a geo
        test_placename08 = PlaceName.objects.create(  # Excluded
            name="test place08",
            kind="public_art"
        )
        test_placename09 = PlaceName.objects.create(  # Included (1)
            name="test place09",
            kind="artist",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename10 = PlaceName.objects.create(  # Excluded
            name="test place10",
            kind="organization"
        )
        test_placename11 = PlaceName.objects.create(  # Included (2)
            name="test place11",
            kind="event",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename12 = PlaceName.objects.create(  # Included (3)
            name="test place12",
            kind="resource",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        # This placename should not be a part of the result
        # because this is not a node_placename
        test_placename13 = PlaceName.objects.create(  # Excluded
            name="test place13",
            kind="poi"
        )
        # This placename should not be a part of the result
        # because this has an invalid coordinates [0, 0]
        test_placename14 = PlaceName.objects.create(  # Excluded
            name="test place14",
            kind="resource",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        response = self.client.get(
            "/api/art-geo/", format="json"
        )

        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 3)  # Only 3 data with geom and is a Node PlaceName
        self.assertEqual(data[0].get("id"), test_placename09.id)  # Check first data
        self.assertEqual(data[2].get("id"), test_placename12.id)  # Check last data - should not be test_placename12

    def test_placename_geo(self):
        # Even if the geometry is non-sense, include them
        # If kind is blank or poi, include them
        test_placename15 = PlaceName.objects.create(  # Included (1)
            name="test place15",
            kind="poi",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )
        test_placename16 = PlaceName.objects.create(  # Included (2)
            name="test place16",
            kind="",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )
        # If no geometry, exclude them
        test_placename17 = PlaceName.objects.create(  # Excluded
            name="test place17",
            kind="poi",
        )

        response = self.client.get(
            "/api/placename-geo/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 2)
    
    def test_art_types_geo_api(self):
        """
        Ensure we can get the data to display on the Arts Tab Lists
        """
        # Don't show Place Names without Geom or cooridinates = [0, 0]
        test_placename18 = PlaceName.objects.create(
            name="test place18",
            kind="resource",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename19 = PlaceName.objects.create(
            name="test place19",
            kind="resource",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        test_placename20 = PlaceName.objects.create(
            name="test place20",
            kind="public_art",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename21 = PlaceName.objects.create(
            name="test place21",
            kind="public_art",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        test_placename22 = PlaceName.objects.create(
            name="test place22",
            kind="artist",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename23 = PlaceName.objects.create(
            name="test place23",
            kind="artist",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        test_placename24 = PlaceName.objects.create(
            name="test place24",
            kind="organization",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename25 = PlaceName.objects.create(
            name="test place25",
            kind="organization",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        test_placename26 = PlaceName.objects.create(
            name="test place26",
            kind="event",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename27 = PlaceName.objects.create(
            name="test place27",
            kind="event",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        test_placename28 = PlaceName.objects.create(
            name="test place28",
            kind="grant",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        test_placename29 = PlaceName.objects.create(
            name="test place29",
            kind="grant",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [0, 0]
            }""")
        )

        # Test Public Arts
        response = self.client.get(
            "/api/arts/public-art/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)  # Out of all the data created, only 1 should appear

        # Test Artists
        response = self.client.get(
            "/api/arts/artist/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)  # Out of all the data created, only 1 should appear

        # Test Organizations
        response = self.client.get(
            "/api/arts/organization/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)  # Out of all the data created, only 1 should appear

        # Test Events
        response = self.client.get(
            "/api/arts/event/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)  # Out of all the data created, only 1 should appear

        # Test Grants
        response = self.client.get(
            "/api/arts/grant/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)  # Out of all the data created, only 1 should appear

        # Test Resource
        response = self.client.get(
            "/api/arts/resource/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)  # Out of all the data created, only 1 should appear
    
    def test_artworks_geo_api(self):
        """
        Ensure we can get the data to display on the Arts Tab Lists
        """
        # Don't show Medias whose Place Name is without Geom
        test_placename30 = PlaceName.objects.create(
            name="test place30",
            kind="artist",
            geom=GEOSGeometry("""{
                "type": "Point",
                "coordinates": [1, 1]
            }""")
        )
        
        test_media1 = Media.objects.create(
            name="test media1",
            placename=test_placename30,
            is_artwork=True
        )

        response = self.client.get(
            "/api/arts/artwork/", format="json"
        )
        data = response.json()

        self.assertEqual(response.status_code, status.HTTP_200_OK)