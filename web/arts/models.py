from web.models import BaseModel
from users.models import User
from django.contrib.gis.db import models


class Art(BaseModel):
    point = models.PointField(null=True, default=None)
    art_type = models.CharField(max_length=15, default="")
    node_id = models.IntegerField()
    details = models.TextField(default="")


class Association(BaseModel):
    pass


class ArtCategory(BaseModel):
    # Choices Constants:
    ARTIST = "ART"
    VISUAL = "VIS"
    PAINTER = "PAI"
    CARVER = "CAR"
    PERFORMING = "PER"
    MUSICIAN = "MUS"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    CATEGORY_CHOICES = [
        (ARTIST, "Artist"),
        (VISUAL, "Visual"),
        (PAINTER, "Painter"),
        (CARVER, "Carver"),
        (PERFORMING, "Performing"),
        (MUSICIAN, "Musician"),
    ]
    category_type = models.CharField(max_length=3, choices=CATEGORY_CHOICES)


class Artist(BaseModel):
    point = models.PointField(null=True, default=None)
    subtitle = models.CharField(max_length=128, null=True, blank=True)
    statement = models.TextField(null=True, blank=True, default="")

    # TODO: enable once data has been imported
    # categories = models.ManyToManyField("arts.ArtCategory")
    # associations = models.ManyToManyField("arts.Association")

    # Fields from User: bio, picture, first name, last name, email
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=None)

    # Fields which might go to User model
    phone = models.CharField(max_length=32, null=True, blank=True)
    address = models.CharField(max_length=128, null=True, blank=True)


class ArtistAward(BaseModel):
    artist = models.ForeignKey(Artist, on_delete=models.CASCADE)


class ArtistLink(BaseModel):
    artist = models.ForeignKey(Artist, on_delete=models.CASCADE)
    url = models.URLField(max_length=255, default=None, null=True)


class ArtistMedia(BaseModel):
    artist = models.ForeignKey(Artist, on_delete=models.CASCADE)
    description = models.TextField(null=True, blank=True, default="")
    media_file = models.FileField(null=True, blank=True)
    media_url = models.URLField(max_length=255, default=None, null=True)

    # Choices Constants:
    AUDIO = "AUD"
    VIDEO = "VID"
    PHOTO = "PHO"
    URL = "URL"
    ARTICLE = "ART"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    MEDIA_TYPES_CHOICES = [
        (AUDIO, "Audio"),
        (VIDEO, "Video"),
        (PHOTO, "Photo"),
        (URL, "Url"),
        (ARTICLE, "Article"),
    ]
    media_type = models.CharField(max_length=3, choices=MEDIA_TYPES_CHOICES)

