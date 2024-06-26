from rest_framework import serializers

from web.models import Page


class PageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Page
        fields = ("name", "content")
