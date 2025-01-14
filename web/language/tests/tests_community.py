from rest_framework.test import APITestCase
from rest_framework import status
from django.utils import timezone
from django.contrib.gis.geos import GEOSGeometry

from language.models import (
    Language,
    Community,
    CommunityMember,
    CommunityLanguageStats,
    Recording,
)
from users.models import User, Administrator
from web.constants import VERIFIED, REJECTED


class BaseTestCase(APITestCase):
    def setUp(self):
        FAKE_GEOM = """
            {
                "type": "Point",
                "coordinates": [
                    -126.3482666015625,
                    54.74840576223716
                ]
            }
        """
        self.point = GEOSGeometry(FAKE_GEOM)

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

        self.regular_user = User.objects.create(
            username="regular_user",
            first_name="Regular",
            last_name="User",
            email="regular@countable.ca",
        )
        self.regular_user.set_password("password")
        self.regular_user.save()

        self.test_language = Language.objects.create(name="Global Test Language")
        self.test_community = Community.objects.create(
            name="Global Test Community", point=FAKE_GEOM
        )

        self.community_admin = User.objects.create(
            username="community_admin_user",
            first_name="Community Admin",
            last_name="User",
            email="community_admin@countable.ca",
        )
        self.community_admin.set_password("password")
        self.community_admin.save()

        Administrator.objects.create(
            user=self.community_admin,
            language=self.test_language,
            community=self.test_community,
        )

        # Create a community without a point, which does not show in the list/search APIs
        self.invalid_community = Community.objects.create(name="Invalid Community")

        # Create a test stats
        self.test_stats = CommunityLanguageStats.objects.create(
            community=self.test_community,
            language=self.test_language,
            fluent_speakers=1,
            semi_speakers=1,
            active_learners=1,
        )


class CommunityAPIRouteTests(BaseTestCase):
    def test_community_geo_route_exists(self):
        """
        Ensure Community Geo API route exists
        """
        response = self.client.get("/api/community-geo/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_search_route_exists(self):
        """
        Ensure Community Search API route exists
        """
        response = self.client.get("/api/community-search/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_list_route_exists(self):
        """
        Ensure Community List API route exists
        """
        response = self.client.get("/api/community/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_list_member_to_verify_route_exists(self):
        """
        Ensure Community List Members to Verify API route exists
        """
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_member_verify_route_exists(self):
        """
        Ensure Community Member Verify API route exists
        """
        response = self.client.get("/api/community/verify_member/", format="json")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_community_member_reject_route_exists(self):
        """
        Ensure Community Member Reject API route exists
        """
        response = self.client.get("/api/community/reject_member/", format="json")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_community_detail_route_exists(self):
        """
        Ensure Community Detail API route exists
        """
        response = self.client.get(
            f"/api/community/{self.test_community.id}/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_add_audio_route_exists(self):
        """
        Ensure Community Add Audio API route exists
        """
        self.assertTrue(
            self.client.login(username="community_admin_user", password="password")
        )
        response = self.client.get(
            f"/api/community/{self.test_community.id}/add_audio/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_stats_list_route_exists(self):
        """
        Ensure Stats List API route exists
        """
        response = self.client.get("/api/stats/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_stats_detail_route_exists(self):
        """
        Ensure Stats Detail API route exists
        """
        response = self.client.get(f"/api/stats/{self.test_stats.id}/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class CommunityGeoAPITests(BaseTestCase):
    def test_community_geo(self):
        """
        Ensure Community Geo API works
        """
        response = self.client.get("/api/community-geo/", format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # By fetching "features" specifically, we're committing
        # that this API is a GEO Feature API
        data = response.json().get("features")

        # Only count 1 because the 2nd community in setUp() is invalid
        self.assertEqual(len(data), 1)

    def test_community_search(self):
        """
        Ensure Community Search API works
        """
        response = self.client.get("/api/community-search/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        data = response.json()

        # By fetching the first record, we're committing
        # that the test_community was added to the search list
        test_community = data[0]
        self.assertEqual(test_community.get("name"), "Global Test Community")


class CommunityAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.now = timezone.now()
        self.recording = Recording.objects.create(
            speaker="Test recording",
            recorder="Test recording",
            created=self.now,
            date_recorded=self.now,
        )

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
        self.assertEqual(response.data["audio_obj"]["speaker"], self.recording.speaker)
        self.assertEqual(
            response.data["audio_obj"]["recorder"], self.recording.recorder
        )

    def test_community_add_audio_for_admin(self):
        """
        Ensure we can add a community audio to a community object using an admin account.
        """
        # Must be logged in
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_community = Community(name="Test community audio")
        test_community.point = self.point
        test_community.save()

        response = self.client.patch(
            "/api/community/{}/add_audio/".format(test_community.id),
            {"recording_id": self.recording.id},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            "/api/community/{}/".format(test_community.id), format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_community.id)
        self.assertEqual(response.data["name"], "Test community audio")
        self.assertEqual(response.data["audio_obj"]["id"], self.recording.id)
        self.assertEqual(response.data["audio_obj"]["speaker"], self.recording.speaker)

    def test_community_add_audio_for_non_admin(self):
        """
        Ensure we can add a community audio to a community object.
        """
        # Must be logged in
        self.assertTrue(self.client.login(username="regular_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_community = self.test_community
        test_community.point = self.point
        test_community.save()

        response = self.client.patch(
            "/api/community/{}/add_audio/".format(test_community.id),
            {"recording_id": self.recording.id},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_community_add_audio_for_community_admin(self):
        """
        Ensure we can add a community audio to a community object using an admin account.
        """
        # Must be logged in
        self.assertTrue(
            self.client.login(username="community_admin_user", password="password")
        )

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_community = self.test_community
        test_community.point = self.point
        test_community.save()

        response = self.client.patch(
            "/api/community/{}/add_audio/".format(test_community.id),
            {"recording_id": self.recording.id},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            "/api/community/{}/".format(test_community.id), format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_community.id)
        self.assertEqual(response.data["name"], "Global Test Community")
        self.assertEqual(response.data["audio_obj"]["id"], self.recording.id)
        self.assertEqual(response.data["audio_obj"]["speaker"], self.recording.speaker)

    def test_create_community_member_post(self):
        """
        Ensure we can retrieve a newly created community member object.
        """
        test_community = Community(name="Test community 001")
        test_community.point = self.point
        test_community.save()

        self.assertTrue(self.client.login(username="admin_user", password="password"))
        response = self.client.post(
            "/api/community/{}/create_membership/".format(test_community.id),
            {
                "user_id": self.admin_user.id,
            },
            format="json",
            follow=True,
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_member_verify(self):
        """
        Ensure that CommunityMember can be VERIFIED
        """
        Administrator.objects.create(
            user=self.admin_user,
            language=self.test_language,
            community=self.test_community,
        )

        user = User.objects.create(
            username="test_user",
            first_name="Test",
            last_name="User",
            email="test_user@countable.ca",
        )

        member_to_verify = CommunityMember.create_member(
            user.id, self.test_community.id
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # member_to_verify is not yet verified so return 1 result
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # Verify member_to_verify
        response = self.client.post(
            "/api/community/verify_member/",
            {
                "user_id": user.id,
                "community_id": self.test_community.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        member = CommunityMember.objects.get(pk=member_to_verify.id)
        self.assertEqual(member.status, VERIFIED)

        # member_to_verify is now verified so return 0 results
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    def test_member_reject(self):
        """
        Ensure that CommunityMember can be REJECTED
        """
        Administrator.objects.create(
            user=self.admin_user,
            language=self.test_language,
            community=self.test_community,
        )

        user = User.objects.create(
            username="test_user",
            first_name="Test",
            last_name="User",
            email="test_user@countable.ca",
        )

        member_to_reject = CommunityMember.create_member(
            user.id, self.test_community.id
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # member_to_reject is not yet rejected so return 1 result
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # Reject member_to_reject
        response = self.client.post(
            "/api/community/reject_member/",
            {
                "user_id": user.id,
                "community_id": self.test_community.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        member = CommunityMember.objects.get(pk=member_to_reject.id)
        self.assertEqual(member.status, REJECTED)

        # member_to_reject is now rejected so return 0 results
        response = self.client.get(
            "/api/community/list_member_to_verify/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
