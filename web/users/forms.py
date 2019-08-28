# users/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from .models import User


class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm):
        model = User
        # fields = UserCreationForm.Meta.fields + ('community', 'languages', 'communities')
        fields = ("email", "languages", "community")


class CustomUserChangeForm(UserChangeForm):
    class Meta:
        model = User
        # fields = CustomUserChangeForm.Meta.fields + ('community', 'languages', 'communities')
        fields = (
            "email",
            "password",
            "languages",
            "community",
            "is_active",
            "is_staff",
        )
