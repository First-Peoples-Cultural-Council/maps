from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from django.utils import timezone

from users.models import User, Administrator
from language.models import (
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


class RecordingAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.now = timezone.now()

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_recording_detail(self):
        """
		Ensure we can retrieve a newly created recording object.
		"""
        test_recording = Recording.objects.create(
            speaker = "Test speaker",
            recorder = "Test recorder",
            created = self.now,
            date_recorded = self.now,
        )

        response = self.client.get(
            "/api/recording/{}/".format(test_recording.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["speaker"], test_recording.speaker)
        self.assertEqual(response.data["recorder"], test_recording.recorder)

    def test_recording_post(self):
        """
		Ensure recording API POST method API works
		"""
        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/recording/",
            {
                "speaker": "Test speaker",
                "recorder": "Test recorder",
                "date_recorded": "2019-01-01"
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        recording = Recording.objects.get(pk=created_id)
        self.assertEqual(recording.speaker, "Test speaker")
        self.assertEqual(recording.recorder, "Test recorder")

    def test_recording_patch(self):
        """
		Ensure recording API PATCH method API works
		"""
        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        test_recording = Recording.objects.create(
            speaker = "Test speaker",
            recorder = "Test recorder",
            created = self.now,
            date_recorded = self.now,
        )

        response = self.client.patch(
            "/api/recording/{}/".format(test_recording.id),
            {
                "speaker": "Test speaker2",
                "recorder": "Test recorder2",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        recording = Recording.objects.get(pk=test_recording.id)
        self.assertEqual(recording.speaker, "Test speaker2")
        self.assertEqual(recording.recorder, "Test recorder2")

    def test_recording_delete(self):
        """
		Ensure recording API DELETE method API works
		"""
        test_recording = Recording.objects.create(
            speaker = "Test speaker",
            recorder = "Test recorder",
            created = self.now,
            date_recorded = self.now,
        )
        
        response = self.client.delete(
            "/api/recording/{}/".format(test_recording.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
