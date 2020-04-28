from django.conf import settings
from django.core.mail import send_mail

from users.models import User, ArtistProfileClaimRecord
from language.models import RelatedData

import re
import hashlib
import uuid


def _format_fpcc(s):

    s = s.strip().lower()
    s = re.sub(
        r"\\|\/|>|<|\)|\(|~|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|\"",
        "",
        s,
    )
    s = re.sub(r"\s+", "-", s)
    return s


# email data refers to RelatedData with data_type = 'email'
def send_claim_profile_invite(user_email, email_data):
    """
    Triggers Mail Sending
    """
    salt = uuid.uuid4().hex.encode('utf-8')
    encoded_email = email_data.value.encode('utf-8')
    key = hashlib.sha512(encoded_email + salt).hexdigest()

    message = """
        <h3>Greetings from First People's Cultural Council!</h3>
        <p>We have recently migrated our data from <a href='{fp_artsmap_website}' target='_blank'>{fp_artsmap_website}</a> over to <a href='{fpcc_website}' target='_blank'>{fpcc_website}</a> and would like to invite you to claim your profile:</p>
        <p>&emsp;<a href='{host}/art/{artist_profile}' target='_blank'>{host}/art/{artist_profile}</a></p><br/>
        <h4>Claim Your Profile</h4>
        <p>If this profile is yours, please click on the link below to claim it:</p>
        <p>&emsp;<a href='{host}/api/invite/confirm/{email}/{key}' target='_blank'>Claim Profile</a></p>
        <p>If it isn't please report that your email is being used by another person on our website by sending an email to <a href='mailto:{fpcc_email}' target='_blank'>{fpcc_email}</a>.</p><br/>
        <p>Thank you very much, and have a good day!</p>
    """.format(
        fp_artsmap_website='https://fp-artsmap.ca',
        fpcc_website='https://maps.fpcc.ca',
        host=settings.HOST,
        artist_profile=_format_fpcc(email_data.placename.name),
        fpcc_email='info@fpcc.ca',
        email=email_data.value,
        key=key
    )

    print(message)

    # Send out the message
    send_mail(
        subject="FPCC Artist Profile: %s" % email_data.placename.name,
        message=message,
        from_email="info@fpcc.ca",
        recipient_list=[email_data.value],
        html_message=message,
    )

    # Update key and user email for record if it already exists
    try:
        record = ArtistProfileClaimRecord.objects.get(artist_profile_email=email_data.value)
        record.key = key
        record.user_email = user_email
        record.save()
    except ArtistProfileClaimRecord.DoesNotExist:
        ArtistProfileClaimRecord.objects.create(
            artist_profile_email=email_data.value,
            user_email=user_email,
            key=key,
            profile=email_data.placename
        )        


def send_claim_profile_invites():
    """
    Bulk Invite - Sends to every registered
    """
    # user_emails = list(User.objects.all().values_list('email', flat=True))
    user_emails = ['justin@countable.ca']

    artist_emails = RelatedData.objects.exclude(value='').filter(
        data_type='email', value__in=user_emails, placename__kind='artist')

    for email_data in artist_emails:
        # In the case of bulk sending, user_email = artist_profile_email
        send_claim_profile_invite(
            user_email=email_data.value, email_data=email_data)


def claim_profile(user_email, artist_placename):
    """
    Claim profile - this allows claiming profile despite the user.email and the artist.email not matching
    """
    email_data = RelatedData.objects.get(data_type='email', placename=artist_placename)

    # Send invite
    send_claim_profile_invite(user_email, email_data)


def resend_invite(user_email):
    """
    In case the email did not arrive, this function could be triggered
    """
    record = ArtistProfileClaimRecord.objects.get(user_email=user_email)
    email_data = RelatedData.objects.get(data_type='email', value=record.artist_profile_email)

    send_claim_profile_invite(user_email, email_data)
