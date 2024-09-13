from markdownx.admin import MarkdownxModelAdmin

from django.contrib import admin

from web.models import Page
from web.models import Page

admin.site.register(Page, MarkdownxModelAdmin)
