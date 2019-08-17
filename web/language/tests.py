from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from .models import (
    Language,
    PlaceName,
    Community,
    Champion,
	Media
)


class LanguageAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_language_detail_route_exists(self):
		"""
		Ensure language Detail API route exists
		"""
		response = self.client.get('/api/language/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


	def test_language_detail(self):
		"""
		Ensure we can retrieve a newly created language object.
		"""
		test_language = Language.objects.create(name='Test language 001')
		response = self.client.get('/api/language/{}/'.format(test_language.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)


	def test_language_list_route_exists(self):
		"""
		Ensure language list API route exists
		"""
		response = self.client.get('/api/language/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_language_list(self):
		"""
		Ensure we can retrieve newly created language objects.
		"""
		test_language1 = Language.objects.create(name='Test language 001')

		response = self.client.get('/api/language/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)


class LanguageGeoAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_language_geo_list_route_exists(self):
		"""
		Ensure language list API route exists
		"""
		response = self.client.get('/api/language-geo/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_language_geo_detail(self):
		"""
		Ensure we can retrieve a newly created language object.
		"""
		test_language = Language.objects.create(name='Test language 001')
		response = self.client.get('/api/language-geo/{}/'.format(test_language.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		# self.assertEqual(len(response.data), 1)


class CommunityAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_community_detail_route_exists(self):
		"""
		Ensure community Detail API route exists
		"""
		response = self.client.get('/api/community/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


	def test_community_detail(self):
		"""
		Ensure we can retrieve a newly created community object.
		"""
		test_community = Community.objects.create(name='Test community 001')
		response = self.client.get('/api/community/{}/'.format(test_community.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_community_list_route_exists(self):
		"""
		Ensure community list API route exists
		"""
		response = self.client.get('/api/community/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


class PlaceNameAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_placename_detail_route_exists(self):
		"""
		Ensure placename Detail API route exists
		"""
		response = self.client.get('/api/placename/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


	def test_placename_detail(self):
		"""
		Ensure we can retrieve a newly created placename object.
		"""
		test_placename = PlaceName.objects.create(name='Test placename 001')
		response = self.client.get('/api/placename/{}/'.format(test_placename.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_placename_list_route_exists(self):
		"""
		Ensure placename list API route exists
		"""
		response = self.client.get('/api/placename/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_placename_list(self):
		"""
		Ensure placename list API brings newly created data
		"""
		test_placename = PlaceName.objects.create(name='Test placename 001')
		response = self.client.get('/api/placename/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		assert len(response.data) > 0


class ChampionAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_champion_detail_route_exists(self):
		"""
		Ensure champion Detail API route exists
		"""
		response = self.client.get('/api/champion/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


	def test_champion_detail(self):
		"""
		Ensure we can retrieve a newly created champion object.
		"""
		test_champion = Champion.objects.create(name='Test champion 001')
		response = self.client.get('/api/champion/{}/'.format(test_champion.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_champion_list_route_exists(self):
		"""
		Ensure champion list API route exists
		"""
		response = self.client.get('/api/champion/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


class MediaAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_media_detail_route_does_not_exists(self):
		"""
		Ensure media Detail API route does not exists
		"""
		response = self.client.get('/api/media/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)


	def test_media_list_route_does_not_exists(self):
		"""
		Ensure media list API route does not exists
		"""
		response = self.client.get('/api/media/', format='json')
		self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)


	def test_media_post(self):
		"""
		Ensure media API POST method API works
		"""
		self.client.post('/api/media/', {'name': 'Test media 001', 'file_type': 'image'}, format='json')


	def test_media_delete(self):
		"""
		Ensure media API DELETE method API works
		"""
		test_media = Media.objects.create(name='Test media 001', file_type='image')
		self.client.delete('/api/media/', {'id': test_media.id}, format='json')