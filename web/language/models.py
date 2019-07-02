from django.contrib.auth.models import User

from django.contrib.gis.db import models


class Language(models.Model):
    name = models.CharField(max_length=255)
    # TODO: FV Arhive link
    # TODO: other names


class Community(models.Model):
    name = models.CharField(max_length=255)
    point = models.PointField()


class LanguageMember(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)


class PlaceName(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    text = models.CharField(max_length=255)
    point = models.PointField()


# TODO: class Dialect

# TODO: class LanguageFamily

