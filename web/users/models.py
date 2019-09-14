from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager

from django.views.decorators.debug import sensitive_variables
from django.utils.translation import ugettext_lazy as _

# from language.models import Language, Community


class UserManager(BaseUserManager):

    # TODO: define later which fields are necessary forto create a user
    # For the moment, language and community as not required

    @sensitive_variables("password")
    def create_user(self, username, password, email=None):
        """
        Creates and saves a User with the given email and password.
        """
        if not email:
            raise ValueError(_("Users must have an email address"))
        if len(password) < 8:
            raise ValidationError("Passwords must be at least 8 characters long")
        user = self.model(email=self.normalize_email(email))
        user.username = username
        user.set_password(password)
        user.save(using=self._db)
        return user

    @sensitive_variables("password")
    def create_superuser(self, username, password, email=None):
        """
        Creates and saves a superuser with the given email, and password.
        """
        user = self.create_user(username, password, email=email)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user


class User(AbstractUser):
    objects = UserManager()

    communities = models.ManyToManyField(
        "language.Community", through="language.CommunityMember"
    )

    languages = models.ManyToManyField("language.Language")
    bio = models.TextField(null=True, blank=True, default="")


class Administrator(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, default=None
    )
    language = models.ForeignKey(
        "language.Language", on_delete=models.CASCADE, default=None
    )
    community = models.ForeignKey(
        "language.Community", on_delete=models.CASCADE, default=None
    )
