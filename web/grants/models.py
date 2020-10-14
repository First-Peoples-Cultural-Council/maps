from django.contrib.gis.db import models
from django.core.validators import MinValueValidator

from web.models import BaseModel

PROVINCE_CHOICES = (
    ('AB', 'Alberta'),
    ('BC', 'British Columbia'),
    ('MB', 'Manitoba'),
    ('NB', 'New Brunswick'),
    ('NL', 'Newfoundland and Labrador'),
    ('NT', 'Northwest Territories'),
    ('NS', 'Nova Scotia'),
    ('NU', 'Nunavut'),
    ('ON', 'Ontario'),
    ('PE', 'Prince Edward Island'),
    ('QC', 'Quebec'),
    ('SK', 'Saskatchewan'),
    ('YT', 'Yukon')
)

optional = {    
    'blank': True,
    'null': True
}


class Grant(models.Model):
    grant = models.CharField(max_length=255, **optional)
    year = models.IntegerField(
        validators=[MinValueValidator(0)],
        **optional)
    language = models.CharField(max_length=255, **optional)
    recipient = models.TextField(**optional)
    community_affiliation = models.TextField(
        verbose_name='Community/Affiliation',
        **optional)
    title = models.TextField(**optional)
    project_brief = models.TextField(**optional)
    amount = models.DecimalField(
        validators=[MinValueValidator(0.0)],
        default=0.0,
        decimal_places=2,
        max_digits=100,
        **optional)
    address = models.TextField(**optional)
    city = models.CharField(max_length=255, **optional)
    province = models.CharField(
        max_length=2,
        choices=PROVINCE_CHOICES,
        **optional)
    postal_code = models.CharField(max_length=6, **optional)
    category = models.CharField(max_length=255, **optional)
    point = models.PointField(null=True, default=None)
    modified = models.DateTimeField("date modified", auto_now=True)
    created = models.DateTimeField("date created", auto_now_add=True)

    def __str__(self):
        return self.grant

    class Meta:
        ordering = ['grant']
