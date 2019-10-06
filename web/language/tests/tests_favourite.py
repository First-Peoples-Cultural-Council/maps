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


class FavouriteAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.place = PlaceName.objects.create(name="Test place 001")
        self.media = Media.objects.create(name="Test media 001")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_detail_with_placename(self):
        """
		Ensure we can retrieve a newly created Favourite object.
		"""
        test_favourite = Favourite.objects.create(user=self.user, place=self.place, name="test favourite")
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['place'], self.place.id)

    def test_detail_with_media(self):
        """
		Ensure we can retrieve a newly created Favourite object.
		"""
        test_favourite = Favourite.objects.create(user=self.user, media=self.media, name="test favourite")
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['media'], self.media.id)

    def test_favourite_list_route_exists(self):
        """
		Ensure Favourite list API route exists
		"""
        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_favourite_placename_post(self):
        """
    	Ensure Favourite API POST method API works
    	"""
        self.client.login(username="testuser001", password="password")
        
        response = self.client.post(
            "/api/favourite/",
            {"place": self.place.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        response = self.client.get(
            "/api/favourite/{}/".format(created_id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['place'], self.place.id)
        self.assertEqual(response.data['placename_obj']['id'], self.place.id)

    def test_favourite_placename_redundant_post(self):
        """
    	Ensure Favourite API POST method API works
    	"""
        self.client.login(username="testuser001", password="password")
        
        response = self.client.post(
            "/api/favourite/",
            {"place": self.place.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        
        response = self.client.post(
            "/api/favourite/",
            {"place": self.place.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)

    def test_favourite_placename_delete(self):
        """
		Ensure Favourite API DELETE method API works
		"""
        self.client.login(username="testuser001", password="password")
        
        test_favourite = Favourite.objects.create(user=self.user, place=self.place)
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.delete(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_favourite_media_post(self):
        """
    	Ensure Favourite API POST method API works
    	"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/favourite/",
            {"media": self.media.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        response = self.client.get(
            "/api/favourite/{}/".format(created_id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['media'], self.media.id)
        self.assertEqual(response.data['media_obj']['id'], self.media.id)

    def test_favourite_media_redundant_post(self):
        """
    	Ensure Favourite API POST method API works
    	"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/favourite/",
            {"media": self.media.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(
            "/api/favourite/",
            {"media": self.media.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)

    def test_favourite_media_delete(self):
        """
		Ensure Favourite API DELETE method API works
		"""
        self.client.login(username="testuser001", password="password")
        test_favourite = Favourite.objects.create(user=self.user, media=self.media)
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.delete(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)