from django.contrib.gis.db import models


class BaseModel(models.Model):
    name = models.CharField(max_length=255, default="")

    def __str__(self):
        return self.name

    class Meta:
        abstract = True
        ordering = ["name"]
