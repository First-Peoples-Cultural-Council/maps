from django.test import TestCase
from django.utils import timezone

from datetime import timedelta

from language.notifications import notify
from users.models import User
from language.models import (
    Language,
    Community,
    PlaceName,
    Media,
    CommunityMember,
    Favourite,
)
from web.constants import *
from web.utils import get_place_link, get_comm_link


class EmailTests(TestCase):
    def setUp(self):
        self.from_email = "maps@fpcc.ca"
        self.to = "justin@countable.ca"

        self.test_language = Language.objects.create(name="Global Test Language")
        self.test_community = Community.objects.create(name="Global Test Community")

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
            email="regular@countable.ca",
        )

        self.placename = PlaceName.objects.create(
            name="Test Placename",
            language=self.test_language,
            creator=self.admin_user,
            status=VERIFIED,
        )
        self.placename.communities.set([self.test_community])

        self.media = Media.objects.create(
            name="Test Media",
            file_type="string",
            placename=self.placename,
            creator=self.admin_user,
            status=VERIFIED,
        )

        self.media_with_community = Media.objects.create(
            name="Test Media With Community",
            file_type="string",
            community=self.test_community,
            creator=self.admin_user,
            status=VERIFIED,
        )

    def test_notify(self):
        # Make Admin User a member of the test community
        CommunityMember.objects.create(
            user=self.admin_user, community=self.test_community, status=VERIFIED
        )

        # Make Admin User a member of the new community
        new_community = Community.objects.create(name="New Community")
        CommunityMember.objects.create(
            user=self.admin_user, community=new_community, status=UNVERIFIED
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
        new_placename = PlaceName.objects.create(
            name="New Placename",
            language=self.test_language,
            status=VERIFIED,
        )
        new_placename.communities.set([self.test_community])

        user = User.objects.get(email=self.admin_user.email)
        body = notify(user, timezone.now() - timedelta(days=7))

        # Testing if the community create was referenced in the email
        assert body.count(self.test_community.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename.name) > 0

        # Testing if the placename was not sent more than once
        self.assertEqual(body.count("Someone uploaded a new place:"), 1)

        # Testing if all 2 media are in the notification
        self.assertEqual(body.count("has a new media uploaded"), 2)

        # Testing if the placename favourite was sent in the email
        self.assertEqual(body.count("Your place was favourited:"), 1)

        # Testing if the media favourite was sent in the email
        self.assertEqual(body.count("Your contribution was favourited:"), 1)

    def test_verify_placename_notification(self):
        # Media attached to Placename
        self.placename.status = VERIFIED
        body = self.placename.notify_creator_about_status_change()

        assert body.count(self.placename.name) > 0
        assert body.count(get_place_link(self.placename)) > 0
        assert body.count(STATUS_DISPLAY[VERIFIED]) > 0

    def test_reject_placename_notification(self):
        # Media attached to Placename
        self.placename.status = REJECTED
        self.placename.status_reason = "Bad Media"
        body = self.placename.notify_creator_about_status_change()

        assert body.count(self.placename.name) > 0
        assert body.count(get_place_link(self.placename)) > 0
        assert body.count(STATUS_DISPLAY[REJECTED]) > 0
        assert body.count(self.placename.status_reason) > 0

    def test_flag_placename_notification(self):
        # Media attached to Placename
        self.placename.status = FLAGGED
        self.placename.status_reason = "Sensitive Content"
        body = self.placename.notify_creator_about_status_change()

        assert body.count(self.placename.name) > 0
        assert body.count(get_place_link(self.placename)) > 0
        assert body.count(STATUS_DISPLAY[FLAGGED]) > 0
        assert body.count(self.placename.status_reason) > 0

    def test_verify_media_notification(self):
        # Media attached to Placename
        self.media.status = VERIFIED
        body = self.media.notify_creator_about_status_change()

        assert body.count(self.media.name) > 0
        assert body.count(get_place_link(self.media.placename)) > 0
        assert body.count(STATUS_DISPLAY[VERIFIED]) > 0

        # Media attached to Community
        self.media_with_community.status = VERIFIED
        body = self.media_with_community.notify_creator_about_status_change()

        assert body.count(self.media.name) > 0
        assert body.count(get_comm_link(self.media_with_community.community)) > 0
        assert body.count(STATUS_DISPLAY[VERIFIED]) > 0

    def test_reject_media_notification(self):
        # Media attached to Placename
        self.media.status = REJECTED
        self.media.status_reason = "Bad Media"
        body = self.media.notify_creator_about_status_change()

        assert body.count(self.media.name) > 0
        assert body.count(get_place_link(self.media.placename)) > 0
        assert body.count(STATUS_DISPLAY[REJECTED]) > 0
        assert body.count(self.media.status_reason) > 0

        # Media attached to Community
        self.media_with_community.status = REJECTED
        self.media_with_community.status_reason = "Bad Media"
        body = self.media_with_community.notify_creator_about_status_change()

        assert body.count(self.media.name) > 0
        assert body.count(get_comm_link(self.media_with_community.community)) > 0
        assert body.count(STATUS_DISPLAY[REJECTED]) > 0
        assert body.count(self.media_with_community.status_reason) > 0

    def test_flag_media_notification(self):
        # Media attached to Placename
        self.media.status = FLAGGED
        self.media.status_reason = "Sensitive Content"
        body = self.media.notify_creator_about_status_change()

        assert body.count(self.media.name) > 0
        assert body.count(get_place_link(self.media.placename)) > 0
        assert body.count(STATUS_DISPLAY[FLAGGED]) > 0
        assert body.count(self.media.status_reason) > 0

        # Media attached to Community
        self.media_with_community.status = FLAGGED
        self.media_with_community.status_reason = "Sensitive Content"
        body = self.media_with_community.notify_creator_about_status_change()

        assert body.count(self.media.name) > 0
        assert body.count(get_comm_link(self.media_with_community.community)) > 0
        assert body.count(STATUS_DISPLAY[FLAGGED]) > 0
        assert body.count(self.media_with_community.status_reason) > 0
