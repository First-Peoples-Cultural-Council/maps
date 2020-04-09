from django.test import TestCase
from django.core import mail
from django.utils import timezone

import os
from datetime import timedelta
import re

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


class EmailTests(TestCase):
    def setUp(self):
        self.from_email = 'info@fpcc.ca'
        self.to = 'justin@countable.ca'

        self.user = User.objects.create(
            username="testuser001",
            first_name="Test",
            last_name="user 001",
            email=self.to,
            is_staff=True,
            is_superuser=True,
        )
        self.user.set_password("password")
        self.user.save()

        self.user2 = User.objects.create(
            username="testuser002",
            first_name="Test2",
            last_name="user 002",
            email="test@countable.ca",
        )

        self.language1 = Language.objects.create(name="Test language 001")
        self.user.languages.add(self.language1)
        self.user.save()

        self.community1 = Community.objects.create(name="Test community 001")
        self.community2 = Community.objects.create(name="Test community 002")

        self.placename1 = PlaceName.objects.create(
            name="test place01",
            community=self.community1,
            language=self.language1,
            creator=self.user,
            status=PlaceName.VERIFIED,
        )

        self.placename2 = PlaceName.objects.create(
            name="test place02",
            community=self.community1,
            language=self.language1,
            status=PlaceName.VERIFIED,
        )

        self.media1 = Media.objects.create(
            name="test media01",
            file_type="string",
            placename=self.placename1,
            creator=self.user,
            status=Media.VERIFIED,
        )

    def test_notify(self):
        communitymember1 = CommunityMember.objects.create(
            user=self.user,
            community=self.community1,
            status=CommunityMember.VERIFIED
        )

        communitymember2 = CommunityMember.objects.create(
            user=self.user,
            community=self.community2,
            status=CommunityMember.UNVERIFIED
        )

        # Another user made a Favourite out of the created placename
        test_favourite_place = Favourite.objects.create(
            name="test favourite",
            user=self.user2,
            place=self.placename1,
            favourite_type="favourite",
            description="description",
        )

        # Another user made a Favourite out of the created media
        test_favourite_media = Favourite.objects.create(
            name="test favourite",
            user=self.user2,
            media=self.media1,
            favourite_type="favourite",
            description="description",
        )

        user = User.objects.get(email=self.user.email)
        body = notify(user, timezone.now() - timedelta(days=7))

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename1.name) > 0

        # Testing Community memberships not verified yet
        self.assertEqual(body.count("You are still awaiting membership verification"), 1)

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
        body = inform_placename_rejected_or_flagged(self.placename1.id, reason, PlaceName.REJECTED)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename1.name) > 0

        assert body.count(reason) > 0
        assert body.count("rejected") > 0
        assert body.count("flagged") == 0

        body = inform_placename_rejected_or_flagged(self.placename1.id, reason, PlaceName.FLAGGED)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename1.name) > 0

        assert body.count(reason) > 0
        assert body.count("flagged") > 0
        assert body.count("rejected") == 0

    def test_inform_placename_to_be_verified(self):
        admin = Administrator.objects.create(
            user=self.user,
            language=self.language1,
            community=self.community1,
        )

        self.placename1.status = PlaceName.UNVERIFIED
        self.placename1.status_reason = "wrong media"
        self.placename1.save()

        body = inform_placename_to_be_verified(self.placename1.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename1.name) > 0

        assert body.count(self.placename1.status_reason) > 0
        assert body.count("created") > 0
        assert body.count("flagged") == 0

        self.placename1.status = PlaceName.FLAGGED
        self.placename1.status_reason = "wrong media"
        self.placename1.save()

        body = inform_placename_to_be_verified(self.placename1.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the placename create was sent in the email
        assert body.count(self.placename1.name) > 0

        assert body.count(self.placename1.status_reason) > 0
        assert body.count("created") == 0
        assert body.count("flagged") > 0

    def test_inform_media_rejected_or_flagged(self):
        reason = "wrong media"
        body = inform_media_rejected_or_flagged(self.media1.id, reason, Media.REJECTED)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media1.name) > 0

        assert body.count(reason) > 0
        assert body.count("rejected") > 0
        assert body.count("flagged") == 0

        body = inform_media_rejected_or_flagged(self.media1.id, reason, Media.FLAGGED)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media1.name) > 0

        assert body.count(reason) > 0
        assert body.count("flagged") > 0
        assert body.count("rejected") == 0

    def test_inform_media_to_be_verified(self):

        admin = Administrator.objects.create(
            user=self.user,
            language=self.language1,
            community=self.community1,
        )

        self.media1.status = Media.UNVERIFIED
        self.media1.status_reason = "wrong media"
        self.media1.save()

        body = inform_media_to_be_verified(self.media1.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media1.name) > 0

        assert body.count(self.media1.status_reason) > 0
        assert body.count("created") > 0
        assert body.count("flagged") == 0

        self.media1.status = Media.FLAGGED
        self.media1.status_reason = "wrong media"
        self.media1.save()

        body = inform_media_to_be_verified(self.media1.id)

        # Testing if the language create was referenced in the email
        assert body.count(self.language1.name) > 0

        # Testing if the community create was referenced in the email
        assert body.count(self.community1.name) > 0

        # Testing if the media create was sent in the email
        assert body.count(self.media1.name) > 0

        assert body.count(self.media1.status_reason) > 0
        assert body.count("flagged") > 0
        assert body.count("created") == 0
