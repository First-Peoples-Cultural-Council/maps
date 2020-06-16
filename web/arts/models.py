from web.models import BaseModel
from django.contrib.gis.db import models


class Art(BaseModel):
    point = models.PointField(null=True, default=None)
    art_type = models.CharField(max_length=15, default="")
    node_id = models.IntegerField()
    details = models.TextField(default="")
