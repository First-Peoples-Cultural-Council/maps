from django.contrib import admin

from .models import Grant, GrantCategory

# Register your models here.
admin.site.register(Grant)
admin.site.register(GrantCategory)
