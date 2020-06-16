from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from django.utils import timezone

from users.models import User, Administrator
from django.contrib.gis.geos import GEOSGeometry

import json

from language.models import (
    Language, 
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

        self.FAKE_GEOM = """
            {
                "type": "Polygon",
                "coordinates": [
                    [
                        [
                        -126.69158935546875,
                        54.629338216555766
                        ],
                        [
                        -126.91406249999999,
                        54.746820492190885
                        ],
                        [
                        -126.95526123046875,
                        54.57683778006274
                        ],
                        [
                        -126.69158935546875,
                        54.629338216555766
                        ]
                    ]
                ]
            }"""


class LanguageAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.now = timezone.now()

        self.recording1 = Recording.objects.create(
            speaker = "Test recording",
            recorder = "Test recording",
            created = self.now,
            date_recorded = self.now,
        )

        self.recording2 = Recording.objects.create(
            speaker = "Test recording",
            recorder = "Test recording",
            created = self.now,
            date_recorded = self.now,
        )

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
        poly = GEOSGeometry(self.FAKE_GEOM)
        
        test_language = Language(name="Test language 001")
        test_language.geom = poly
        test_language.language_audio = self.recording1
        test_language.greeting_audio = self.recording2
        test_language.save()

        response = self.client.get(
            "/api/language/{}/".format(test_language.id), format="json"
        )

        # import pdb
        # pdb.set_trace()

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_language.id)
        self.assertEqual(response.data["name"], "Test language 001")
        self.assertEqual(response.data["language_audio"]["speaker"], self.recording1.speaker)
        self.assertEqual(response.data["language_audio"]["recorder"], self.recording1.recorder)

    def test_language_add_language_audio(self):
        """
		Ensure we can add a language audio to a language object.
		"""
        # Must be logged in
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        poly = GEOSGeometry(self.FAKE_GEOM)
        
        test_language = Language(name="Test language audio")
        test_language.geom = poly
        test_language.save()

        response = self.client.patch(
            "/api/language/{}/add_language_audio/".format(test_language.id), 
            {
                "recording_id": self.recording1.id
            },
            format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            "/api/language/{}/".format(test_language.id), format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_language.id)
        self.assertEqual(response.data["name"], "Test language audio")
        self.assertEqual(response.data["language_audio"]["id"], self.recording1.id)
        self.assertEqual(response.data["language_audio"]["speaker"], self.recording1.speaker)

    def test_language_add_greeting_audio(self):
        """
		Ensure we can add a greeting audio to a language object.
		"""
        # Must be logged in
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        poly = GEOSGeometry(self.FAKE_GEOM)
        
        test_language = Language(name="Test greeting audio")
        test_language.geom = poly
        test_language.save()

        response = self.client.patch(
            "/api/language/{}/add_greeting_audio/".format(test_language.id), 
            {
                "recording_id": self.recording2.id
            },
            format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            "/api/language/{}/".format(test_language.id), format="json"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], test_language.id)
        self.assertEqual(response.data["name"], "Test greeting audio")
        self.assertEqual(response.data["greeting_audio"]["id"], self.recording2.id)
        self.assertEqual(response.data["greeting_audio"]["speaker"], self.recording2.speaker)

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
        poly = GEOSGeometry(self.FAKE_GEOM)
        
        test_language = Language(name="Test language 001")
        test_language.geom = poly
        test_language.save()

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
