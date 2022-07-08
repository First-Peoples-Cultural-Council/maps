from django.conf import settings
from django.core.exceptions import ValidationError
from django.db import models
from django.db.models.signals import post_save
from django.core.mail import send_mail
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.contrib.postgres.fields import ArrayField

from django.views.decorators.debug import sensitive_variables
from django.utils.translation import ugettext_lazy as _


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
            raise ValidationError(
                "Passwords must be at least 8 characters long")
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
    last_notified = models.DateTimeField(
        auto_now_add=True
    )
    picture = models.URLField(max_length=255, null=True)
    image = models.ImageField(null=True, blank=True, default=None)
    notification_frequency = models.IntegerField(default=7)
    artist_profile = models.ForeignKey(
        "language.Placename", on_delete=models.SET_NULL, default=None, blank=True, null=True
    )
    communities = models.ManyToManyField(
        "language.Community", through="language.CommunityMember"
    )
    other_community = models.CharField(
        max_length=64, default="", blank=True, null=True)

    languages = models.ManyToManyField("language.Language")
    non_bc_languages = ArrayField(models.CharField(
        max_length=200), blank=True, null=True, default=None)
    bio = models.TextField(null=True, blank=True, default="")

    def __str__(self):
        return self.get_full_name()
    
    @property
    def is_profile_complete(self):
        has_language = self.languages.count() > 0 or len(self.non_bc_languages) > 0
        has_community = self.communities.count() > 0 or self.other_community
        return bool(has_language and has_community)

    def get_full_name(self):
        if self.first_name:
            return "{} {}".format(self.first_name, self.last_name).strip()
        else:
            return "Someone Anonymous"
    
    def notify(self):
        from web.utils import get_admin_email_list

        admin_list = get_admin_email_list()

        message = """
            <h3>Greetings from First People's Cultural Council!</h3>
            <p>A new user has registered on our website <a href="https://maps.fpcc.ca/" target="_blank">First People's Map</a>.</p>
            <p>Email: %s</p>
            <p>Miigwech, and have a good day!</p>
        """ % self.email

        send_mail(
            subject="New First People's Map User",
            message=message,
            from_email="First Peoples' Cultural Council <%s>" % settings.SERVER_EMAIL,
            recipient_list=admin_list,
            html_message=message,
        )


class Administrator(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=None)
    language = models.ForeignKey(
        "language.Language", on_delete=models.CASCADE, default=None
    )
    community = models.ForeignKey(
        "language.Community", on_delete=models.CASCADE, default=None
    )

    def __str__(self):
        return 'User {}: language "{}", community "{}"'.format(
            self.user.username, self.language.name, self.community.name
        )


def user_post_save(sender, instance, created, **kwargs):
    user = instance

    if created:
        user.notify()

# Add Hook to User Model (Django Signals)
# For every User model update, trigger user_post_save function
post_save.connect(user_post_save, sender=User)
