from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

# from users.models import User
from django.contrib.auth.models import User

from .models import Language, PlaceName, Community, Champion, Media, MediaFavourite


class LanguageAPITests(APITestCase):

	def setUp(self):
		self.language = Language.objects.create(name='Test language 001')

		self.user = User.objects.create(
            username = 'testeuser001',
            first_name = 'Test',
            last_name = 'user 001',
            email = 'test@countable.ca')

	###### ONE TEST TESTS ONLY ONE SCENARIO ######


    def test_language_detail(self):
        """
		Ensure we can retrieve a newly created language object.
		"""
		# test_language = Language.objects.create(name='Test language 001')
		response = self.client.get('/api/language/{}/'.format(self.language.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)


	def test_language_list(self):
		"""
		Ensure we can retrieve newly created language objects.
		"""
		# test_language1 = Language.objects.create(name='Test language 001')

        response = self.client.get("/api/language/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)


	def test_create_membership(self):
		"""
		Ensure we can create a language membership.
		"""	
		response = self.client.post('/api/languagemember/', {'user': {'id': self.user.id}, 'language': {'id': self.language.id}}, format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


class LanguageGeoAPITests(APITestCase):

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_language_geo_list_route_exists(self):
        """
		Ensure language list API route exists
		"""
        response = self.client.get("/api/language-geo/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_language_geo_detail(self):
        """
		Ensure we can retrieve a newly created language object.
		"""
        test_language = Language.objects.create(name="Test language 001")
        response = self.client.get(
            "/api/language-geo/{}/".format(test_language.id), format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # self.assertEqual(len(response.data), 1)


class CommunityAPITests(APITestCase):

	def setUp(self):
		self.community = Community.objects.create(name='Test community 001')

		self.user = User.objects.create(
            username = 'testeuser001',
            first_name = 'Test',
            last_name = 'user 001',
            email = 'test@countable.ca')

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

    def test_community_detail(self):
        """
		Ensure we can retrieve a newly created community object.
		"""
		response = self.client.get('/api/community/{}/'.format(self.community.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_community_list_route_exists(self):
        """
		Ensure community list API route exists
		"""
		response = self.client.get('/api/community/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)


	def test_create_membership(self):
		"""
		Ensure we can create a community membership.
		"""	
		response = self.client.post('/api/communitymember/', {'user': {'id': self.user.id}, 'community': {'id': self.community.id}}, format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_verify_membership(self):
		"""
		Ensure we can verify a community membership.
		"""	
		response_post = self.client.post('/api/communitymember/', 
										{'user': {'id': self.user.id}, 'community': {'id': self.community.id}}, 
										format='json')
		self.assertEqual(response_post.status_code, status.HTTP_200_OK)
		
		response_get = self.client.post('/api/communitymember/verify_membership/', 
										{'user': {'id': self.user.id}, 'community': {'id': self.community.id}}, 
										format='json')
		self.assertEqual(response_get.status_code, status.HTTP_200_OK)


class PlaceNameAPITests(APITestCase):

	def setUp(self):
		self.placename = PlaceName.objects.create(name='Test placename 001')

		# self.user = User.objects.create(
        #     username = 'testeuser001',
        #     first_name = 'Test',
        #     last_name = 'user 001',
        #     email = 'test@countable.ca'
        # )
		# self.user.languages.add(self.language1)
		# self.user.languages.add(self.language2)
		# self.user.communities.add(self.community1)
		# self.user.communities.add(self.community2)

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
		response = self.client.get('/api/placename/{}/'.format(self.placename.id), format='json')
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
		response = self.client.get('/api/placename/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		# assert len(response.data) = 1
		self.assertEqual(len(response.data), 1)


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
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_media_delete(self):
        """
		Ensure media API DELETE method API works
		"""
        test_media = Media.objects.create(name="Test media 001", file_type="image")
        response = self.client.delete(
            "/api/media/", {"id": test_media.id}, format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class MediaFavouriteAPITests(APITestCase):
    def setUp(self):
        self.user = User.objects.create(
            username="testeuser001",
            first_name="Test",
            last_name="user 001",
            email="test@countable.ca",
        )
		self.media = Media.objects.create(name='Test media 001', file_type='image')
		self.mediafavourite = MediaFavourite.objects.create(user=self.user, media=self.media)

    ###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_mediafavourite_detail(self):
		"""
		Ensure we can retrieve a newly created MediaFavourite object.
		"""
		response = self.client.get('/api/mediafavourite/{}/'.format(self.mediafavourite.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_mediafavourite_list_route_exists(self):
        """
		Ensure mediafavourite list API route exists
		"""
		response = self.client.get('/api/mediafavourite/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)


	# def test_mediafavourite_post(self):
	# 	"""
	# 	Ensure mediafavourite API POST method API works
	# 	"""
	# 	response = self.client.post('/api/mediafavourite/', {'name': 'Test mediafavourite 001', 'file_type': 'image'}, format='json')
	# 	self.assertEqual(response.status_code, status.HTTP_200_OK)

    # def test_mediafavourite_post(self):
    # 	"""
    # 	Ensure mediafavourite API POST method API works
    # 	"""
    # 	response = self.client.post('/api/mediafavourite/', {'name': 'Test mediafavourite 001', 'file_type': 'image'}, format='json')
    # 	self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_mediafavourite_delete(self):
        """
		Ensure mediafavourite API DELETE method API works
		"""
		response = self.client.delete('/api/mediafavourite/', {'id': self.mediafavourite.id}, format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
