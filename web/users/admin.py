from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from users.models import User, Administrator
from users.forms import CustomUserCreationForm, CustomUserChangeForm


class CustomUserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm
    list_display = ("username", "email", "first_name", "last_name", "is_superuser")


class AdministratorAdmin(admin.ModelAdmin):
    list_display = ("user", "language", "community")
    search_fields = ("user", "language", "community")


admin.site.register(User, CustomUserAdmin)
admin.site.register(Administrator, AdministratorAdmin)
