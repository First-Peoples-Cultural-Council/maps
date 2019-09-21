from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from users.models import User, Administrator

from .models import (
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


class CommunityAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community1 = Community.objects.create(name="Test Community 01")
        self.community2 = Community.objects.create(name="Test Community 02")
        self.language = Language.objects.create(name="Test Language")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

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

    def test_create_community_member_post(self):
        """
		Ensure we can retrieve a newly created community member object.
		"""
        response = self.client.post(
            "/api/community/{}/create_membership/".format(self.community1.id),
            {
                "user_id": self.user.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

    def test_member_list_to_verify(self):
        """
		Ensure CommunityMember list API brings newly created data which needs to be verified
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language, 
            community=self.community1
        )

        user_member01 = User.objects.create(
            username="testmember001",
            first_name="Test",
            last_name="member 001",
            email="testmember001@countable.ca",
        )

        user_member02 = User.objects.create(
            username="testmember002",
            first_name="Test",
            last_name="member 002",
            email="testmember002@countable.ca",
        )

        user_member03 = User.objects.create(
            username="testmember003",
            first_name="Test",
            last_name="member 003",
            email="testmember003@countable.ca",
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # VERIFIED CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        member_same01 = CommunityMember.objects.create(
            user = user_member01,
            community = self.community1,
            status=CommunityMember.VERIFIED
        )        
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 0
        
        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same02 = CommunityMember.create_member(user_member02.id, self.community1.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 1
        
        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same03 = CommunityMember.create_member(user_member03.id, self.community1.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 2
        
        # AFTER REJECTED CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        CommunityMember.reject_member(member_same02.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 1
        
        # AFTER VERIFYING CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        CommunityMember.verify_member(member_same03.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 0
        
        # UNVERIFIED CommunityMember NOT MATCHING admin's community. It MUST NOT be returned by the route
        member_diff = CommunityMember.create_member(user_member01.id, self.community2.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 0

        # ADDING ANOTHER ADMIN, previously UNVERIFIED CommunityMember now MATCHES admin's community.
        # It MUST be returned by the route
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language, 
            community=self.community2
        )
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) == 1
        
    def test_member_verify(self):
        """
		Ensure that CommunityMember can be VERIFIED
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language, 
            community=self.community1
        )

        user_member01 = User.objects.create(
            username="testmember001",
            first_name="Test",
            last_name="member 001",
            email="testmember001@countable.ca",
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)
        
        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same01 = CommunityMember.create_member(user_member01.id, self.community1.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # VERIFYING CommunityMember
        response = self.client.patch(
            "/api/community/verify_member/",
            {
                "user_id": user_member01.id,
                "community_id": self.community1.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        member = CommunityMember.objects.get(pk=member_same01.id)
        self.assertEqual(member.status, CommunityMember.VERIFIED)
        
        # AFTER VERIFYING CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
       
    def test_member_reject(self):
        """
		Ensure that CommunityMember can be REJECTED
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language, 
            community=self.community1
        )

        user_member01 = User.objects.create(
            username="testmember001",
            first_name="Test",
            last_name="member 001",
            email="testmember001@countable.ca",
        )

        # Must be logged in to verify a CommunityMember.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)
        
        # UNVERIFIED CommunityMember MATCHING admin's community. It MUST be returned by the route
        member_same01 = CommunityMember.create_member(user_member01.id, self.community1.id)
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

        # VERIFYING CommunityMember
        response = self.client.patch(
            "/api/community/reject_member/",
            {
                "user_id": user_member01.id,
                "community_id": self.community1.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        member = CommunityMember.objects.get(pk=member_same01.id)
        self.assertEqual(member.status, CommunityMember.REJECTED)
        
        # AFTER VERIFYING CommunityMember MATCHING admin's community. It MUST NOT be returned by the route
        response = self.client.get("/api/community/list_member_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    # def test_create_self_member(self):
    #     response = self.client.get("/api/community/create_self_membership")


class PlaceNameAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community = Community.objects.create(name="Test Community")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.language2 = Language.objects.create(name="Test Language 02")
        self.category = PlaceNameCategory.objects.create(name="Test Category", icon_name="icon")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_placename_detail(self):
        """
		Ensure we can retrieve a newly created placename object.
		"""
        test_placename = PlaceName.objects.create(
            name = "Test placename 001", 
        )
        response = self.client.get(
            "/api/placename/{}/".format(test_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Test placename 001")

    def test_placename_detail_returned_fields(self):
        """
		Ensure we can retrieve a newly created placename object.
		"""
        test_placename = PlaceName.objects.create(
            name = "Test placename 001", 
            audio_name = "string",
            audio_description = "string",
        )
        response = self.client.get(
            "/api/placename/{}/".format(test_placename.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Test placename 001")
        self.assertEqual(response.data["audio_name"], "string")
        self.assertEqual(response.data["audio_description"], "string")

    def test_placename_list(self):
        """
		Ensure placename list API brings newly created data
		"""
        test_placename = PlaceName.objects.create(name="Test placename 001")
        response = self.client.get("/api/placename/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        assert len(response.data) > 0

    def test_placename_list_to_verify(self):
        """
		Ensure placename list API brings newly created data which needs to be verified
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language1, 
            community=self.community
        )

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # VERIFIED Placename MATCHING user's language. It MUST NOT be returned by the route
        test_placename01 = PlaceName.objects.create(
            name = "test place01",
            community = self.community,
            language = self.language1,
            status=PlaceName.VERIFIED
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
        
        # UNVERIFIED Placename MATCHING user's language. It MUST be returned by the route
        test_placename02 = PlaceName.objects.create(
            name = "test place02",
            community = self.community,
            language = self.language1,
            status=PlaceName.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        assert len(response.data[0]['status_reason']) > 0
        
        # FLAGGED Placename MATCHING user's language. It MUST be returned by the route
        test_placename03 = PlaceName.objects.create(
            name = "test place03",
            community = self.community,
            language = self.language1,
            status=PlaceName.FLAGGED,
            status_reason = "string"
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        
        # UNVERIFIED Placename NOT MATCHING user's language. It MUST NOT be returned by the route
        test_placename04 = PlaceName.objects.create(
            name = "test place04",
            community = self.community,
            language = self.language2,
            status=PlaceName.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/placename/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

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
                "kind": "string",
                "other_names": "string",
                "common_name": "string",
                "community_only": True,
                "description": "string",
                "category": self.category.id,
                "community": self.community.id,
                "language": self.language1.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.name, "test place")
        self.assertEqual(place.community_id, self.community.id)
        self.assertEqual(place.language_id, self.language1.id)

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/".format(created_id),
            {"other_names": "updated other names", "community": None},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.other_names, "updated other names")

    def test_placename_verify(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.community = self.community
        placename.language = self.language1
        placename.save()

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/verify/".format(created_id),
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, PlaceName.VERIFIED)

    def test_placename_reject(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        placename = PlaceName()
        placename.name = "test place"
        placename.community = self.community
        placename.language = self.language1
        placename.save()

        created_id = placename.id

        # now update it.
        response = self.client.patch(
            "/api/placename/{}/reject/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.status, PlaceName.REJECTED)

    def test_placename_flag(self):
        placename = PlaceName()
        placename.name = "test place"
        placename.community = self.community
        placename.language = self.language1
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

    def test_post_only_required_fields(self):
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        response = self.client.post(
            "/api/placename/",
            {
                "name": "test place",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        place = PlaceName.objects.get(pk=created_id)
        self.assertEqual(place.name, "test place")


class ChampionAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

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


class MediaAPITests(BaseTestCase):
    def setUp(self):
        super().setUp()
        self.community1 = Community.objects.create(name="Test Community 1")
        self.community2 = Community.objects.create(name="Test Community 2")
        self.language1 = Language.objects.create(name="Test Language 01")
        self.language2 = Language.objects.create(name="Test Language 02")

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    # def test_media_detail_route_not_allowed(self):
    #     """
	# 	Ensure media Detail API route does not exist
	# 	"""
    #     response = self.client.get("/api/media/0/", format="json")
    #     self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_list_route_does_not_allowed(self):
        """
		Ensure media list API route does not exist
		"""
        response = self.client.get("/api/media/", format="json")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_media_post_with_community(self):
        """
		Ensure media API POST method API works
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)
        
        response = self.client.post(
            "/api/media/",
            {
                "name": "Test media 002", 
                "file_type": "image", 
                "url": "https://google.com", 
                "status" : Media.UNVERIFIED, 
                "community": self.community1.id,
                "community_only" : True, 
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.name, "Test media 002")
        self.assertEqual(media.file_type, "image")
        self.assertEqual(media.url, "https://google.com")
        self.assertEqual(media.status, Media.UNVERIFIED)
        self.assertEqual(media.community.id, self.community1.id)

    def test_media_post_with_placename(self):
        """
		Ensure media API POST method API works
		"""
        # Must be logged in to submit a place.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)
        
        placename = PlaceName()
        placename.name = "test place"
        placename.other_names = "string"
        placename.common_name = "string"
        placename.community_only = True
        placename.description = "string"
        placename.community = self.community1
        placename.language = self.language1
        placename.save()

        response = self.client.post(
            "/api/media/",
            {
                "name": "Test media 001", 
                "file_type": "image", 
                "url": "https://google.com", 
                "status" : Media.UNVERIFIED, 
                "placename": placename.id,
                "community_only" : True, 
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        created_id = response.json()["id"]

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.name, "Test media 001")
        self.assertEqual(media.file_type, "image")
        self.assertEqual(media.url, "https://google.com")
        self.assertEqual(media.status, Media.UNVERIFIED)
        self.assertEqual(media.placename.id, placename.id)

    def test_repeated_names_for_media(self):
        
        test_media1 = Media.objects.create(
            name = "test media",
            file_type = "string",
        )
        
        test_media2 = Media.objects.create(
            name = "test media",
            file_type = "string",
        )

        self.assertEqual(1, 1)

    def test_list_to_verify(self):
        """
		Ensure media list API brings newly created data which needs to be verified
		"""
        admin = Administrator.objects.create(
            user=self.user, 
            language=self.language1, 
            community=self.community1
        )

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
            community = self.community1,
        )

        # PlaceName out of the same language as the user (language admin)
        placename2 = PlaceName.objects.create(
            name = "test place02",
            language = self.language2,
            community = self.community1,
        )

        # VERIFIED Media MATCHING admin's language. It MUST NOT be returned by the route
        media_same01 = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.VERIFIED
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
        
        # UNVERIFIED Media MATCHING admin's language. It MUST be returned by the route
        media_same02 = Media.objects.create(
            name = "test media02",
            file_type = "string",
            placename = placename1,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        assert len(response.data[0]['status_reason']) > 0
        
        # FLAGGED Media MATCHING admin's language. It MUST be returned by the route
        media_diff01 = Media.objects.create(
            name = "test media03",
            file_type = "string",
            placename = placename1,
            status=Media.FLAGGED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        
        # UNVERIFIED Media NOT MATCHING admin's language. It MUST NOT be returned by the route
        test_media04 = Media.objects.create(
            name = "test media04",
            file_type = "string",
            placename = placename2,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        
        # UNVERIFIED Media MATCHING admin's community. It MUST be returned by the route
        self.community1.languages.add(self.language1)
        self.community1.save()

        media_same03 = Media.objects.create(
            name = "test media02",
            file_type = "string",
            community = self.community1,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)
        
        # UNVERIFIED Media MATCHING admin's community. It MUST be returned by the route
        self.community2.languages.add(self.language1)
        self.community2.save()
        
        media_same04 = Media.objects.create(
            name = "test media02",
            file_type = "string",
            community = self.community2,
            status=Media.UNVERIFIED,
            status_reason = "string"
        )        
        response = self.client.get("/api/media/list_to_verify/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

    def test_verify_media(self):

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.FLAGGED
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/verify/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, Media.VERIFIED)

    def test_reject_media(self):

        # Must be logged in to verify a media.
        self.assertTrue(self.client.login(username="testuser001", password="password"))

        # Check we're logged in
        response = self.client.get("/api/user/auth/")
        self.assertEqual(response.json()["is_authenticated"], True)

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.UNVERIFIED
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/reject/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, Media.REJECTED)

    def test_flag_unverified_media(self):

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.UNVERIFIED
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/flag/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, Media.FLAGGED)
        self.assertEqual(media.status_reason, "test reason status")

    def test_flag_verified_media(self):

        # PlaceName in the same language as the user (language admin)
        placename1 = PlaceName.objects.create(
            name = "test place01",
            language = self.language1,
        )
        
        test_media = Media.objects.create(
            name = "test media01",
            file_type = "string",
            placename = placename1,
            status=Media.VERIFIED
        )

        created_id = test_media.id

        # now update it.
        response = self.client.patch(
            "/api/media/{}/flag/".format(created_id),
            {"status_reason": "test reason status"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        media = Media.objects.get(pk=created_id)
        self.assertEqual(media.status, Media.VERIFIED)

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
        self.assertEqual(response.data['place']['id'], self.place.id)

    def test_detail_with_placename(self):
        """
		Ensure we can retrieve a newly created Favourite object.
		"""
        test_favourite = Favourite.objects.create(user=self.user, media=self.media, name="test favourite")
        response = self.client.get(
            "/api/favourite/{}/".format(test_favourite.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['media']['id'], self.media.id)

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
        response = self.client.post(
            "/api/favourite/",
            {"place": self.place.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

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
        response = self.client.post(
            "/api/favourite/",
            {"media": self.media.id, "user": self.user.id, "name": "test favourite"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

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
