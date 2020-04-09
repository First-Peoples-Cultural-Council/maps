from django.contrib import admin

from .models import (
    Language,
    LanguageFamily,
    Community,
    CommunityMember,
    Dialect,
    PlaceName,
    PlaceNameCategory,
    Champion,
    LNA,
    LNAData,
    Media,
    Favourite,
    Notification,
    Recording,
    Taxonomy,
    PlaceNameTaxonomy
)


class LanguageAdmin(admin.ModelAdmin):
    list_display = ("name", "sleeping", "family")
    exclude = ("audio_file",)

class CommunityAdmin(admin.ModelAdmin):
    exclude = ("audio_file",)


class LNADataAdmin(admin.ModelAdmin):
    list_display = ("fluent_speakers", "name")


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


admin.site.register(Champion)
admin.site.register(PlaceName, PlaceNameAdmin)
admin.site.register(PlaceNameCategory)
admin.site.register(Language, LanguageAdmin)
admin.site.register(LanguageFamily)
admin.site.register(Community, CommunityAdmin)
admin.site.register(CommunityMember)
admin.site.register(Media)
admin.site.register(Favourite)
admin.site.register(Notification)
admin.site.register(LNA)
admin.site.register(LNAData, LNADataAdmin)
admin.site.register(Recording)
admin.site.register(Taxonomy)
admin.site.register(PlaceNameTaxonomy)
