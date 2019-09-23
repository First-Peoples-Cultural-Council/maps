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


class NotificationAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community1 = Community.objects.create(name="Test Community 1")
        self.language1 = Language.objects.create(name="Test Language 01")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_notification_detail(self):
        """
		Ensure we can retrieve a newly created notification object.
		"""
        test_notification = Notification.objects.create(
            name = "Test notification 001",
            language = self.language1,
            community = self.community1
        )
        response = self.client.get(
            "/api/notification/{}/".format(test_notification.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Test notification 001")
        self.assertEqual(response.data["language"]['id'], self.language1.id)
        self.assertEqual(response.data["community"]['id'], self.community1.id)

    def test_notification_list(self):
        """
		Ensure notification list API brings newly created data
		"""
        test_notification = Notification.objects.create(name="Test notification 001")
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) > 0

    def test_notification_post_with_language(self):
        """
		Ensure notification API POST method API works
		"""
        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/notification/",
            {"name": "Test notification 002", "language": self.language1.id},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        notification = Notification.objects.get(pk=created_id)
        self.assertEqual(notification.name, "Test notification 002")
        # self.assertEqual(notification.language.id, self.language1.id)

    def test_notification_post_with_community(self):
        """
		Ensure notification API POST method API works
		"""
        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/notification/",
            {"name": "Test notification 002", "community": self.community1.id},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        notification = Notification.objects.get(pk=created_id)
        self.assertEqual(notification.name, "Test notification 002")
        # self.assertEqual(notification.community.id, self.community1.id)

    def test_notification_delete(self):
        """
		Ensure notification API DELETE method API works
		"""
        test_notification = Notification.objects.create(name="Test notification 001")
        response = self.client.delete(
            "/api/notification/{}/".format(test_notification.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
