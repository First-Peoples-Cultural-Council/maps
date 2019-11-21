from django.contrib import admin
from .models import Page
from markdownx.admin import MarkdownxModelAdmin

admin.site.register(Page, MarkdownxModelAdmin)
