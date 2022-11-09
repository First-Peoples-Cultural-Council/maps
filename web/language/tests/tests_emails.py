from django.test import TestCase
from django.utils import timezone

from datetime import timedelta

from language.notifications import (
    notify,
    inform_placename_rejected_or_flagged,
    inform_placename_to_be_verified,
    inform_media_rejected_or_flagged,
    inform_media_to_be_verified,
)
from users.models import User, Administrator
from language.models import (
    Language,
    Community,
    PlaceName,
    Media,
    CommunityMember,
    Favourite,
)
from web.constants import *


class EmailTests(TestCase):
    def setUp(self):
        self.from_email = 'maps@fpcc.ca'
        self.to = 'justin@countable.ca'

        self.test_language = Language.objects.create(
            name="Global Test Language")
        self.test_community = Community.objects.create(
            name="Global Test Community")

        self.admin_user = User.objects.create(
            username="admin_user",
            first_name="Admin",
            last_name="User",
            email=self.to,
            is_staff=True,
            is_superuser=True,
        )
        self.admin_user.set_password("password")
        self.admin_user.languages.add(self.test_language)
        self.admin_user.save()

        self.regular_user = User.objects.create(
            username="regular_user",
            first_name="Regular",
            last_name="User",
            email="regular_user@countable.ca",
        )

        self.placename = PlaceName.objects.create(
            name="Test Placename",
            community=self.test_community,
            language=self.test_language,
            creator=self.admin_user,
            status=VERIFIED,
        )

        self.media = Media.objects.create(
            name="Test Media",
            file_type="string",
            placename=self.placename,
            creator=self.admin_user,
            status=VERIFIED,
        )

    def test_notify(self):
        # Make Admin User a member of the test community
        CommunityMember.objects.create(
            user=self.admin_user,
            community=self.test_community,
            status=VERIFIED
        )

        # Make Admin User a member of the new community
        new_community = Community.objects.create(
            name="New Community")
        CommunityMember.objects.create(
            user=self.admin_user,
            community=new_community,
            status=UNVERIFIED
        )

        # Favourite Placename created by Admin User to notify him
        Favourite.objects.create(
            name="Favorite Placename",
            user=self.regular_user,
            place=self.placename,
            favourite_type="favourite",
            description="I like this Placename",
        )

        # Favourite Media uploaded by Admin User to notify him
        Favourite.objects.create(
            name="Favorite Media",
            user=self.regular_user,
            media=self.media,
            favourite_type="favourite",
            description="I like this Media",
        )

        # Create Placename under Admin User's language to notify him
        PlaceName.objects.create(
            name="New Placename",
            community=self.test_community,
            language=self.test_language,
            status=VERIFIED,
        )

        user = User.objects.get(email=self.admin_user.email)
        body = notify(user, timezone.now() - timedelta(days=7))

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename.name) > 0

        # Testing if the placename was not sent more than once
        self.assertEqual(body.count("Someone uploaded a new place:"), 1)

        # Testing if the media was not sent more than once
        self.assertEqual(body.count("has a new media uploaded"), 1)

        # Testing if the placename favourite was sent in the email
        self.assertEqual(body.count("your place was favourited!"), 1)

        # Testing if the media favourite was sent in the email
        self.assertEqual(body.count("your contribution was favourited!"), 1)

    def test_inform_placename_rejected_or_flagged(self):
        reason = "wrong place"
        body = inform_placename_rejected_or_flagged(
            self.placename.id, reason, REJECTED)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename.name) > 0

        assert body.count(reason) > 0
        assert body.count("rejected") > 0
        assert body.count("flagged") == 0

        body = inform_placename_rejected_or_flagged(
            self.placename.id, reason, FLAGGED)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename.name) > 0

        assert body.count(reason) > 0
        assert body.count("flagged") > 0
        assert body.count("rejected") == 0

    def test_inform_placename_to_be_verified(self):
        Administrator.objects.create(
            user=self.admin_user,
            language=self.test_language,
            community=self.test_community,
        )

        self.placename.status = UNVERIFIED
        self.placename.status_reason = "wrong media"
        self.placename.save()

        body = inform_placename_to_be_verified(self.placename.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename.name) > 0

        assert body.count(self.placename.status_reason) > 0
        assert body.count("created") > 0
        assert body.count("flagged") == 0

        self.placename.status = FLAGGED
        self.placename.status_reason = "wrong media"
        self.placename.save()

        body = inform_placename_to_be_verified(self.placename.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename.name) > 0

        assert body.count(self.placename.status_reason) > 0
        assert body.count("created") == 0
        assert body.count("flagged") > 0

    def test_inform_media_rejected_or_flagged(self):
        reason = "wrong media"
        body = inform_media_rejected_or_flagged(
            self.media.id, reason, REJECTED)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media.name) > 0

        assert body.count(reason) > 0
        assert body.count("rejected") > 0
        assert body.count("flagged") == 0

        body = inform_media_rejected_or_flagged(self.media.id, reason, FLAGGED)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media.name) > 0

        assert body.count(reason) > 0
        assert body.count("flagged") > 0
        assert body.count("rejected") == 0

    def test_inform_media_to_be_verified(self):

        Administrator.objects.create(
            user=self.admin_user,
            language=self.test_language,
            community=self.test_community,
        )

        self.media.status = UNVERIFIED
        self.media.status_reason = "wrong media"
        self.media.save()

        body = inform_media_to_be_verified(self.media.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media.name) > 0

        assert body.count(self.media.status_reason) > 0
        assert body.count("created") > 0
        assert body.count("flagged") == 0

        self.media.status = FLAGGED
        self.media.status_reason = "wrong media"
        self.media.save()

        body = inform_media_to_be_verified(self.media.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.test_language.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media.name) > 0

        assert body.count(self.media.status_reason) > 0
        assert body.count("flagged") > 0
        assert body.count("created") == 0
