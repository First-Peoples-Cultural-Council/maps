from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from .models import (
    Art
)


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


	def test_art_list(self):
		"""
		Ensure we can retrieve newly created art objects.
		"""
		test_art1 = Art.objects.create(name='Test art 001', node_id="1000")

		response = self.client.get('/api/art/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		assert len(response.data) > 0