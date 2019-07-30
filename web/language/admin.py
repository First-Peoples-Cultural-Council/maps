from django.contrib import admin

from .models import (
    Language,
    LanguageFamily,
    LanguageSubFamily,
    Community,
    Dialect,
    PlaceName,
    Champion,
    LNA,
    LNAData,
)


class LanguageAdmin(admin.ModelAdmin):
    list_display = ("name", "sleeping")


class LNADataAdmin(admin.ModelAdmin):
    list_display = ("fluent_speakers", "name")


admin.site.register(Champion)
admin.site.register(PlaceName)
admin.site.register(Language, LanguageAdmin)
admin.site.register(LanguageFamily)
admin.site.register(LanguageSubFamily)
admin.site.register(Community)
admin.site.register(LNA)
admin.site.register(LNAData, LNADataAdmin)
