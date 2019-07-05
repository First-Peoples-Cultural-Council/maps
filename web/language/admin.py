from django.contrib import admin

from .models import Language, LanguageFamily, LanguageSubFamily, Community, Dialect, PlaceName, Champion


class LanguageAdmin(admin.ModelAdmin):
    pass


admin.site.register(Champion)
admin.site.register(PlaceName)
admin.site.register(Language)
admin.site.register(LanguageFamily)
admin.site.register(LanguageSubFamily)
admin.site.register(Community)
