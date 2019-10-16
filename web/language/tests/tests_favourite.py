from django.test import TestCase

from django.contrib.gis.geos import GEOSGeometry, Point

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


class FavouriteAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.place = PlaceName.objects.create(name="Test place 001")
        self.media = Media.objects.create(name="Test media 001")
        self.FAKE_GEOM = """
            {
                "type": "Point",
                "coordinates": [
                    -126.3482666015625,
                    54.74840576223716
                ]
            }"""
        self.point = GEOSGeometry(self.FAKE_GEOM)

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_detail_with_placename(self):
        """
		Ensure we can retrieve a newly created Favourite object.
		"""
        test_favourite = Favourite.objects.create(
            name="test favourite",
            user=self.user, 
            place=self.place, 
            favourite_type="favourite", 
            description="description", 
            point = self.point,
            zoom=10,
        )
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], "test favourite")
        self.assertEqual(response.data['user']['id'], self.user.id)
        self.assertEqual(response.data['place'], self.place.id)
        self.assertEqual(response.data['favourite_type'], "favourite")
        self.assertEqual(response.data['description'], "description")
        self.assertEqual(response.data['point']['coordinates'][0], self.point.x)
        self.assertEqual(response.data['point']['coordinates'][1], self.point.y)
        self.assertEqual(response.data['zoom'], 10)

    def test_detail_with_media(self):
        """
		Ensure we can retrieve a newly created Favourite object.
		"""

        test_favourite = Favourite.objects.create(
            name="test favourite",
            user=self.user, 
            media=self.media,
            favourite_type="favourite", 
            description="description", 
            point = self.point,
            zoom=10,            
        )
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['media'], self.media.id)

    def test_favourite_list_unauthorized_access(self):
        """
		Ensure Favourite list API route exists
		"""
        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    # def test_favourite_list_different_users(self):
    #     """
	# 	Ensure Favourite API DELETE method API works
	# 	"""
    #     # Must be logged in
    #     self.client.login(username="testuser001", password="password")

    #     # No data so far for the user
    #     response = self.client.get("/api/favourite/", format="json")
    #     self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     self.assertEqual(len(response.data), 0)
        
    #     # Creating an object which BELONGS to the user
    #     # GET must return one object
    #     response = self.client.post(
    #         "/api/favourite/",
    #         {
    #             "name": "test favourite",
    #             "favourite_type": "favourite", 
    #             "description": "description", 
    #             "point": self.FAKE_GEOM,
    #             "place": self.place.id,
    #             "media": self.media.id,
    #             "zoom":10,
    #         },
    #         format="json",
    #     )
    #     self.assertEqual(response.status_code, status.HTTP_201_CREATED)
    #     created_id1 = response.json()["id"]

    #     response2 = self.client.get("/api/favourite/", format="json")
    #     self.assertEqual(response2.status_code, status.HTTP_200_OK)
    #     self.assertEqual(len(response2.data), 1)
        
    #     # # Creating an object which DOES NOT BELONG to the user
    #     # # GET must return one object
    #     # test_favourite2 = Favourite.objects.create(
    #     #     user=self.user2, place=self.place
    #     # )
    #     # response = self.client.get("/api/favourite/", format="json")
    #     # self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     # self.assertEqual(len(response.data), 1)
        
    #     # # Creating an object which BELONGS to the user
    #     # # GET must return two objects
    #     # test_favourite3 = Favourite.objects.create(
    #     #     user=self.user, place=self.place
    #     # )
    #     # response = self.client.get("/api/favourite/", format="json")
    #     # self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     # self.assertEqual(len(response.data), 2)

    #     # # Deleting the object which BELONGS to the user
    #     # # GET must return one object
    #     # self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     # response = self.client.delete(
    #     #     "/api/favourite/{}/".format(created_id1), format="json"
    #     # )
    #     # response = self.client.get("/api/favourite/", format="json")
    #     # self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     # self.assertEqual(len(response.data), 1)

    #     # # Deleting the object which BELONGS to the user
    #     # # GET must return zero objects
    #     # self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     # response = self.client.delete(
    #     #     "/api/favourite/{}/".format(test_favourite3.id), format="json"
    #     # )
    #     # response = self.client.get("/api/favourite/", format="json")
    #     # self.assertEqual(response.status_code, status.HTTP_200_OK)
    #     # self.assertEqual(len(response.data), 0)

    def test_favourite_post(self):
        """
    	Ensure Favourite API POST method API works
    	"""
        # Must be logged in
        self.client.login(username="testuser001", password="password")

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "test favourite",
                "favourite_type": "favourite", 
                "description": "description", 
                "point": self.FAKE_GEOM,
                "zoom":10,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        response = self.client.get(
            "/api/favourite/{}/".format(created_id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], "test favourite")
        self.assertEqual(response.data['user']['id'], self.user.id)
        self.assertEqual(response.data['favourite_type'], "favourite")
        self.assertEqual(response.data['description'], "description")
        self.assertEqual(response.data['point']['coordinates'][0], self.point.x)
        self.assertEqual(response.data['point']['coordinates'][1], self.point.y)
        self.assertEqual(response.data['zoom'], 10)

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
        self.assertEqual(response.data['user']['id'], self.user.id)
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
        self.assertEqual(response.data['user']['id'], self.user.id)
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