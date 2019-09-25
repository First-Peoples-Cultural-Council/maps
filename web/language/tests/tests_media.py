from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

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
        

class MediaAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community1 = Community.objects.create(name="Test Community 1")
        self.community2 = Community.objects.create(name="Test Community 2")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.language2 = Language.objects.create(name="Test Language 02")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    # def test_media_detail_route_not_allowed(self):
    #     """
	# 	Ensure media Detail API route does not exist
	# 	"""
    #     response = self.client.get("/api/media/0/", format="json")
    #     self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_list_route_does_not_allowed(self):
        """
		Ensure media list API route does not exist
		"""
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_post_with_community(self):
        """
		Ensure media API POST method API works
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)
        
        response = self.client.post(
            "/api/media/",
            {
                "name": "Test media 002", 
                "file_type": "image", 
                "url": "https://google.com", 
                "status" : Media.UNVERIFIED, 
                "community": self.community1.id,
                "community_only" : True, 
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.name, "Test media 002")
        self.assertEqual(media.file_type, "image")
        self.assertEqual(media.url, "https://google.com")
        self.assertEqual(media.status, Media.UNVERIFIED)
        self.assertEqual(media.community.id, self.community1.id)

    def test_media_post_with_placename(self):
        """
		Ensure media API POST method API works
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)
        
        placename = PlaceName()
        placename.name = "test place"
        placename.other_names = "string"
        placename.common_name = "string"
        placename.community_only = True
        placename.description = "string"
        placename.community = self.community1
        placename.language = self.language1
        placename.save()

        response = self.client.post(
            "/api/media/",
            {
                "name": "Test media 001", 
                "file_type": "image", 
                "url": "https://google.com", 
                "status" : Media.UNVERIFIED, 
                "placename": placename.id,
                "community_only" : True, 
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.name, "Test media 001")
        self.assertEqual(media.file_type, "image")
        self.assertEqual(media.url, "https://google.com")
        self.assertEqual(media.status, Media.UNVERIFIED)
        self.assertEqual(media.placename.id, placename.id)

    def test_repeated_names_for_media(self):
        
        test_media1 = Media.objects.create(
            name = "test media",
            file_type = "string",
        )
        
        test_media2 = Media.objects.create(
            name = "test media",
            file_type = "string",
        )

        self.assertEqual(1, 1)

    def test_list_to_verify(self):
        """
		Ensure media list API brings newly created data which needs to be verified
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language1, 
            community=self.community1
        )

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
            community = self.community1,
        )

        # PlaceName out of the same language as the user (language admin)
        placename2 = PlaceName.objects.create(
            name = "test place02",
            language = self.language2,
            community = self.community1,
        )

        # VERIFIED Media MATCHING admin's language. It MUST NOT be returned by the route
        media_same01 = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.VERIFIED
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
        
        # UNVERIFIED Media MATCHING admin's language. It MUST be returned by the route
        media_same02 = Media.objects.create(
            name = "test media02",
            file_type = "string",
            placename = placename1,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        assert len(response.data[0]['status_reason']) > 0
        
        # FLAGGED Media MATCHING admin's language. It MUST be returned by the route
        media_diff01 = Media.objects.create(
            name = "test media03",
            file_type = "string",
            placename = placename1,
            status=Media.FLAGGED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        
        # UNVERIFIED Media NOT MATCHING admin's language. It MUST NOT be returned by the route
        test_media04 = Media.objects.create(
            name = "test media04",
            file_type = "string",
            placename = placename2,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        
        # UNVERIFIED Media MATCHING admin's community. It MUST be returned by the route
        self.community1.languages.add(self.language1)
        self.community1.save()

        media_same03 = Media.objects.create(
            name = "test media02",
            file_type = "string",
            community = self.community1,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)
        
        # UNVERIFIED Media MATCHING admin's community. It MUST be returned by the route
        self.community2.languages.add(self.language1)
        self.community2.save()
        
        media_same04 = Media.objects.create(
            name = "test media02",
            file_type = "string",
            community = self.community2,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

    def test_verify_media(self):

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.FLAGGED
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/verify/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, Media.VERIFIED)

    def test_reject_media(self):

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.UNVERIFIED
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
        self.assertEqual(media.status, Media.REJECTED)

    def test_flag_unverified_media(self):

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.UNVERIFIED
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
        self.assertEqual(media.status, Media.FLAGGED)
        self.assertEqual(media.status_reason, "test reason status")

    def test_flag_verified_media(self):

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.VERIFIED
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
        self.assertEqual(media.status, Media.VERIFIED)

    def test_media_delete(self):
        """
		Ensure media API DELETE method API works
		"""
        test_media = Media.objects.create(name="Test media 001", file_type="image")
        response = self.client.delete(
            "/api/media/{}/".format(test_media.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)