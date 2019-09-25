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
