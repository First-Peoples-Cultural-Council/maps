from django.contrib.gis.db import models
from django.core.validators import MinValueValidator

from language.models import Language, Community, PlaceName


optional = {"blank": True, "null": True}


class GrantCategory(models.Model):
    name = models.TextField()
    abbreviation = models.CharField(max_length=255)
    order = models.IntegerField(default=None, **optional)
    parent = models.ForeignKey(
        "self", on_delete=models.SET_NULL, related_name="child_categories", **optional
    )

    def __str__(self):
        return "{} ({})".format(self.name, self.abbreviation)

    class Meta:
        verbose_name_plural = "Grant Categories"


class Grant(models.Model):
    grant = models.CharField(max_length=255, **optional)
    year = models.IntegerField(validators=[MinValueValidator(0)], **optional)
    language = models.CharField(max_length=255, **optional)
    recipient = models.TextField(**optional)
    community_affiliation = models.TextField(
        verbose_name="Community/Affiliation", **optional
    )
    languages = models.ManyToManyField(Language, related_name="grants", blank=True)
    recipients = models.ManyToManyField(PlaceName, related_name="grants", blank=True)
    communities_affiliations = models.ManyToManyField(
        Community,
        related_name="grants",
        verbose_name="Communities/Affiliations",
        blank=True,
    )
    title = models.TextField(**optional)
    project_brief = models.TextField(**optional)
    amount = models.DecimalField(
        validators=[MinValueValidator(0.0)],
        default=0.0,
        decimal_places=2,
        max_digits=100,
        **optional
    )
    address = models.TextField(**optional)
    city = models.CharField(max_length=255, **optional)
    province = models.CharField(max_length=255, **optional)
    postal_code = models.CharField(max_length=255, **optional)
    grant_category = models.ForeignKey(
        GrantCategory, on_delete=models.SET_NULL, **optional
    )
    point = models.PointField(null=True, default=None)
    modified = models.DateTimeField("date modified", auto_now=True)
    created = models.DateTimeField("date created", auto_now_add=True)

    def __str__(self):
        return self.grant

    class Meta:
        ordering = ["grant"]
