from django.contrib.gis.db import models

from users.models import User

from web.models import BaseModel, CulturalModel


class LanguageFamily(BaseModel):
    color = models.CharField(default="RGB(0.5,0.5,0.5)", max_length=31)

    class Meta:
        verbose_name_plural = "Language Families"


class Recording(models.Model):
    speaker = models.CharField(max_length=255)
    recorder = models.CharField(max_length=255)
    created = models.DateTimeField("date created", auto_now_add=True)
    date_recorded = models.DateField("date recorded")


class Language(CulturalModel):
    """
    family

    aliases (comma separated)
    total_schools

    avg_hrs_wk_languages_in_school

    ece_programs
    avg_hrs_wk_languages_in_ece
    language_nests
    avg_hrs_wk_languages_in_language_nests
    community_adult_language_classes
    language_audio (should include speaker, recorder, date recorded fields)
    greeting_audio (should include speaker, recorder, date recorded fields)
    fv_guid
    fv_url
    """

    family = models.ForeignKey(
        LanguageFamily, null=True, on_delete=models.SET_NULL, blank=True
    )
    total_schools = models.IntegerField(default=0)
    avg_hrs_wk_languages_in_school = models.FloatField(default=0)
    ece_programs = models.IntegerField(default=0)
    avg_hrs_wk_languages_in_ece = models.FloatField(default=0)
    language_nests = models.IntegerField(default=0)
    avg_hrs_wk_languages_in_language_nests = models.FloatField(default=0)
    community_adult_language_classes = models.IntegerField(default=0)
    language_audio = models.ForeignKey(
        Recording,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="languages",
    )
    greeting_audio = models.ForeignKey(
        Recording,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="greeting_languages",
    )
    fv_guid = models.CharField(max_length=40, blank=True, default="")
    fv_archive_link = models.URLField(max_length=255, blank=True, default="")

    color = models.CharField(max_length=31, default="")
    regions = models.CharField(max_length=255, default="", blank=True)
    sleeping = models.BooleanField(default=False)

    notes = models.TextField(default="", blank=True)

    # Deprecated (switch to CommunityLanguageStats)
    fluent_speakers = models.IntegerField(
        default=0
    )  # sum of field_tm_lna2_on_fluent_sum_value
    some_speakers = models.IntegerField(default=0)  # field_tm_lna2_on_some_sum_value
    learners = models.IntegerField(default=0)  # sum of field_tm_lna2_on_lrn_sum_value
    pop_total_value = models.IntegerField(
        default=0
    )  # sum of field_tm_lna2_pop_total_value

    geom = models.PolygonField(null=True, default=None, blank=True)
    bbox = models.PolygonField(null=True, default=None, blank=True)

    # Deprecated, use recording instead.
    audio_file = models.FileField(null=True, blank=True)


class LanguageLink(models.Model):
    url = models.URLField(max_length=255, default=None, null=True)
    title = models.CharField(max_length=255)
    language = models.ForeignKey(
        Language, on_delete=models.CASCADE, null=True, default=None
    )


# class LanguageMember(models.Model):
#     user = models.ForeignKey("users.User", on_delete=models.CASCADE, default=None, null=True)
#     language = models.ForeignKey(
#         Language, on_delete=models.CASCADE, null=True, default=None
#     )

#     def create_member(user_id, language_id):
#         member = LanguageMember()
#         member.user = User.objects.get(pk=user_id)
#         member.language = Language.objects.get(pk=language_id)
#         member.save()

#         return member

#     def member_already_exists(user_id, language_id):
#         member = LanguageMember.objects.filter(
#             user__id=user_id
#         ).filter(
#             language__id=language_id
#         )
#         if member:
#             return True
#         else:
#             return False

#     class Meta:
#         unique_together = ('user', 'language',)


class Community(CulturalModel):
    notes = models.TextField(default="", blank=True)
    point = models.PointField(null=True, default=None)
    regions = models.CharField(max_length=255, default="", blank=True)

    english_name = models.CharField(max_length=255, default="", blank=True)
    internet_speed = models.CharField(max_length=255, default="", blank=True)
    # TODO: just add off + on reserve populations. Deprecated.
    population = models.IntegerField(default=0)

    population_on_reserve = models.IntegerField(default=0)
    population_off_reserve = models.IntegerField(default=0)

    fv_guid = models.CharField(max_length=40, blank=True, default="")
    fv_archive_link = models.URLField(max_length=255, blank=True, default="")
    languages = models.ManyToManyField(Language)

    # One community can have more than one admin (i.e.: a couple)
    # It is linked to LanguageMember and not to User because a
    # Language Admin is not any User. It is a special one.
    # language_admins = models.ManyToManyField(LanguageMember)

    email = models.EmailField(max_length=255, default=None, null=True)
    website = models.URLField(max_length=255, default=None, null=True, blank=True)
    phone = models.CharField(max_length=255, default="", blank=True)
    alt_phone = models.CharField(max_length=255, default="", blank=True)
    fax = models.CharField(max_length=255, default="", blank=True)

    # deprecated. TODO: change to recording.
    audio_file = models.FileField(null=True, blank=True)
    audio = models.ForeignKey(
        Recording, on_delete=models.SET_NULL, null=True, blank=True
    )

    class Meta:
        verbose_name_plural = "Communities"


class CommunityLink(models.Model):
    url = models.URLField(max_length=255, default=None, null=True)
    title = models.CharField(max_length=255)
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, null=True, default=None
    )


class CommunityLanguageStats(models.Model):
    """
    Latest, manually cleaned, aggregated LNA information for a given langugage in a particular community.
    """

    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    community = models.ForeignKey(Community, on_delete=models.CASCADE)
    fluent_speakers = models.IntegerField(default=0)
    semi_speakers = models.IntegerField(default=0)
    active_learners = models.IntegerField(default=0)


class CommunityMember(models.Model):
    user = models.ForeignKey(
        "users.User", on_delete=models.CASCADE, default=None, null=True
    )
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, null=True, default=None
    )

    # Choices Constants:
    UNVERIFIED = "UN"
    VERIFIED = "VE"
    REJECTED = "RE"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    STATUS_CHOICES = [
        (UNVERIFIED, "Unverified"),
        (VERIFIED, "Verified"),
        (REJECTED, "Rejected"),
    ]
    status = models.CharField(max_length=2, choices=STATUS_CHOICES, default=UNVERIFIED)

    class Meta:
        unique_together = ("user", "community")

    def create_member(user_id, community_id):
        member = CommunityMember()
        member.user = User.objects.get(pk=user_id)
        member.community = Community.objects.get(pk=community_id)
        member.save()

        return member

    def member_already_exists(user_id, community_id):
        member = CommunityMember.objects.filter(user__id=user_id).filter(
            community__id=community_id
        )
        if member:
            return True
        else:
            return False

    def verify_member(id):
        member = CommunityMember.objects.get(pk=int(id))
        member.status = CommunityMember.VERIFIED
        member.save()

    class Meta:
        verbose_name_plural = "Community Members"


class PlaceNameCategory(BaseModel):
    icon_name = models.CharField(max_length=32, null=True, default=None)

    class Meta:
        verbose_name_plural = "Place name Categories"


class PlaceName(CulturalModel):
    point = models.PointField(null=True, default=None)
    audio_file = models.FileField(null=True, blank=True)
    kind = models.CharField(max_length=15, default="")

    category = models.ForeignKey(
        PlaceNameCategory, on_delete=models.SET_NULL, null=True
    )
    western_name = models.CharField(max_length=64, blank=True)
    community_only = models.BooleanField(null=True)
    description = models.CharField(max_length=255, blank=True)

    language = models.ForeignKey(
        Language, null=True, default=None, on_delete=models.CASCADE
    )
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, null=True, default=None
    )

    # Choices Constants:
    FLAGGED = "FL"
    VERIFIED = "VE"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    STATUS_CHOICES = [(FLAGGED, "Flagged"), (VERIFIED, "Verified")]
    status = models.CharField(
        max_length=2, choices=STATUS_CHOICES, null=True, default=None
    )


class Media(BaseModel):
    description = models.CharField(max_length=255, null=True, blank=True)
    file_type = models.CharField(max_length=16, default=None)
    url = models.CharField(max_length=255, default=None, null=True)
    media_file = models.FileField(null=True, blank=True)
    placename = models.ForeignKey(
        PlaceName, on_delete=models.SET_NULL, null=True, related_name="medias"
    )


class MediaFavourite(BaseModel):
    # user = models.ForeignKey(User, on_delete=models.CASCADE, default=None, null=True)
    media = models.ForeignKey(Media, on_delete=models.CASCADE)

    def create_favourite(user_id, media_id):
        favourite = MediaFavourite()
        favourite.user = User.objects.get(pk=user_id)
        favourite.media = Media.objects.get(pk=media_id)
        favourite.save()

        return favourite

    def favourite_already_exists(user_id, media_id):
        favourite = MediaFavourite.objects.filter(user__id=user_id).filter(
            media__id=media_id
        )
        if favourite:
            return True
        else:
            return False


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
