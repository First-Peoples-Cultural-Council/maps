from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status

from .models import Language


class LanguageAPITests(APITestCase):

	###### ONE TEST TESTS ONLY ONE SCENARIO ######


	def test_language_detail(self):
		"""
		Ensure we can retrieve a newly created language object.
		"""
		test_language = Language.objects.create(name='Test Language 001')
		response = self.client.get('/api/language/{}/'.format(test_language.id), format='json')
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(response.data['name'], 'Test Language 001')
    
