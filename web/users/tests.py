from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from .models import User
from language.models import (
    Language,
    Community,
)


class UserAPITests(APITestCase):

	def setUp(self):
		self.language1 = Language.objects.create(name='Test language 001')
		self.language2 = Language.objects.create(name='Test language 002')
		self.community1 = Community.objects.create(name='Test community 001')
		self.community2 = Community.objects.create(name='Test community 002')

		self.user = User.objects.create(
            username = 'testeuser001',
            first_name = 'Test',
            last_name = 'user 001',
            email = 'test@countable.ca'
        )
		self.user.languages.add(self.language1)
		self.user.languages.add(self.language2)
		self.user.communities.add(self.community1)
		self.user.communities.add(self.community2)

	###### ONE TEST TESTS ONLY ONE SCENARIO ######

	def test_user_detail_route_exists(self):
		"""
		Ensure user Detail API route exists
		"""
		response = self.client.get('/api/user/0/', format='json')
		self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


	def test_user_detail(self):
		"""
		Ensure we can retrieve a newly created user object.
		"""
		response = self.client.get('/api/user/{}/'.format(self.user.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(response.data['id'], self.user.id)
		self.assertEqual(len(response.data['languages']), 2)
		self.assertEqual(len(response.data['communities']), 2)


	def test_user_list_route_exists(self):
		"""
		Ensure user list API route exists
		"""
		response = self.client.get('/api/user/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)


	def test_user_list(self):
		"""
		Ensure we can retrieve newly created user objects.
		"""
		response = self.client.get('/api/user/', format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)


	def test_user_post_not_allowed(self):
		"""
		Ensure user API POST method API is not allowed
		"""
		response = self.client.post('/api/user/', {
            'username': 'testeuser001', 
            'first_name': 'Test', 
            'last_name': 'user 001',
            'email': 'test@countable.ca'}, format='json')
		self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

