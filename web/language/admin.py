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
)


class LanguageAdmin(admin.ModelAdmin):
    list_display = ("name", "sleeping", "family")


class LNADataAdmin(admin.ModelAdmin):
    list_display = ("fluent_speakers", "name")


admin.site.register(Champion)
admin.site.register(PlaceName)
admin.site.register(PlaceNameCategory)
admin.site.register(Language, LanguageAdmin)
admin.site.register(LanguageFamily)
admin.site.register(Community)
admin.site.register(CommunityMember)
admin.site.register(Media)
admin.site.register(Favourite)
admin.site.register(Notification)
admin.site.register(LNA)
admin.site.register(LNAData, LNADataAdmin)
