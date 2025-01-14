from rest_framework.test import APITestCase
from rest_framework import status


from language.models import (
    Language,
    PlaceName,
    Community,
    CommunityMember,
    Media,
)
from users.models import User, Administrator
from web.constants import (
    FLAGGED,
    UNVERIFIED,
    VERIFIED,
    REJECTED,
)


class BaseTestCase(APITestCase):
    def setUp(self):
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

        # Create a regular user with no privileges
        self.regular_user = User.objects.create(
            username="regular_user",
            first_name="Regular",
            last_name="User",
            email="regular@countable.ca",
        )
        self.regular_user.set_password("password")
        self.regular_user.save()


class MediaAPIRouteTests(BaseTestCase):
    def setUp(self):
        super().setUp()

        self.verified_media = Media.objects.create(
            name="Verified Media",
            file_type="string",
            status=VERIFIED,
        )

        self.unverified_media = Media.objects.create(
            name="Unverified Media",
            file_type="string",
            status=UNVERIFIED,
        )

    def test_media_list_route_exists(self):
        """
        Ensure Media List API route exists
        """
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_media_list_to_verify_route_exists(self):
        """
        Ensure Media List to Verify API route exists
        """
        self.assertTrue(self.client.login(username="admin_user", password="password"))
        response = self.client.get(f"/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_media_detail_route_exists(self):
        """
        Ensure Media Detail API route exists
        """
        response = self.client.get(
            f"/api/media/{self.verified_media.id}/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_media_flag_route_exists(self):
        """
        Ensure Media Detail API route exists
        """
        response = self.client.get(
            f"/api/media/{self.unverified_media.id}/flag/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_reject_route_exists(self):
        """
        Ensure Media Detail API route exists
        """
        response = self.client.get(
            f"/api/media/{self.unverified_media.id}/reject/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_verify_route_exists(self):
        """
        Ensure Media Detail API route exists
        """
        response = self.client.get(
            f"/api/media/{self.unverified_media.id}/verify/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)


class MediaAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community1 = Community.objects.create(name="Test Community 1")
        self.community2 = Community.objects.create(name="Test Community 2")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.language2 = Language.objects.create(name="Test Language 02")

    # ONE TEST TESTS ONLY ONE SCENARIO
    def test_media_list_not_logged_in(self):
        """
        Ensure media list API brings newly created data for not logged in users
        """
        # VERIFIED Placename
        placename1 = PlaceName.objects.create(
            name="test place01", language=self.language1, status=VERIFIED
        )
        placename1.communities.set([self.community1])

        # VERIFIED Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=UNVERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=REJECTED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # FLAGGED Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=FLAGGED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_media_list_logged_in_creator(self):
        """
        Ensure media list API brings newly created data of a CREATOR (who creates a media)
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED Placename
        placename1 = PlaceName.objects.create(
            name="test place01",
            creator=self.admin_user,
            language=self.language1,
        )
        placename1.communities.set([self.community1])

        # VERIFIED Media
        Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED Media
        Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=UNVERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED Media
        Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=REJECTED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED Media
        Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=FLAGGED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # REJECTED Media from another user
        Media.objects.create(
            name="test media01",
            creator=self.regular_user,
            file_type="string",
            placename=placename1,
            status=REJECTED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # FLAGGED Media from another user
        Media.objects.create(
            name="test media01",
            creator=self.regular_user,
            file_type="string",
            placename=placename1,
            status=FLAGGED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_media_list_logged_in_member(self):
        """
        Ensure media list API brings newly created data for a COMMUNITY MEMBER
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED Placename
        placename1 = PlaceName.objects.create(
            name="test place01", language=self.language1, status=VERIFIED
        )
        placename1.communities.set([self.community1])

        # VERIFIED COMMUNITY_ONLY Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # UNVERIFIED CommunityMember MATCHING users's community
        member_same01 = CommunityMember.objects.create(
            user=self.admin_user, community=self.community1, status=UNVERIFIED
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # After the community member is VERIFIED
        member_same01.status = VERIFIED
        member_same01.save()
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED COMMUNITY_ONLY Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # REJECTED COMMUNITY_ONLY Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # FLAGGED COMMUNITY_ONLY Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # VERIFIED Media from another community
        Media.objects.create(
            name="test media01",
            file_type="string",
            community=self.community2,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

        # VERIFIED Placename from another community
        placename2 = PlaceName.objects.create(
            name="test place02", language=self.language1, status=VERIFIED
        )
        placename2.communities.set([self.community2])

        # VERIFIED Media from another placename from another community
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename2,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_media_list_logged_in_administrator(self):
        """
        Ensure media list API brings newly created data from an ADMINISTRATOR
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="regular_user", password="password"))

        # No media yet
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # VERIFIED COMMUNITY_ONLY Placename
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
            community_only=True,
            status=VERIFIED,
        )
        placename1.communities.set([self.community1])

        # VERIFIED COMMUNITY_ONLY Media
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            community_only=True,
            status=VERIFIED,
        )

        # 1 Media is added, but it's not in the user's community
        # Since media01 has community_only=True, don't return it
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # Administrator of the pair language/community
        Administrator.objects.create(
            user=self.regular_user,
            community=self.community1,
            language=self.language1,
        )

        # After the user became an Administrator for media01's community,
        # media01 will now appear in the media list
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # UNVERIFIED COMMUNITY_ONLY Placename
        placename2 = PlaceName.objects.create(
            name="test place02",
            language=self.language1,
            community_only=True,
            status=UNVERIFIED,
        )
        placename2.communities.set([self.community2])

        # VERIFIED COMMUNITY_ONLY Media
        Media.objects.create(
            name="test media02",
            file_type="string",
            placename=placename2,
            community_only=True,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # After changing the placename to the Administrator community
        placename2.communities.set([self.community1])

        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_media_post_with_community(self):
        """
        Ensure media API POST method API works
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="regular_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/media/",
            {
                "name": "Test media 002",
                "file_type": "image",
                "url": "https://google.com",
                "status": UNVERIFIED,
                "community": self.community1.id,
                "community_only": True,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.name, "Test media 002")
        self.assertEqual(media.file_type, "image")
        self.assertEqual(media.url, "https://google.com")
        self.assertEqual(media.status, UNVERIFIED)
        self.assertEqual(media.community.id, self.community1.id)

    def test_media_post_with_placename(self):
        """
        Ensure media API POST method API works
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="regular_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.other_names = "string"
        placename.common_name = "string"
        placename.community_only = True
        placename.description = "string"
        placename.language = self.language1
        placename.save()
        placename.communities.set([self.community1])

        response = self.client.post(
            "/api/media/",
            {
                "name": "Test media 001",
                "file_type": "image",
                "url": "https://google.com",
                "status": UNVERIFIED,
                "placename": placename.id,
                "community_only": True,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.name, "Test media 001")
        self.assertEqual(media.file_type, "image")
        self.assertEqual(media.url, "https://google.com")
        self.assertEqual(media.status, UNVERIFIED)
        self.assertEqual(media.placename.id, placename.id)

    def test_repeated_names_for_media(self):
        # Create media named "test media"
        Media.objects.create(
            name="test media",
            file_type="string",
        )

        # Create another with the same name
        Media.objects.create(
            name="test media",
            file_type="string",
        )

        matching_media_count = Media.objects.filter(name="test media").count()
        self.assertEqual(matching_media_count, 2)

    def test_list_to_verify(self):
        """
        Ensure media list API brings newly created data which needs to be verified
        """
        Administrator.objects.create(
            user=self.admin_user, language=self.language1, community=self.community1
        )

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01", language=self.language1
        )
        placename1.communities.set([self.community1])

        # PlaceName out of the same language and community as the user (language admin)
        placename2 = PlaceName.objects.create(
            name="test place02", language=self.language2
        )
        placename2.communities.set([self.community2])

        # VERIFIED Media MATCHING admin's language. It MUST NOT be returned by the route
        Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=VERIFIED,
        )
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # UNVERIFIED Media MATCHING admin's language. It MUST be returned by the route
        Media.objects.create(
            name="test media02",
            file_type="string",
            placename=placename1,
            status=UNVERIFIED,
            status_reason="string",
        )
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        assert len(response.data[0]["status_reason"]) > 0

        # FLAGGED Media MATCHING admin's language. It MUST be returned by the route
        Media.objects.create(
            name="test media03",
            file_type="string",
            placename=placename1,
            status=FLAGGED,
            status_reason="string",
        )
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # UNVERIFIED Media NOT MATCHING admin's language. It MUST NOT be returned by the route
        Media.objects.create(
            name="test media04",
            file_type="string",
            placename=placename2,
            status=UNVERIFIED,
            status_reason="string",
        )
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # UNVERIFIED Media MATCHING admin's community. It MUST be returned by the route
        self.community1.languages.add(self.language1)
        self.community1.save()

        Media.objects.create(
            name="test media02",
            file_type="string",
            community=self.community1,
            status=UNVERIFIED,
            status_reason="string",
        )
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # UNVERIFIED Media MATCHING admin's community. It MUST be returned by the route
        self.community2.languages.add(self.language1)
        self.community2.save()

        Media.objects.create(
            name="test media02",
            file_type="string",
            community=self.community2,
            status=UNVERIFIED,
            status_reason="string",
        )
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)

    def test_verify_media_unauthorized(self):
        # Check we're not logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], False)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
        )

        test_media = Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=FLAGGED,
            creator=self.regular_user,
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/verify/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, FLAGGED)

    def test_verify_media(self):
        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
        )

        test_media = Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=FLAGGED,
            creator=self.regular_user,
        )

        created_id = test_media.id

        # Now update it.
        response = self.client.patch(
            "/api/media/{}/verify/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, VERIFIED)

    def test_reject_media_unauthorized(self):
        # Check we're not logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], False)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
        )

        test_media = Media.objects.create(
            name="test media01",
            file_type="string",
            placename=placename1,
            status=FLAGGED,
            creator=self.regular_user,
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/reject/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, FLAGGED)

    def test_reject_media(self):
        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
        )

        test_media = Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=UNVERIFIED,
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/reject/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, REJECTED)

    def test_flag_unverified_media(self):
        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
        )

        test_media = Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=UNVERIFIED,
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/flag/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, FLAGGED)
        self.assertEqual(media.status_reason, "test reason status")

    def test_flag_verified_media(self):
        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name="test place01",
            language=self.language1,
        )

        test_media = Media.objects.create(
            name="test media01",
            creator=self.admin_user,
            file_type="string",
            placename=placename1,
            status=VERIFIED,
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/flag/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        data = response.json()

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(data.get("message"), "Media has already been verified.")

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, VERIFIED)

    def test_media_delete(self):
        """
        Ensure media API DELETE method API works
        """
        test_media = Media.objects.create(name="Test media 001", file_type="image")
        self.assertTrue(self.client.login(username="admin_user", password="password"))
        response = self.client.delete(
            "/api/media/{}/".format(test_media.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_placename_medias(self):
        """
        Ensure media is ordered in reverse chronological order.
        """
        test_placename_with_media = PlaceName.objects.create(
            name="Test PlaceName with Media"
        )
        test_media01 = Media.objects.create(
            name="Test media 01", file_type="image", placename=test_placename_with_media
        )
        test_media02 = Media.objects.create(
            name="Test media 02", file_type="image", placename=test_placename_with_media
        )
        test_media03 = Media.objects.create(
            name="Test media 03", file_type="image", placename=test_placename_with_media
        )
        test_media04 = Media.objects.create(
            name="Test media 04", file_type="image", placename=test_placename_with_media
        )

        response = self.client.get(
            "/api/placename/{}/".format(test_placename_with_media.id), format="json"
        )

        data = response.json()

        # Check if medias are added in the PlaceName media list
        self.assertTrue(len(data.get("medias")) == 4)
        self.assertEqual(data.get("medias")[0].get("id"), test_media04.id)
        self.assertEqual(data.get("medias")[1].get("id"), test_media03.id)
        self.assertEqual(data.get("medias")[2].get("id"), test_media02.id)
        self.assertEqual(data.get("medias")[3].get("id"), test_media01.id)

    def test_media_order(self):
        """
        Ensure media is ordered in reverse chronological order.
        """

        test_placename_with_media = PlaceName.objects.create(
            name="Test PlaceName with Media"
        )
        Media.objects.create(
            name="Test media 01", file_type="image", placename=test_placename_with_media
        )
        Media.objects.create(
            name="Test media 02", file_type="image", placename=test_placename_with_media
        )
        Media.objects.create(
            name="Test media 03", file_type="image", placename=test_placename_with_media
        )
        Media.objects.create(
            name="Test media 04", file_type="image", placename=test_placename_with_media
        )

        response1 = self.client.get("/api/media/", format="json")

        data1 = response1.json()

        response2 = self.client.get(
            "/api/placename/{}/".format(test_placename_with_media.id), format="json"
        )

        data2 = response2.json()

        # Check if media is ordered properly in the media list API
        self.assertTrue(data1[0].get("id") > data1[3].get("id"))

        # Check if media is ordered properly in the PlaceName detail API
        self.assertTrue(
            data2.get("medias")[0].get("id") > data2.get("medias")[3].get("id")
        )
