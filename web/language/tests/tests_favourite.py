from django.contrib.gis.geos import GEOSGeometry

from rest_framework.test import APITestCase
from rest_framework import status

from users.models import User

from language.models import PlaceName, Media, Favourite


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

        self.regular_user = User.objects.create(
            username="regular_user",
            first_name="Regular",
            last_name="User",
            email="regular@countable.ca",
        )
        self.regular_user.set_password("password")
        self.regular_user.save()

        self.place = PlaceName.objects.create(name="Test place 001")
        self.media = Media.objects.create(name="Test media 001")
        self.FAKE_GEOM = """
            {
                "type": "Point",
                "coordinates": [
                    -126.3482666015625,
                    54.74840576223716
                ]
            }
        """
        self.point = GEOSGeometry(self.FAKE_GEOM)


class FavouriteAPITests(BaseTestCase):
    def test_favourite_list_route_exists(self):
        """
        Ensure Favourite list API route exists
        """
        # Must be logged in
        self.client.login(username="admin_user", password="password")

        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_get_favourite_placename(self):
        """
        Ensure we can retrieve a newly created Favourite object.
        """
        favourite_placename = Favourite.objects.create(
            name="Favourite Placename",
            user=self.admin_user,
            place=self.place,
            favourite_type="favourite",
            description="I like this Placename",
            point=self.point,
            zoom=10,
        )
        self.client.login(username="admin_user", password="password")
        response = self.client.get(
            "/api/favourite/{}/".format(favourite_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Favourite Placename")
        self.assertEqual(response.data["user"]["id"], self.admin_user.id)
        self.assertEqual(response.data["place"], self.place.id)
        self.assertEqual(response.data["favourite_type"], "favourite")
        self.assertEqual(response.data["description"], "I like this Placename")
        self.assertEqual(response.data["point"]["coordinates"][0], self.point.x)
        self.assertEqual(response.data["point"]["coordinates"][1], self.point.y)
        self.assertEqual(response.data["zoom"], 10)

    def test_get_favourite_media(self):
        """
        Ensure we can retrieve a newly created Favourite object.
        """
        favourite_media = Favourite.objects.create(
            name="Favourite Media",
            user=self.admin_user,
            media=self.media,
            favourite_type="favourite",
            description="I like this Media",
            point=self.point,
            zoom=10,
        )
        self.client.login(username="admin_user", password="password")
        response = self.client.get(
            "/api/favourite/{}/".format(favourite_media.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Favourite Media")
        self.assertEqual(response.data["user"]["id"], self.admin_user.id)
        self.assertEqual(response.data["media"], self.media.id)
        self.assertEqual(response.data["favourite_type"], "favourite")
        self.assertEqual(response.data["description"], "I like this Media")
        self.assertEqual(response.data["point"]["coordinates"][0], self.point.x)
        self.assertEqual(response.data["point"]["coordinates"][1], self.point.y)
        self.assertEqual(response.data["zoom"], 10)

    def test_new_favourite_placename(self):
        """
        Ensure we can retrieve a newly created Favourite object.
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "Favourite Place",
                "place": self.place.id,
                "user": self.admin_user.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        response = self.client.get(
            "/api/favourite/{}/".format(created_id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Favourite Place")
        self.assertEqual(response.data["user"]["id"], self.admin_user.id)
        self.assertEqual(response.data["place"], self.place.id)

    def test_new_favourite_media(self):
        """
        Ensure we can retrieve a newly created Favourite object.
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "Favourite Media",
                "media": self.media.id,
                "user": self.admin_user.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        response = self.client.get(
            "/api/favourite/{}/".format(created_id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Favourite Media")
        self.assertEqual(response.data["user"]["id"], self.admin_user.id)
        self.assertEqual(response.data["media"], self.media.id)
        self.assertEqual(response.data["media_obj"]["id"], self.media.id)

    def test_new_favourite_point(self):
        """
        Ensure Favourite API POST method API works on Points
        """
        # Must be logged in
        self.client.login(username="admin_user", password="password")

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "Favourite Point",
                "favourite_type": "favourite",
                "description": "description",
                "point": self.FAKE_GEOM,
                "zoom": 10,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        response = self.client.get(
            "/api/favourite/{}/".format(created_id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Favourite Point")
        self.assertEqual(response.data["user"]["id"], self.admin_user.id)
        self.assertEqual(response.data["favourite_type"], "favourite")
        self.assertEqual(response.data["description"], "description")
        self.assertEqual(response.data["point"]["coordinates"][0], self.point.x)
        self.assertEqual(response.data["point"]["coordinates"][1], self.point.y)
        self.assertEqual(response.data["zoom"], 10)

    def test_favourite_list_different_users(self):
        """
        Ensure Favourite List API Returns accurate number of data
        """
        # Must be logged in
        self.client.login(username="admin_user", password="password")

        # No data so far for the Admin User
        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # Creating an object which BELONGS to the Admin User
        response = self.client.post(
            "/api/favourite/",
            {
                "name": "New Favourite",
                "favourite_type": "favourite",
                "description": "I like this Point",
                "point": self.FAKE_GEOM,
                "zoom": 10,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        # Since one new Favourite was created, return 1 result
        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # Creating an object which DOES NOT BELONG to the Admin User
        Favourite.objects.create(user=self.regular_user, place=self.place)

        # Since new Favourite DOES NOT BELONG to the Admin User, still return 1 result
        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

    def test_delete_favourite(self):
        # Must be logged in
        self.client.login(username="admin_user", password="password")

        # Create Favourite for Admin User
        owned_favourite_to_delete = Favourite.objects.create(
            user=self.admin_user, place=self.place
        )

        # Create Favourite for Regular User
        random_favourite_to_delete = Favourite.objects.create(
            user=self.regular_user, place=self.place
        )
        response = self.client.get("/api/favourite/", format="json")

        # Although 2 new Favourites were created, only return 1 result
        # because the 2nd one is not owned by the currently logged in User (Admin User)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # owned_favourite_to_delete is deleted
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.delete(
            "/api/favourite/{}/".format(owned_favourite_to_delete.id), format="json"
        )
        response = self.client.get("/api/favourite/", format="json")

        # Since owned_favourite_to_delete was deleted, return 0 results
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

        # random_favourite_to_delete is deleted
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.delete(
            "/api/favourite/{}/".format(random_favourite_to_delete.id), format="json"
        )
        response = self.client.get("/api/favourite/", format="json")

        # Even though random_favourite_to_delete was deleted, it has no impact on the list
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    def test_repeated_names_for_favourites(self):
        # Must be logged in
        self.client.login(username="admin_user", password="password")

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "Repeated Name",
                "favourite_type": "favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "Repeated Name",
                "favourite_type": "favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        self.assertEqual(1, 1)

    def test_empty_names_for_favourites(self):
        # Must be logged in
        self.client.login(username="admin_user", password="password")

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "",
                "favourite_type": "favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(
            "/api/favourite/",
            {
                "name": "",
                "favourite_type": "favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        self.assertEqual(1, 1)

    def test_redundant_placename_favourite(self):
        """
        Ensure Favourite API POST method API works
        """
        self.client.login(username="admin_user", password="password")

        response = self.client.post(
            "/api/favourite/",
            {
                "place": self.place.id,
                "user": self.admin_user.id,
                "name": "Redundant Placename Favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(
            "/api/favourite/",
            {
                "place": self.place.id,
                "user": self.admin_user.id,
                "name": "Redundant Placename Favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)

    def test_redundant_media_favourite(self):
        """
        Ensure Favourite API POST method API works
        """
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="admin_user", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/favourite/",
            {
                "media": self.media.id,
                "user": self.admin_user.id,
                "name": "Redundant Media Favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(
            "/api/favourite/",
            {
                "media": self.media.id,
                "user": self.admin_user.id,
                "name": "Redundant Media Favourite",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
