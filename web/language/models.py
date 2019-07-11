from django.contrib.auth.models import User

from django.contrib.gis.db import models


class BaseModel(models.Model):
    name = models.CharField(max_length=255, default='')

    def __str__(self):
        return self.name

    class Meta:
        abstract = True


class LanguageFamily(BaseModel):
    pass


class LanguageSubFamily(BaseModel):
    family = models.ForeignKey(
        LanguageFamily, on_delete=models.SET_NULL, null=True)


class Language(BaseModel):
    other_names = models.TextField(default='')
    fv_archive_link = models.URLField(max_length=255, blank=True, default='')
    color = models.CharField(max_length=31, default='')
    sub_family = models.ForeignKey(
        LanguageSubFamily, on_delete=models.SET_NULL, null=True)
    notes = models.TextField(default="")
    geom = models.MultiPolygonField(null=True, default=None)


class Community(BaseModel):
    point = models.PointField(null=True, default=None)
    english_name = models.CharField(max_length=255, default='')
    internet_speed = models.CharField(max_length=255, default='')
    population = models.IntegerField(default=0)
    language = models.ForeignKey(
        Language, on_delete=models.SET_NULL, null=True, default=None)
    email = models.EmailField(max_length=255, default=None, null=True)
    website = models.URLField(max_length=255, default=None, null=True)


class LanguageMember(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)


class PlaceName(BaseModel):
    point = models.PointField(null=True, default=None)
    other_name = models.CharField(max_length=255, default='')
    kind = models.CharField(max_length=15, default='')

class Champion(BaseModel):
    bio = models.TextField(default='')
    job = models.CharField(max_length=255, default='')
    community = models.ForeignKey(
        Community, on_delete=models.SET_NULL, null=True, default=None
    )
    language = models.ForeignKey(
        Language, on_delete=models.SET_NULL, null=True, default=None)


class Dialect(BaseModel):
    language = models.ForeignKey(
        Language, on_delete=models.CASCADE, null=True, default=None)
