from django.contrib import admin

from grants.models import Grant, GrantCategory


class GrantAdmin(admin.ModelAdmin):
    list_display = ("recipient", "grant", "year")
    search_fields = ("recipient", "grant", "year")


class GrantCategoryAdmin(admin.ModelAdmin):
    list_display = ("name", "abbreviation", "order")
    search_fields = (
        "name",
        "abbreviation",
    )


# Register your models here.
admin.site.register(Grant, GrantAdmin)
admin.site.register(GrantCategory, GrantCategoryAdmin)
