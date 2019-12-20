from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from django.utils import timezone

from users.models import User, Administrator

from language.models import (
    Language, 
    PlaceName, 
    PlaceNameCategory, 
    Community, 
    CommunityMember, 
    Champion, 
    Media, 
    Favourite,
    Notification,
    Recording,
)


class BaseTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create(
            username="testuser001",
            first_name="Test",
            last_name="user 001",
            email="test@countable.ca",
            is_staff=True,
            is_superuser=True,
        )
        self.user.set_password("password")
        self.user.save()


class PlaceNameAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.now = timezone.now()

        self.community = Community.objects.create(name="Test Community")
        self.community2 = Community.objects.create(name="Test Community 02")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.language2 = Language.objects.create(name="Test Language 02")
        self.category = PlaceNameCategory.objects.create(name="Test Category", icon_name="icon")
        
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
            speaker = "Test recording",
            recorder = "Test recording",
            created = self.now,
            date_recorded = self.now,
        )

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_placename_detail(self):
        """
		Ensure we can retrieve a newly created placename object.
		"""
        test_placename = PlaceName.objects.create(
            name = "Test placename 001", 
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
            name = "Test placename 001", 
            audio = self.recording,
            audio_name = "string",
            audio_description = "string",
            community = self.community,
            language = self.language1,
            category = self.category,
        )
        response = self.client.get(
            "/api/placename/{}/".format(test_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Test placename 001")
        self.assertEqual(response.data["audio_name"], "string")
        self.assertEqual(response.data["audio_description"], "string")
        self.assertEqual(response.data["audio"], self.recording.id)
        self.assertEqual(response.data["community"], self.community.id)        
        self.assertEqual(response.data["language"], self.language1.id)        
        self.assertEqual(response.data["category"], self.category.id)        
        # self.assertEqual(response.data["audio_obj"]["id"], self.recording.id)
        self.assertEqual(response.data["audio_obj"]["speaker"], self.recording.speaker)
        self.assertEqual(response.data["audio_obj"]["recorder"], self.recording.recorder)

    def test_placename_list_not_logged_in(self):
        """
		Ensure placename list API brings newly created data
		"""
        # VERIFIED Placename
        test_placename01 = PlaceName.objects.create(
            name = "test place01",
            community = self.community,
            language = self.language1,
            status=PlaceName.VERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED Placename
        test_placename02 = PlaceName.objects.create(
            name = "test place02",
            community = self.community,
            language = self.language1,
            status=PlaceName.UNVERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED Placename
        test_placename03 = PlaceName.objects.create(
            name = "test place03",
            community = self.community,
            language = self.language1,
            status=PlaceName.REJECTED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # FLAGGED Placename
        test_placename04 = PlaceName.objects.create(
            name = "test place04",
            community = self.community,
            language = self.language1,
            status=PlaceName.FLAGGED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_placename_list_logged_in_creator(self):
        """
		Ensure placename list API brings newly created data
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED Placename
        test_placename01 = PlaceName.objects.create(
            name = "test place01",
            creator = self.user,
            community = self.community,
            language = self.language1,
            community_only = True,
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED Placename
        test_placename02 = PlaceName.objects.create(
            name = "test place02",
            creator = self.user,
            community = self.community2,
            language = self.language1,
            community_only = True,
            status=PlaceName.UNVERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED Placename
        test_placename03 = PlaceName.objects.create(
            name = "test place03",
            creator=self.user,
            community = self.community,
            language = self.language1,
            community_only = True,
            status=PlaceName.REJECTED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED Placename
        test_placename04 = PlaceName.objects.create(
            name = "test place04",
            creator=self.user,
            community = self.community2,
            language = self.language1,
            community_only = True,
            status=PlaceName.FLAGGED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # REJECTED Placename from another user
        test_placename05 = PlaceName.objects.create(
            name = "test place05",
            creator = self.user2,
            community = self.community,
            language = self.language1,
            status=PlaceName.REJECTED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_placename_list_logged_in_member(self):
        """
		Ensure placename list API brings newly created data
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED COMMUNITY_ONLY Placename
        test_placename01 = PlaceName.objects.create(
            name = "test place01",
            community = self.community,
            language = self.language1,
            community_only = True,
            status=PlaceName.VERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # UNVERIFIED CommunityMember MATCHING users's community
        member_same01 = CommunityMember.objects.create(
            user = self.user,
            community = self.community,
            status=CommunityMember.UNVERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # After the community member is VERIFIED
        member_same01.status=CommunityMember.VERIFIED
        member_same01.save()
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED COMMUNITY_ONLY Placename
        test_placename02 = PlaceName.objects.create(
            name = "test place02",
            community = self.community,
            language = self.language1,
            community_only = True,
            status=PlaceName.UNVERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED COMMUNITY_ONLY Placename
        test_placename03 = PlaceName.objects.create(
            name = "test place03",
            community = self.community,
            language = self.language1,
            community_only = True,
            status=PlaceName.REJECTED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED COMMUNITY_ONLY Placename
        test_placename04 = PlaceName.objects.create(
            name = "test place04",
            community = self.community,
            language = self.language1,
            community_only = True,
            status=PlaceName.FLAGGED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # VERIFIED COMMUNITY_ONLY Placename from another community
        test_placename05 = PlaceName.objects.create(
            name = "test place05",
            community = self.community2,
            language = self.language1,
            community_only = True,
            status=PlaceName.VERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_placename_list_logged_in_administrator(self):
        """
		Ensure placename list API brings newly created data
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED COMMUNITY_ONLY Placename
        test_placename01 = PlaceName.objects.create(
            name = "test place01",
            community = self.community,
            language = self.language1,
            community_only = True,
            status=PlaceName.VERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # Administrator of the pair language/community
        admin = Administrator.objects.create(
            user=self.user, 
            community=self.community,
            language=self.language1, 
        )

        # After the user became an Administrator
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED COMMUNITY_ONLY Placename
        test_placename02 = PlaceName.objects.create(
            name = "test place02",
            community = self.community2,
            language = self.language1,
            community_only = True,
            status=PlaceName.UNVERIFIED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # After changing the placename to the Administrator community
        test_placename02.community = self.community
        test_placename02.save()

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED COMMUNITY_ONLY Placename
        test_placename03 = PlaceName.objects.create(
            name = "test place03",
            community = self.community2,
            language = self.language1,
            community_only = True,
            status=PlaceName.REJECTED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # After changing the placename to the Administrator community
        test_placename03.community = self.community
        test_placename03.save()

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED COMMUNITY_ONLY Placename
        test_placename04 = PlaceName.objects.create(
            name = "test place04",
            community = self.community2,
            language = self.language1,
            community_only = True,
            status=PlaceName.FLAGGED
        )
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # After changing the placename to the Administrator community
        test_placename04.community = self.community
        test_placename04.save()

        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_placename_list_to_verify(self):
        """
		Ensure placename list API brings newly created data which needs to be verified
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language1, 
            community=self.community
        )

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # VERIFIED Placename MATCHING user's language. It MUST NOT be returned by the route
        test_placename01 = PlaceName.objects.create(
            name = "test place01",
            community = self.community,
            language = self.language1,
            status=PlaceName.VERIFIED
        )
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
        
        # UNVERIFIED Placename MATCHING user's language. It MUST be returned by the route
        test_placename02 = PlaceName.objects.create(
            name = "test place02",
            community = self.community,
            language = self.language1,
            status=PlaceName.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        assert len(response.data[0]['status_reason']) > 0
        
        # FLAGGED Placename MATCHING user's language. It MUST be returned by the route
        test_placename03 = PlaceName.objects.create(
            name = "test place03",
            community = self.community,
            language = self.language1,
            status=PlaceName.FLAGGED,
            status_reason = "string"
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        
        # UNVERIFIED Placename NOT MATCHING user's language. It MUST NOT be returned by the route
        test_placename04 = PlaceName.objects.create(
            name = "test place04",
            community = self.community,
            language = self.language2,
            status=PlaceName.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_placename_post(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/placename/",
            {
                "name": "test place",
                "kind": "string",
                "other_names": "string",
                "common_name": "string",
                "community_only": True,
                "description": "string",
                "category": self.category.id,
                "community": self.community.id,
                "language": self.language1.id,
                "audio": self.recording.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.name, "test place")
        self.assertEqual(place.community_id, self.community.id)
        self.assertEqual(place.language_id, self.language1.id)
        self.assertEqual(place.category_id, self.category.id)
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
        self.assertEqual(place.community_id, self.community.id)
        self.assertEqual(place.language_id, self.language1.id)
        self.assertEqual(place.category_id, self.category.id)
        self.assertEqual(place.audio_id, self.recording.id)

    def test_placename_verify(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.community = self.community
        placename.language = self.language1
        placename.save()

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/verify/".format(created_id),
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, PlaceName.VERIFIED)

    def test_placename_reject(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.creator = self.user
        placename.community = self.community
        placename.language = self.language1
        placename.save()

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/reject/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, PlaceName.REJECTED)

    def test_placename_flag(self):
        
        placename = PlaceName()
        placename.name = "test place"
        placename.creator = self.user
        placename.community = self.community
        placename.language = self.language1
        placename.save()

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/flag/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, PlaceName.FLAGGED)

    def test_post_only_required_fields(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/placename/",
            {
                "name": "test place",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.name, "test place")
