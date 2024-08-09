from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

from users.forms import CustomUserCreationForm, CustomUserChangeForm
from users.models import User, Administrator


class UserAdmin(DjangoUserAdmin):
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm
    list_display = ("username", "email", "first_name", "last_name", "is_superuser")


class AdministratorAdmin(admin.ModelAdmin):
    list_display = ("user", "language", "community")
    search_fields = ("user", "language", "community")


admin.site.register(User, UserAdmin)
admin.site.register(Administrator, AdministratorAdmin)
