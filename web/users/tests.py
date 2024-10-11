from rest_framework.test import APITestCase
from rest_framework import status

from language.models import Language, Community
from users.models import User


class UserAPITests(APITestCase):
    def setUp(self):
        self.language1 = Language.objects.create(name="Test language 001")
        self.language2 = Language.objects.create(name="Test language 002")
        self.community1 = Community.objects.create(name="Test community 001")
        self.community2 = Community.objects.create(name="Test community 002")

        self.user1 = User.objects.create(
            username="testuser001",
            first_name="Test",
            last_name="user 001",
            email="test1@countable.ca",
        )
        self.user1.set_password("password")
        self.user1.languages.add(self.language1)
        self.user1.languages.add(self.language2)
        self.user1.communities.add(self.community1)
        self.user1.save()

        self.user2 = User.objects.create(
            username="testuser002",
            first_name="Test",
            last_name="user 002",
            email="test2@countable.ca",
        )
        self.user2.set_password("password")
        self.user2.languages.add(self.language1)
        self.user2.languages.add(self.language2)
        self.user2.communities.add(self.community1)
        self.user2.save()

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_user_detail_route_exists(self):
        """
        Ensure user Detail API route exists
        """
        self.client.login(username="testuser001", password="password")
        response = self.client.get(
            f"/api/user/{self.user1.id}", format="json", follow=True
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_user_detail(self):
        """
        Ensure we can retrieve a newly created user object.
        """
        self.client.login(username="testuser001", password="password")
        response = self.client.get(
            f"/api/user/{self.user1.id}/", format="json", follow=True
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], self.user1.id)
        self.assertEqual(len(response.data["languages"]), 2)
        self.assertEqual(len(response.data["communities"]), 1)

        response = self.client.get("/api/user/auth", format="json", follow=True)
        self.assertEqual(response.data["is_authenticated"], True)
        self.assertEqual(response.data["user"]["id"], self.user1.id)

    def test_user_detail_unauthorized(self):
        """
        Test we can't fetch user details without signing in
        """
        response = self.client.get(
            f"/api/user/{self.user2.id}/".format(), format="json", follow=True
        )
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_user_detail_forbidden(self):
        """
        Test we can't fetch user details with the wrong user logged in
        """
        self.client.login(username="testuser001", password="password")
        response = self.client.get(
            f"/api/user/{self.user2.id}/".format(), format="json", follow=True
        )
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_user_post_not_allowed(self):
        """
        Ensure there is no user create API
        """
        response = self.client.post(
            "/api/user/",
            {
                "username": "testuser001",
                "first_name": "Test",
                "last_name": "user 001",
                "email": "test1@countable.ca",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_user_set_community(self):
        """
        Test we can set the community
        """
        self.client.login(username="testuser001", password="password")
        response = self.client.patch(
            f"/api/user/{self.user1.id}/",
            {"community_ids": [self.community2.id, self.community1.id]},
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # check updates are reflected in API.
        response = self.client.get(f"/api/user/{self.user1.id}/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["id"], self.user1.id)
        self.assertEqual(len(response.data["languages"]), 2)
        self.assertEqual(len(response.data["communities"]), 2)

    def test_user_patch(self):
        """
        Test we can set the bio on the user's settings page.
        """
        self.client.login(username="testuser001", password="password")
        response = self.client.patch(f"/api/user/{self.user1.id}/", {"bio": "bio"})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        response = self.client.get(f"/api/user/{self.user1.id}/", format="json")
        self.assertEqual(response.data["bio"], "bio")

    def test_user_patch_unauthorized(self):
        """
        Test we can't patch a user without signing in
        """
        response = self.client.patch(f"/api/user/{self.user2.id}/", {"bio": "bio"})
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_user_patch_forbidden(self):
        """
        Test we can't patch a user with the wrong user logged in
        """
        self.client.login(username="testuser001", password="password")
        response = self.client.patch(f"/api/user/{self.user2.id}/", {"bio": "bio"})
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)


# Consider adding tests for login and logout in the future

# The following do not have/need tests because they are obsolete, but we
# don't want to remove them in case a very old user claims their profile:
#   - ConfirmClaimView
#   - ValidateInviteView
