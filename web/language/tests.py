from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from .models import (
    Language,
    PlaceName,
    Community,
    Champion,
    Art
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


	# def test_language_search_route_up(self):
	# 	"""
	# 	Ensure language Search API route is up and running
	# 	"""
	# 	response = self.client.get('/api/language/search/?search_params=Test', format='json')
	# 	self.assertEqual(response.status_code, status.HTTP_200_OK)
		

	# def test_language_search_no_parameters(self):
	# 	"""
	# 	Ensure we CANNOT retrieve list of language objects when no search parameter is provided
	# 	"""
	# 	response = self.client.get('/api/language/search/', format='json')
	# 	self.assertEqual(response.status_code, status.HTTP_200_OK)
	# 	self.assertEqual(len(response.data['language_results']), 0)
	# 	self.assertEqual(response.data['language_results'], [])
		

	# def test_language_search_no_results(self):
	# 	"""
	# 	Ensure we CANNOT retrieve list of language objects with a non-existing given name.
	# 	"""
	# 	response = self.client.get('/api/language/search/?search_params=1_2_3_4_5_6', format='json')
	# 	self.assertEqual(response.status_code, status.HTTP_200_OK)
	# 	self.assertEqual(len(response.data['language_results']), 0)
	# 	self.assertEqual(response.data['language_results'], [])


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


class ArtAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_art_detail_route_exists(self):
		"""
		Ensure Art Detail API route exists
		"""
		response = self.client.get('/api/art/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


	def test_art_detail(self):
		"""
		Ensure we can retrieve a newly created art object.
		"""
		test_art = Art.objects.create(node_id=0)
		response = self.client.get('/api/art/{}/'.format(test_art.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_art_list_route_exists(self):
		"""
		Ensure art list API route exists
		"""
		response = self.client.get('/api/art/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
