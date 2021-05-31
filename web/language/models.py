from django.conf import settings
from django.contrib.gis.db import models
from django.db.models.signals import post_save
from django.core.mail import send_mail
from django.contrib.postgres.fields import ArrayField

from web.models import BaseModel, CulturalModel
from web.utils import get_art_link, get_comm_link, get_place_link
from users.models import User

class LanguageFamily(BaseModel):
    color = models.CharField(default="RGB(0.5,0.5,0.5)", max_length=31)

    class Meta:
        verbose_name_plural = "Language Families"


class Recording(models.Model):

    def __str__(self):
        return str(self.audio_file)

    audio_file = models.FileField(null=True, blank=True)
    speaker = models.CharField(max_length=255, null=True)
    recorder = models.CharField(max_length=255, null=True)
    created = models.DateTimeField("date created", auto_now_add=True)
    date_recorded = models.DateField("date recorded", null=True)


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
    # field_tm_lna2_on_some_sum_value
    some_speakers = models.IntegerField(default=0)
    # sum of field_tm_lna2_on_lrn_sum_value
    learners = models.IntegerField(default=0)
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


class Community(CulturalModel):
    notes = models.TextField(default="", blank=True)
    point = models.PointField(null=True, default=None)
    regions = models.CharField(max_length=255, default="", blank=True)
    # field_tm_fn_grp_code_value from the old db.
    nation_id = models.IntegerField(null=True, blank=True)
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
    # @Denis, I suspect this should be represented as an attribute of the membership object, not another m2m [cvo]
    # language_admins = models.ManyToManyField(LanguageMember)

    email = models.EmailField(
        max_length=255, default=None, null=True, blank=True)
    website = models.URLField(
        max_length=255, default=None, null=True, blank=True)
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
        ordering = ["name"]


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
    status = models.CharField(
        max_length=2, choices=STATUS_CHOICES, default=UNVERIFIED)

    ROLE_ADMIN = "RA"
    ROLE_MEMBER = "RM"
    ROLE_CHOICES = ((ROLE_ADMIN, "Community Admin"),
                    (ROLE_MEMBER, "Community Member"))
    role = models.CharField(
        max_length=2, choices=ROLE_CHOICES, default=ROLE_MEMBER)

    class Meta:
        unique_together = ("user", "community")

    def create_member(user_id, community_id):
        member = CommunityMember()
        member.user = User.objects.get(pk=user_id)
        member.community = Community.objects.get(pk=community_id)
        member.status = CommunityMember.UNVERIFIED
        member.save()

        return member

    def member_exists(user_id, community_id):
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

    def reject_member(id):
        member = CommunityMember.objects.get(pk=int(id))
        member.status = CommunityMember.REJECTED
        member.save()

    class Meta:
        verbose_name_plural = "Community Members"


class PlaceName(CulturalModel):# Choices Constants:
    # DIFFERENT TYPES OF PLACENAMES
    PUBLIC_ART = "public_art"
    ORGANIZATION = "organization"
    ARTIST = "artist"
    EVENT = "event"
    RESOURCE = "resource"
    GRANT = "grant"
    POI = "poi"

    KIND_CHOICES = [
        (PUBLIC_ART, "Public Art"),
        (ORGANIZATION, "Organization"),
        (ARTIST, "Artist"),
        (EVENT, "Event"),
        (RESOURCE, "Resource"),
        (GRANT, "Grant"),
        (POI, "Point of Interest"),
    ]

    geom = models.GeometryField(null=True, default=None)
    image = models.ImageField(null=True, blank=True, default=None)

    # 3 deprecated. Use Recording.
    audio_file = models.FileField(null=True, blank=True)
    audio_name = models.CharField(max_length=64, null=True, blank=True)
    audio_description = models.TextField(null=True, blank=True, default="")
    # 3 deprecated. Use Recording.
    audio = models.ForeignKey(
        Recording, on_delete=models.SET_NULL, null=True, blank=True
    )

    kind = models.CharField(max_length=20, default="", choices=KIND_CHOICES)
    common_name = models.CharField(max_length=64, blank=True)
    community_only = models.BooleanField(null=True)
    description = models.TextField(default="")

    creator = models.ForeignKey(
        "users.User", null=True, blank=True, on_delete=models.SET_NULL)
    language = models.ForeignKey(
        Language, null=True, blank=True, default=None, on_delete=models.SET_NULL, related_name="places"
    )
    non_bc_languages = ArrayField(models.CharField(
        max_length=200), blank=True, null=True,  default=None)
    community = models.ForeignKey(
        Community, null=True, blank=True, default=None, on_delete=models.SET_NULL, related_name="places"
    )
    other_community = models.CharField(max_length=64, default="", blank=True, null=True)
    taxonomies = models.ManyToManyField(
        'Taxonomy',
        through='PlaceNameTaxonomy',
    )
    public_arts = models.ManyToManyField(
        'self',
        symmetrical=False,
        through='PublicArtArtist',
        through_fields=('artist', 'public_art'),
        related_name='public_arts+'
    )
    artists = models.ManyToManyField(
        'self',
        symmetrical=False,
        through='PublicArtArtist',
        through_fields=('public_art', 'artist'),
        related_name='artists+'
    )

    # Choices Constants:
    FLAGGED = "FL"
    UNVERIFIED = "UN"
    VERIFIED = "VE"
    REJECTED = "RE"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    STATUS_CHOICES = [
        (UNVERIFIED, "Unverified"),
        (FLAGGED, "Flagged"),
        (VERIFIED, "Verified"),
        (REJECTED, "Rejected"),
    ]
    status = models.CharField(
        max_length=2, choices=STATUS_CHOICES, null=True, default=UNVERIFIED
    )
    status_reason = models.TextField(default="", blank=True)

    def verify(id):
        media = PlaceName.objects.get(pk=id)
        media.status = PlaceName.VERIFIED
        media.status_reason = ""
        media.save()

    def reject(id, status_reason):
        media = PlaceName.objects.get(pk=id)
        media.status = PlaceName.REJECTED
        media.status_reason = status_reason
        media.save()

    def flag(id, status_reason):
        media = PlaceName.objects.get(pk=id)
        media.status = PlaceName.FLAGGED
        media.status_reason = status_reason
        media.save()
    
    def notify(self):
        from web.utils import get_admin_email_list

        admin_list = get_admin_email_list()

        formatted_kind = self.kind.upper().replace('_', ' ')
        page = get_place_link(self) if self.kind == '' or self.kind == 'poi' else get_art_link(self)

        message = """
            <h3>Greetings from First People's Cultural Council!</h3>
            <p>A new {} was added on our website <a href="https://maps.fpcc.ca/" target="_blank">First People's Map</a>.</p>
            <p>Page: {}</p>
            <p>Miigwech, and have a good day!</p>
        """.format(formatted_kind, page)

        send_mail(
            subject="New People's Map %s" % formatted_kind,
            message=message,
            from_email="First Peoples' Cultural Council <%s>" % settings.SERVER_EMAIL,
            recipient_list=admin_list if not settings.DEBUG else [
                'justin@countable.ca'],
            html_message=message,
        )
    
    class Meta:
        verbose_name_plural = "Place Names"


class Media(BaseModel):
    name = models.CharField(max_length=255, default="")
    description = models.TextField(default="", blank=True)
    file_type = models.CharField(max_length=16, default=None, null=True)
    url = models.URLField(max_length=255, default=None, null=True, blank=True)
    media_file = models.FileField(null=True, blank=True, max_length=500)
    community_only = models.BooleanField(null=True)
    placename = models.ForeignKey(
        PlaceName, on_delete=models.SET_NULL, null=True, blank=True, related_name="medias"
    )
    community = models.ForeignKey(
        Community, on_delete=models.SET_NULL, null=True, blank=True, default=None, related_name="medias"
    )
    creator = models.ForeignKey(
        "users.User", null=True, on_delete=models.SET_NULL)

    # Artwork specific types
    mime_type = models.CharField(
        max_length=100, default=None, null=True, blank=True)
    is_artwork = models.BooleanField(default=False)

    # Choices Constants:
    FLAGGED = "FL"
    UNVERIFIED = "UN"
    VERIFIED = "VE"
    REJECTED = "RE"
    # Choices:
    # first element: constant Python identifier
    # second element: human-readable version
    STATUS_CHOICES = [
        (UNVERIFIED, "Unverified"),
        (FLAGGED, "Flagged"),
        (VERIFIED, "Verified"),
        (REJECTED, "Rejected"),
    ]
    status = models.CharField(
        max_length=2, choices=STATUS_CHOICES, null=True, default=UNVERIFIED
    )
    status_reason = models.TextField(default="", blank=True)

    def verify(id):
        media = Media.objects.get(pk=id)
        media.status = Media.VERIFIED
        media.status_reason = ""
        media.save()

    def reject(id, status_reason):
        media = Media.objects.get(pk=id)
        media.status = Media.REJECTED
        media.status_reason = status_reason
        media.save()

    def flag(id, status_reason):
        media = Media.objects.get(pk=id)
        media.status = Media.FLAGGED
        media.status_reason = status_reason
        media.save()
    
    def notify(self):
        from web.utils import get_admin_email_list

        admin_list = get_admin_email_list()

        if self.placename:
            page = get_art_link(self.placename)
        elif self.community:
            page = get_comm_link(self.community)
        else:
            page = ''       
        
        formatted_kind = "ARTWORK" if self.is_artwork else "MEDIA"

        message = """
            <h3>Greetings from First People's Cultural Council!</h3>
            <p>A new {} was added on our website <a href="https://maps.fpcc.ca/" target="_blank">First People's Map</a>.</p>
            <p>Page: {}</p>
            <p>Miigwech, and have a good day!</p>
        """.format(formatted_kind, page)

        send_mail(
            subject="New People's Map %s" % formatted_kind,
            message=message,
            from_email="First Peoples' Cultural Council <%s>" % settings.SERVER_EMAIL,
            recipient_list=admin_list if not settings.DEBUG else [
                'justin@countable.ca'],
            html_message=message,
        )

    class Meta:
        ordering = ('-id', )


class RelatedData(models.Model):
    data_type = models.CharField(max_length=100, unique=False)
    label = models.CharField(max_length=100, unique=False, default='')
    value = models.CharField(max_length=255, default='')
    is_private = models.BooleanField(default=False)
    placename = models.ForeignKey(
        PlaceName, related_name='related_data', on_delete=models.CASCADE)
    
    class Meta:
        verbose_name_plural = "Related Data"


class Favourite(BaseModel):
    name = models.CharField(max_length=255, blank=True, default="")
    user = models.ForeignKey(
        User, on_delete=models.SET_NULL, default=None, null=True)
    place = models.ForeignKey(
        PlaceName, on_delete=models.SET_NULL, null=True, related_name="favourites"
    )
    media = models.ForeignKey(Media, on_delete=models.SET_NULL, null=True)

    favourite_type = models.CharField(
        max_length=16, null=True, blank=True, default="")
    description = models.CharField(
        max_length=255, null=True, blank=True, default="")
    point = models.PointField(null=True, default=None)
    zoom = models.IntegerField(default=0)

    def favourite_place_already_exists(user_id, place_id):
        favourite = Favourite.objects.filter(
            user__id=user_id).filter(place_id=place_id)
        if favourite:
            return True
        else:
            return False

    def favourite_media_already_exists(user_id, media_id):
        favourite = Favourite.objects.filter(
            user__id=user_id).filter(media_id=media_id)
        if favourite:
            return True
        else:
            return False


class Notification(BaseModel):
    name = models.CharField(max_length=255, blank=True, default="")
    user = models.ForeignKey("users.User", null=True,
                             on_delete=models.SET_NULL)
    language = models.ForeignKey(
        Language, null=True, default=None, on_delete=models.SET_NULL
    )
    community = models.ForeignKey(
        Community, on_delete=models.SET_NULL, null=True, default=None
    )


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


class PublicArtArtist(models.Model):
    public_art = models.ForeignKey(
        PlaceName, on_delete=models.CASCADE, related_name='art_artists')
    artist = models.ForeignKey(
        PlaceName, on_delete=models.CASCADE, related_name='artist_arts')

    def __str__(self):
        return "{} ({})".format(self.public_art, self.artist)


class Taxonomy(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(default='', blank=True, null=True)
    order = models.IntegerField(
        default=None,
        null=True,
        blank=True,
        help_text='Value that determines the ordering of taxonomy. The lower the value is, the higher it is on the list')
    parent = models.ForeignKey(
        'self',
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name='child_taxonomies')

    def __str__(self):
        return "{}".format(self.name)
    
    class Meta:
        verbose_name_plural = "Taxonomies"


class PlaceNameTaxonomy(models.Model):
    placename = models.ForeignKey(
        PlaceName, on_delete=models.SET_NULL, null=True)
    taxonomy = models.ForeignKey(
        Taxonomy, on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return "{} ({})".format(self.placename, self.taxonomy)
    
    class Meta:
        verbose_name_plural = "Place Name Taxonomies"


class LNA(BaseModel):
    """
    Deprecated
    """

    year = models.IntegerField(default=1970)
    language = models.ForeignKey(
        Language, on_delete=models.SET_NULL, null=True
    )  # field_tm_lna1_lang_target_id
    
    class Meta:
        verbose_name_plural = "LNA"


class LNAData(BaseModel):
    """
    Deprecated
    """

    lna = models.ForeignKey(
        LNA, on_delete=models.SET_NULL, null=True
    )  # field_tm_lna2_lna_target_id
    community = models.ForeignKey(
        Community, on_delete=models.SET_NULL, null=True)
    fluent_speakers = models.IntegerField(
        default=0
    )  # field_tm_lna2_on_fluent_sum_value
    # field_tm_lna2_on_some_sum_value
    some_speakers = models.IntegerField(default=0)
    learners = models.IntegerField(default=0)  # field_tm_lna2_on_lrn_sum_value
    # field_tm_lna2_pop_off_res_value
    pop_off_res = models.IntegerField(default=0)
    # field_tm_lna2_pop_on_res_value
    pop_on_res = models.IntegerField(default=0)
    pop_total_value = models.IntegerField(
        default=0)  # field_tm_lna2_pop_total_value

    num_schools = models.IntegerField(default=0)
    nest_hours = models.FloatField(default=0)
    oece_hours = models.FloatField(default=0)
    info = models.TextField(default="")
    school_hours = models.FloatField(default=0)
    
    class Meta:
        verbose_name_plural = "LNA Data"


def placename_post_save(sender, instance, created, **kwargs):
    placename = instance

    if created:
        placename.notify()

def media_post_save(sender, instance, created, **kwargs):
    media = instance

    if created:
        media.notify()

# Add Django Signals for PlaceName and Media
# For every PlaceName model update, trigger user_post_save function
post_save.connect(placename_post_save, sender=PlaceName)
post_save.connect(media_post_save, sender=Media)
