from rest_framework.test import APITestCase
from rest_framework import status

from users.models import User

from language.models import (
    Language,
    Community,
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


class NotificationAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community1 = Community.objects.create(name="Test Community 1")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.user_owned_notification = Notification.objects.create(
            name="User Owned Notification",
            language=self.language1,
            user=self.user,
        )

    # ONE TEST TESTS ONLY ONE SCENARIO

    def test_notification_detail(self):
        """
        Ensure we can retrieve a newly created notification object.
        """
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        response = self.client.get(
            "/api/notification/{}/".format(self.user_owned_notification.id),
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], self.user_owned_notification.name)

    def test_notification_list_authorized_access(self):
        """
        Ensure Notification list API is accessible to logged in users
        """
        # Must be logged in
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.get(
            f"/api/notification/{self.user_owned_notification.id}/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_notification_list_unauthenticated(self):
        """
        Ensure Notification list API is only accessible to logged in users
        """
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        response = self.client.get(
            f"/api/notification/{self.user_owned_notification.id}/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_notification_list_unauthorized_access(self):
        """
        Ensure Notification is not visible to non-owners
        """
        self.assertTrue(self.client.login(username="testuser002", password="password"))

        response = self.client.get(
            f"/api/notification/{self.user_owned_notification.id}/", format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_notification_list_different_users(self):
        """
        Ensure only own notifications are visible to the current user
        """

        # Must be logged in
        self.client.login(username="testuser001", password="password")

        # 1 data so far for the user (in setUp)
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # Creating an object which BELONGS to the user
        # GET must return two objects
        response = self.client.post(
            "/api/notification/",
            {
                "name": "test notification",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id1 = response.json()["id"]

        response2 = self.client.get("/api/notification/", format="json")
        self.assertEqual(response2.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response2.data), 2)

        # Creating an object which DOES NOT BELONG to the user
        # GET must still return two objects
        Notification.objects.create(user=self.user2, name="test notification2")
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # Creating an object which BELONGS to the user
        # GET must return three objects
        test_notification3 = Notification.objects.create(
            user=self.user, name="test notification3"
        )
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

        # Deleting the object which BELONGS to the user
        # GET must return two object
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.delete(
            "/api/notification/{}/".format(created_id1), format="json"
        )
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

        # Deleting the object which BELONGS to the user
        # GET must return 1 object
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.delete(
            "/api/notification/{}/".format(test_notification3.id), format="json"
        )
        response = self.client.get("/api/notification/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

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
        self.assertEqual(notification.language.id, self.language1.id)

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
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        response = self.client.delete(
            "/api/notification/{}/".format(self.user_owned_notification.id),
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)


# test_notification_delete
# test_notification_detail
# test_notification_list_different_users
