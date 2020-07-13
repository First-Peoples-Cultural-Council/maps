from django.contrib import admin

from .models import (
    Language,
    LanguageLink,
    LanguageFamily,
    Community,
    CommunityLink,
    CommunityMember,
    Dialect,
    PlaceName,
    Champion,
    LNA,
    LNAData,
    Media,
    Favourite,
    Notification,
    Recording,
    Taxonomy,
    PlaceNameTaxonomy,
    RelatedData
)


# INLINES
class DialectInline(admin.TabularInline):
    model = Dialect

class LanguageLinkInline(admin.TabularInline):
    model = LanguageLink

class CommunityLinkInline(admin.TabularInline):
    model = CommunityLink


# ADMINS
class LanguageAdmin(admin.ModelAdmin):
    list_display = ("name", "sleeping", "family")
    exclude = ("audio_file",)
    search_fields = (
        "name",
        "family__name"
    )
    inlines = [
        DialectInline,
        LanguageLinkInline
    ]


class CommunityAdmin(admin.ModelAdmin):
    exclude = ("audio_file",)
    search_fields = (
        "name",
    )
    inlines = [
        CommunityLinkInline,
    ]


class DialectAdmin(admin.ModelAdmin):
    list_display = ("name", "language")
    search_fields = (
        "name",
        "language__name"
    )


class LNADataAdmin(admin.ModelAdmin):
    list_display = ("name", "fluent_speakers")
    search_fields = (
        "name",
    )


class RelatedDataAdmin(admin.ModelAdmin):
    list_display = ("label", "value")
    search_fields = (
        "label",
        "data_type",
        "value",
        "placename__name",
        "placename__kind"
    )


class PlaceNameAdmin(admin.ModelAdmin):
    list_display = ("name", "other_names", "creator")
    search_fields = (
        "name",
        "other_names",
        "creator__email",
        "creator__first_name",
        "creator__last_name",
    )
    exclude = ("audio_file",)


class MediaAdmin(admin.ModelAdmin):
    list_display = ("name", "file_type", "media_file", "url")
    search_fields = (
        "name",
        "file_type"
    )


class TaxonomyAdmin(admin.ModelAdmin):
    list_display = ("name", "parent")
    search_fields = (
        "name",
        "parent__name"
    )


class PlaceNameTaxonomyAdmin(admin.ModelAdmin):
    list_display = ("placename", "taxonomy")
    search_fields = (
        "placename__name",
        "taxonomy__name",
    )


admin.site.register(Champion)
admin.site.register(Dialect, DialectAdmin)
admin.site.register(PlaceName, PlaceNameAdmin)
admin.site.register(Language, LanguageAdmin)
admin.site.register(LanguageFamily)
admin.site.register(Community, CommunityAdmin)
admin.site.register(Media, MediaAdmin)
admin.site.register(Favourite)
admin.site.register(Notification)
admin.site.register(LNA)
admin.site.register(LNAData, LNADataAdmin)
admin.site.register(Recording)
admin.site.register(Taxonomy, TaxonomyAdmin)
admin.site.register(PlaceNameTaxonomy, PlaceNameTaxonomyAdmin)
admin.site.register(RelatedData, RelatedDataAdmin)
