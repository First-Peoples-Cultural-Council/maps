# Create your tests here.
from rest_framework.test import APITestCase
from rest_framework import status

from django.contrib.gis.geos import GEOSGeometry
from django.core.cache import cache

from grants.models import Grant, GrantCategory


class BaseTestCase(APITestCase):
    def setUp(self):
        cache.clear()

        FAKE_POINT = """{
            "type": "Point",
            "coordinates": [1, 1]
        }"""

        self.test_category = GrantCategory.objects.create(
            name="Test Grant Categry", abbreviation="TGC"
        )

        self.test_grant = Grant.objects.create(
            grant="Test Grant",
            title="Test Grant Title",
            year=2024,
            point=GEOSGeometry(FAKE_POINT),
            grant_category=self.test_category,
        )

        self.test_grant_no_point = Grant.objects.create(
            grant="Test Grant No Point",
            title="Test Grant No Point Title",
            year=2024,
            grant_category=self.test_category,
        )


class GrantAPIRouteTests(BaseTestCase):
    def test_grant_list_route_exists(self):
        """
        Ensure Grant List API route exists
        """
        response = self.client.get("/api/grants/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_grant_detail_route_exists(self):
        """
        Ensure Grant Detail API route exists
        """
        response = self.client.get(f"/api/grants/{self.test_grant.id}/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_grant_category_route_exists(self):
        """
        Ensure Grant Categories List API route exists
        """
        response = self.client.get("/api/grant-categories/", format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class GrantAPITests(BaseTestCase):
    def test_grant_list(self):
        """
        Ensure Grant List API returns list of results with the correct data
        """
        response = self.client.get("/api/grants/", format="json")
        data = response.data
        features = data.get("features")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(features), 1)
        self.assertEqual(
            data["type"], "FeatureCollection"
        )  # Confirm that this is a Geo API
        self.assertEqual(features[0]["id"], self.test_grant.id)

    def test_grant_detail(self):
        """
        Ensure Grant Detail API returns list of results with the correct data
        """
        response = self.client.get(f"/api/grants/{self.test_grant.id}/", format="json")
        data = response.data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(data["id"], self.test_grant.id)

    def test_grant_category_list(self):
        """
        Ensure Grant Category List API returns list of results with the correct data
        """
        response = self.client.get("/api/grant-categories/", format="json")
        data = response.data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(data), 1)
        self.assertEqual(data[0]["id"], self.test_category.id)
