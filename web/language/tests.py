from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from users.models import User

from .models import Language, PlaceName, Community, Champion, Media, Favourite


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


class LanguageAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_language_detail_route_exists(self):
        """
		Ensure language Detail API route exists
		"""
        response = self.client.get("/api/language/0/", format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_language_detail(self):
        """
		Ensure we can retrieve a newly created language object.
		"""
        test_language = Language.objects.create(name="Test language 001")
        response = self.client.get(
            "/api/language/{}/".format(test_language.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

    def test_language_list_route_exists(self):
        """
		Ensure language list API route exists
		"""
        response = self.client.get("/api/language/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_language_list(self):
        """
		Ensure we can retrieve newly created language objects.
		"""
        test_language1 = Language.objects.create(name="Test language 001")

        response = self.client.get("/api/language/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)


class LanguageGeoAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_language_geo_list_route_exists(self):
        """
		Ensure language list API route exists
		"""
        response = self.client.get("/api/language-geo/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    # Only the LIST operations exists in this API.


class CommunityAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_community_detail_route_exists(self):
        """
		Ensure community Detail API route exists
		"""
        response = self.client.get("/api/community/0/", format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_community_detail(self):
        """
		Ensure we can retrieve a newly created community object.
		"""
        test_community = Community.objects.create(name="Test community 001")
        response = self.client.get(
            "/api/community/{}/".format(test_community.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_community_list_route_exists(self):
        """
		Ensure community list API route exists
		"""
        response = self.client.get("/api/community/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    # def test_create_self_member(self):
    #     response = self.client.get("/api/community/create_self_membership")


class PlaceNameAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community = Community.objects.create(name="Test Community")
        self.language = Language.objects.create(name="Test Language")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_placename_detail_route_exists(self):
        """
		Ensure placename Detail API route exists
		"""
        response = self.client.get("/api/placename/0/", format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_placename_detail(self):
        """
		Ensure we can retrieve a newly created placename object.
		"""
        test_placename = PlaceName.objects.create(name="Test placename 001")
        response = self.client.get(
            "/api/placename/{}/".format(test_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_placename_list_route_exists(self):
        """
		Ensure placename list API route exists
		"""
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_placename_list(self):
        """
		Ensure placename list API brings newly created data
		"""
        test_placename = PlaceName.objects.create(name="Test placename 001")
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) > 0

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
                "point": {
                    "type": "Point",
                    "coordinates": [-132.14904785156, 54.020276150064],
                },
                "other_names": "string",
                "western_name": "string",
                "community_only": True,
                "description": "string",
                "community": self.community.id,
                "language": self.language.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.name, "test place")
        self.assertEqual(place.community_id, self.community.id)
        self.assertEqual(place.language_id, self.language.id)

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/".format(created_id),
            {"other_names": "updated other names", "community": None},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.other_names, "updated other names")

    def test_placename_flag(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.other_names = "string"
        placename.western_name = "string"
        placename.community_only = True
        placename.description = "string"
        placename.community = self.community
        placename.language = self.language
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


class ChampionAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_champion_detail_route_exists(self):
        """
		Ensure champion Detail API route exists
		"""
        response = self.client.get("/api/champion/0/", format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

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


class MediaAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_media_detail_route_not_allowed(self):
        """
		Ensure media Detail API route does not exist
		"""
        response = self.client.get("/api/media/0/", format="json")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_list_route_does_not_allowed(self):
        """
		Ensure media list API route does not exist
		"""
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_post(self):
        """
		Ensure media API POST method API works
		"""
        response = self.client.post(
            "/api/media/",
            {"name": "Test media 001", "file_type": "image"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_media_delete(self):
        """
		Ensure media API DELETE method API works
		"""
        test_media = Media.objects.create(name="Test media 001", file_type="image")
        response = self.client.delete(
            "/api/media/{}/".format(test_media.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)


class FavouriteAPITests(BaseTestCase):
    def setUp(self):
        self.place = PlaceName.objects.create(name="Test media 001")
        return super().setUp()

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_favourite_detail_route_exists(self):
        """
		Ensure Favourite Detail API route exists
		"""
        response = self.client.get("/api/Favourite/0/", format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_favourite_detail(self):
        """
		Ensure we can retrieve a newly created Favourite object.
		"""
        test_favourite = Favourite.objects.create(user=self.user, place=self.place)
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_favourite_list_route_exists(self):
        """
		Ensure Favourite list API route exists
		"""
        response = self.client.get("/api/favourite/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_favourite_post(self):
        """
    	Ensure Favourite API POST method API works
    	"""
        response = self.client.post(
            "/api/favourite/",
            {"place": self.place.id, "user": self.user.id},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_favourite_delete(self):
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

