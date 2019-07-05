from django.contrib.auth.models import User

from django.contrib.gis.db import models


class BaseModel(models.Model):

    def __str__(self):
        return self.name

    class Meta:
        abstract = True


class LanguageFamily(BaseModel):
    name = models.CharField(max_length=255)


class LanguageSubFamily(BaseModel):
    name = models.CharField(max_length=255)
    family = models.ForeignKey(
        LanguageFamily, on_delete=models.SET_NULL, null=True)


class Language(BaseModel):
    name = models.CharField(max_length=255)
    other_names = models.TextField(default='')
    fv_archive_link = models.URLField(max_length=255, blank=True, default='')
    color = models.CharField(max_length=31, default='')
    sub_family = models.ForeignKey(
        LanguageSubFamily, on_delete=models.SET_NULL, null=True)
    notes = models.TextField(default="")


class Community(BaseModel):
    name = models.CharField(max_length=255)
    english_name = models.CharField(max_length=255, default='')
    internet_speed = models.CharField(max_length=255, default='')
    point = models.PointField(null=True)
    population = models.IntegerField(default=0)
    language = models.ForeignKey(
        Language, on_delete=models.SET_NULL, null=True, default=None)
    email = models.EmailField(max_length=255, default=None, null=True)
    website = models.URLField(max_length=255, default=None, null=True)


class LanguageMember(BaseModel):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)


class PlaceName(BaseModel):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    text = models.CharField(max_length=255)
    point = models.PointField()


class Champion(BaseModel):
    name = models.CharField(max_length=255)


class Dialect(BaseModel):
    name = models.CharField(max_length=255)
