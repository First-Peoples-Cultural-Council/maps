from django.contrib.gis.db import models


class BaseModel(models.Model):
    name = models.CharField("Traditional Name", max_length=255, default="", unique=True)
    modified = models.DateTimeField("date modified", auto_now=True)
    created = models.DateTimeField("date created", auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        abstract = True
        ordering = ["name"]


class CulturalModel(BaseModel):
    # mapped_spellings = models.CharField(max_length=255, default="")
    other_names = models.CharField(max_length=255, default="", blank=True)

    class Meta:
        abstract = True
        ordering = ["name"]


class Page(BaseModel):
    content = models.TextField(default="")
