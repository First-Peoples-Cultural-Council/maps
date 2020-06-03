# users/admin.py
from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin

from .forms import CustomUserCreationForm, CustomUserChangeForm
from .models import User, Administrator


class UserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm
    # model = User

    # The fields to be used in displaying the User model.
    # These override the definitions on the base UserAdmin
    # that reference specific fields on auth.User.
    # list_display = ('username', 'first_name', 'last_name', 'email', 'language', 'community')

    # fieldsets = (
    #     (None, {'fields': ('email', 'password')}),
    #     ('Personal info', {'fields': ('language',)}),
    #     ('Permissions', {'fields': ('is_staff',)}),
    # )
    # add_fieldsets is not a standard ModelAdmin attribute. UserAdmin
    # overrides get_fieldsets to use this attribute when creating a user.
    # add_fieldsets = (
    #     (None, {
    #         'classes': ('wide',),
    #         'fields': ('email', 'language', 'password1', 'password2')}
    #     ),
    # )


class AdministratorAdmin(admin.ModelAdmin):
    list_display = ("user", "language", "community")


admin.site.register(User, UserAdmin)
admin.site.register(Administrator, AdministratorAdmin)
