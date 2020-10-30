from django.contrib import admin

from .models import Grant, GrantCategory

class GrantAdmin(admin.ModelAdmin):
    list_display = ("recipient", "grant", "year")
    search_fields = (
        "recipient",
        "grant",
        "year"
    )

# Register your models here.
admin.site.register(Grant, GrantAdmin)
admin.site.register(GrantCategory)
