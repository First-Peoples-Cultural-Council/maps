from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from django.contrib.auth.models import User


class UserAPITests(APITestCase):

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
		test_user = User.objects.create(
            username='testeuser001',
            first_name='Test',
            last_name='user 001',
            email='test@countable.ca',
        )
		response = self.client.get('/api/user/{}/'.format(test_user.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(response.data['id'], test_user.id)


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
		test_user = User.objects.create(
            username='testeuser001',
            first_name='Test',
            last_name='user 001',
            email='test@countable.ca',
        )
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

