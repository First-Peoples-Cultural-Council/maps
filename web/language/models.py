from django.contrib.auth.models import User

from django.contrib.gis.db import models

from web.models import BaseModel


class LanguageFamily(BaseModel):
    color = models.CharField(default="RGB(0.5,0.5,0.5)", max_length=31)

    class Meta:
        verbose_name_plural = "Language Families"


class Language(BaseModel):
    other_names = models.TextField(default="", blank=True)
    fv_archive_link = models.URLField(max_length=255, blank=True, default="")
    color = models.CharField(max_length=31, default="")
    regions = models.CharField(max_length=255, default="", blank=True)
    sleeping = models.BooleanField(default=False)

    family = models.ForeignKey(
        LanguageFamily, null=True, on_delete=models.SET_NULL, blank=True
    )
    notes = models.TextField(default="", blank=True)
    fluent_speakers = models.IntegerField(
        default=0
    )  # sum of field_tm_lna2_on_fluent_sum_value
    some_speakers = models.IntegerField(default=0)  # field_tm_lna2_on_some_sum_value
    learners = models.IntegerField(default=0)  # sum of field_tm_lna2_on_lrn_sum_value
    pop_total_value = models.IntegerField(
        default=0
    )  # sum of field_tm_lna2_pop_total_value

    color = models.CharField(max_length=31)
    geom = models.PolygonField(null=True, default=None, blank=True)
    bbox = models.PolygonField(null=True, default=None, blank=True)
    audio_file = models.FileField(null=True, blank=True)


class LanguageLink(models.Model):
    url = models.URLField(max_length=255, default=None, null=True)
    title = models.CharField(max_length=255)
    language = models.ForeignKey(
        Language, on_delete=models.CASCADE, null=True, default=None
    )


class LanguageMember(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)


class Community(BaseModel):
    notes = models.TextField(default="", blank=True)
    point = models.PointField(null=True, default=None)
    regions = models.CharField(max_length=255, default="", blank=True)

    english_name = models.CharField(max_length=255, default="", blank=True)
    other_names = models.CharField(max_length=255, default="", blank=True)
    internet_speed = models.CharField(max_length=255, default="", blank=True)
    population = models.IntegerField(default=0)
    languages = models.ManyToManyField(Language)
    email = models.EmailField(max_length=255, default=None, null=True)
    website = models.URLField(max_length=255, default=None, null=True, blank=True)
    phone = models.CharField(max_length=255, default="", blank=True)
    alt_phone = models.CharField(max_length=255, default="", blank=True)
    fax = models.CharField(max_length=255, default="", blank=True)
    audio_file = models.FileField(null=True, blank=True)

    class Meta:
        verbose_name_plural = "Communities"


class CommunityLink(models.Model):
    url = models.URLField(max_length=255, default=None, null=True)
    title = models.CharField(max_length=255)
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, null=True, default=None
    )


class CommunityMember(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, null=True, default=None
    )


class PlaceNameCategory(BaseModel):
    icon_name = models.CharField(max_length=32, null=True, default=None)


class PlaceName(BaseModel):
    point = models.PointField(null=True, default=None)
    other_names = models.CharField(max_length=255, default="")
    audio_file = models.FileField(null=True, blank=True)
    kind = models.CharField(max_length=15, default="")

    category = models.ForeignKey(PlaceNameCategory, on_delete=models.SET_NULL, null=True)
    western_name = models.CharField(max_length=64, blank=True)
    traditional_name = models.CharField(max_length=64, blank=True)
    community_only = models.BooleanField(null=True)
    description = models.CharField(max_length=255, blank=True)

    # Choices Constants:
    FLAGGED = "FL"
    VERIFIED = "VE"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    STATUS_CHOICES = [
        (FLAGGED, 'Flagged'),
        (VERIFIED, 'Verified'),
    ]
    status = models.CharField(
        max_length=2,
        choices=STATUS_CHOICES,
        null=True,
        default=None,
    )
    

class Media(BaseModel):
    description = models.CharField(max_length=255, null=True, blank=True)
    file_type = models.CharField(max_length=16, default=None)
    url = models.CharField(max_length=255, default=None, null=True)
    media_file = models.FileField(null=True, blank=True)
    placename = models.ForeignKey(PlaceName, on_delete=models.SET_NULL, null=True, related_name='medias')


class Champion(BaseModel):
    bio = models.TextField(default="")
    job = models.CharField(max_length=255, default="")
    community = models.ForeignKey(
        Community, on_delete=models.SET_NULL, null=True, default=None
    )
    language = models.ForeignKey(
        Language, on_delete=models.SET_NULL, null=True, default=None
    )


class Dialect(BaseModel):
    language = models.ForeignKey(
        Language, on_delete=models.CASCADE, null=True, default=None
    )


class CommunityLanguageStats(BaseModel):
    language = models.ForeignKey(Language, on_delete=models.SET_NULL, null=True)
    community = models.ForeignKey(Community, on_delete=models.SET_NULL, null=True)


class LNA(BaseModel):
    """
    Deprecated
    """

    year = models.IntegerField(default=1970)
    language = models.ForeignKey(
        Language, on_delete=models.SET_NULL, null=True
    )  # field_tm_lna1_lang_target_id
    # nations = models.ManyToManyField(Community)  # field_tm_lna1_comms_servd_target_id
    # Held in LNAData model.


class LNAData(BaseModel):
    """
    Deprecated
    """

    lna = models.ForeignKey(
        LNA, on_delete=models.SET_NULL, null=True
    )  # field_tm_lna2_lna_target_id
    community = models.ForeignKey(Community, on_delete=models.SET_NULL, null=True)
    fluent_speakers = models.IntegerField(
        default=0
    )  # field_tm_lna2_on_fluent_sum_value
    some_speakers = models.IntegerField(default=0)  # field_tm_lna2_on_some_sum_value
    learners = models.IntegerField(default=0)  # field_tm_lna2_on_lrn_sum_value
    pop_off_res = models.IntegerField(default=0)  # field_tm_lna2_pop_off_res_value
    pop_on_res = models.IntegerField(default=0)  # field_tm_lna2_pop_on_res_value
    pop_total_value = models.IntegerField(default=0)  # field_tm_lna2_pop_total_value

    num_schools = models.IntegerField(default=0)
    nest_hours = models.FloatField(default=0)
    oece_hours = models.FloatField(default=0)
    info = models.TextField(default="")
    school_hours = models.FloatField(default=0)
