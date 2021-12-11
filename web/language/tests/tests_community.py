from django import test
from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from django.utils import timezone

from users.models import User, Administrator
from django.contrib.gis.geos import GEOSGeometry, Point

from language.models import (
    Language,
    Community,
    CommunityMember,
    Champion,
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

        self.user2 = User.objects.create(
            username="testuser002",
            first_name="Test",
            last_name="user 002",
            email="test2@countable.ca"
        )
        self.user2.set_password("password")
        self.user2.save()

        self.user3 = User.objects.create(
            username="testuser003",
            first_name="Test",
            last_name="user 003",
            email="test2@countable.ca",
        )
        self.user3.set_password("password")
        self.user3.save()

        self.test_language = Language.objects.create(
            name="Global Test Language")
        self.test_community = Community.objects.create(
            name="Global Test Community")
        community_admin = Administrator.objects.create(
            user=self.user3,
            language=self.test_language,
            community=self.test_community
        )
        self.FAKE_GEOM = """
            {
                "type": "Point",
                "coordinates": [
                    -126.3482666015625,
                    54.74840576223716
                ]
            }
        """


class CommunityGeoAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()

        self.community1 = Community.objects.create(
            name="Test Community 01", point=GEOSGeometry(self.FAKE_GEOM))
        self.community2 = Community.objects.create(name="Test Community 02")

    # ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_community_geo_route_exists(self):
        """
        Ensure Community Geo API route exists
        """
        response = self.client.get("/api/community-geo/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    # Search API for Community
    def test_community_search_route_exists(self):
        """
        Ensure Community Search API route exists
        """
        response = self.client.get("/api/community-search/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_community_geo(self):
        """
        Ensure Community Geo API works
        """
        response = self.client.get(
            "/api/community-geo/", format="json"
        )
        # By fetching "features" specifically, we're committing
        # that this API si a GEO Feature API
        data = response.json().get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)


class CommunityAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.now = timezone.now()

        self.community3 = Community.objects.create(name="Test Community 03")
        self.community4 = Community.objects.create(name="Test Community 04")
        self.community5 = Community.objects.create(name="Test Community 05")
        self.language = Language.objects.create(name="Test Language")
        self.point = GEOSGeometry(self.FAKE_GEOM)

        self.recording = Recording.objects.create(
            speaker="Test recording",
            recorder="Test recording",
            created=self.now,
            date_recorded=self.now,
        )

    # ONE TEST TESTS ONLY ONE SCENARIO

    def test_community_detail(self):
        """
        Ensure we can retrieve a newly created community object.
        """

        test_community = Community(name="Test community 001")
        test_community.point = self.point
        test_community.audio = self.recording
        test_community.save()

        response = self.client.get(
            "/api/community/{}/".format(test_community.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_community.id)
        self.assertEqual(response.data["name"], "Test community 001")
        self.assertEqual(response.data["audio"], self.recording.id)
        self.assertEqual(response.data["audio_obj"]
                         ["speaker"], self.recording.speaker)
        self.assertEqual(response.data["audio_obj"]
                         ["recorder"], self.recording.recorder)

    def test_community_list_route_exists(self):
        """
        Ensure community list API route exists
        """
        response = self.client.get("/api/community/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_add_audio_for_admin(self):
        """
        Ensure we can add a community audio to a community object using an admin account.
        """
        # Must be logged in
        self.assertTrue(self.client.login(
            username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_community = Community(name="Test community audio")
        test_community.point = self.point
        test_community.save()

        response = self.client.patch(
            "/api/community/{}/add_audio/".format(test_community.id),
            {
                "recording_id": self.recording.id
            },
            format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            "/api/community/{}/".format(test_community.id), format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_community.id)
        self.assertEqual(response.data["name"], "Test community audio")
        self.assertEqual(response.data["audio_obj"]["id"], self.recording.id)
        self.assertEqual(response.data["audio_obj"]
                         ["speaker"], self.recording.speaker)

    def test_community_add_audio_for_non_admin(self):
        """
        Ensure we can add a community audio to a community object.
        """
        # Must be logged in
        self.assertTrue(self.client.login(
            username="testuser002", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_community = self.test_community
        test_community.point = self.point
        test_community.save()

        response = self.client.patch(
            "/api/community/{}/add_audio/".format(test_community.id),
            {
                "recording_id": self.recording.id
            },
            format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_community_add_audio_for_community_admin(self):
        """
        Ensure we can add a community audio to a community object using an admin account.
        """
        # Must be logged in
        self.assertTrue(self.client.login(
            username="testuser003", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_community = self.test_community
        test_community.point = self.point
        test_community.save()

        response = self.client.patch(
            "/api/community/{}/add_audio/".format(test_community.id),
            {
                "recording_id": self.recording.id
            },
            format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            "/api/community/{}/".format(test_community.id), format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_community.id)
        self.assertEqual(response.data["name"], "Global Test Community")
        self.assertEqual(response.data["audio_obj"]["id"], self.recording.id)
        self.assertEqual(response.data["audio_obj"]
                         ["speaker"], self.recording.speaker)

    def test_create_community_member_post(self):
        """
        Ensure we can retrieve a newly created community member object.
        """
        test_community = Community(name="Test community 001")
        test_community.point = self.point
        test_community.save()

        self.assertTrue(self.client.login(username="testuser001", password="password"))
        response = self.client.post(
            "/api/community/{}/create_membership/".format(test_community.id),
            {
                "user_id": self.user.id,
            },
            format="json",
            follow=True
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_member_list_to_verify(self):
        """
        Ensure CommunityMember list API brings newly created data which needs to be verified
        """
        admin = Administrator.objects.create(
            user=self.user,
            language=self.language,
            community=self.community3
        )

        user_member01 = User.objects.create(
            username="testmember001",
            first_name="Test",
            last_name="member 001",
            email="testmember001@countable.ca",
        )

        user_member02 = User.objects.create(
            username="testmember002",
            first_name="Test",
            last_name="member 002",
            email="testmember002@countable.ca",
        )

        user_member03 = User.objects.create(
            username="testmember003",
            first_name="Test",
            last_name="member 003",
            email="testmember003@countable.ca",
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(
            username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # VERIFIED CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        member_same01 = CommunityMember.objects.create(
            user=user_member01,
            community=self.community3,
            status=CommunityMember.VERIFIED
        )
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 0

        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same02 = CommunityMember.create_member(
            user_member02.id, self.community3.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 1

        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same03 = CommunityMember.create_member(
            user_member03.id, self.community3.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 2

        # AFTER REJECTED CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        CommunityMember.reject_member(member_same02.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 1

        # AFTER VERIFYING CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        CommunityMember.verify_member(member_same03.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 0

        # UNVERIFIED CommunityMember NOT MATCHING admin's community. It MUST NOT be returned by the route
        member_diff = CommunityMember.create_member(
            user_member01.id, self.community4.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 0

        # ADDING ANOTHER ADMIN, previously UNVERIFIED CommunityMember now MATCHES admin's community.
        # It MUST be returned by the route
        admin = Administrator.objects.create(
            user=self.user,
            language=self.language,
            community=self.community4
        )
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 1

    def test_member_verify(self):
        """
                Ensure that CommunityMember can be VERIFIED
                """
        admin = Administrator.objects.create(
            user=self.user,
            language=self.language,
            community=self.community3
        )

        user_member01 = User.objects.create(
            username="testmember001",
            first_name="Test",
            last_name="member 001",
            email="testmember001@countable.ca",
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(
            username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same01 = CommunityMember.create_member(
            user_member01.id, self.community3.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # VERIFYING CommunityMember
        response = self.client.post(
            "/api/community/verify_member/",
            {
                "user_id": user_member01.id,
                "community_id": self.community3.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        member = CommunityMember.objects.get(pk=member_same01.id)
        self.assertEqual(member.status, CommunityMember.VERIFIED)

        # AFTER VERIFYING CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    def test_member_reject(self):
        """
        Ensure that CommunityMember can be REJECTED
        """
        admin = Administrator.objects.create(
            user=self.user,
            language=self.language,
            community=self.community3
        )

        user_member01 = User.objects.create(
            username="testmember001",
            first_name="Test",
            last_name="member 001",
            email="testmember001@countable.ca",
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(
            username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same01 = CommunityMember.create_member(
            user_member01.id, self.community3.id)
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # VERIFYING CommunityMember
        response = self.client.post(
            "/api/community/reject_member/",
            {
                "user_id": user_member01.id,
                "community_id": self.community3.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        member = CommunityMember.objects.get(pk=member_same01.id)
        self.assertEqual(member.status, CommunityMember.REJECTED)

        # AFTER VERIFYING CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    # def test_create_self_member(self):
    #     response = self.client.get("/api/community/create_self_membership")


class ChampionAPITests(APITestCase):

    # ONE TEST TESTS ONLY ONE SCENARIO

    def test_champion_detail(self):
        """
        Ensure we can retrieve a newly created champion object.
        """
        test_champion = Champion.objects.create(name="Test champion 001")
        response = self.client.get(
            "/api/champion/{}/".format(test_champion.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_champion_list_route_exists(self):
        """
        Ensure champion list API route exists
        """
        response = self.client.get("/api/champion/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
