import os
import re
import hashlib
import uuid

from django.conf import settings
from django.core.mail import send_mail

from users.models import User, ProfileClaimRecord
from language.models import RelatedData


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
def send_claim_profile_invite(email):
    """
    Triggers Mail Sending
    """
    salt = os.environ['INVITE_SALT'].encode('utf-8')
    encoded_email = email.encode('utf-8')
    key = hashlib.sha256(salt + encoded_email).hexdigest()

    email_data = RelatedData.objects.filter(data_type='email', value=email)

    profile_links = ''
    for data in email_data:
        profile_links += """<p>&emsp;<a href='{host}/art/{profile}' target='_blank'>{host}/art/{profile}</a></p>""".format(
            host=settings.HOST,
            profile=_format_fpcc(data.placename.name),
        )

    message = """
        <h3>Greetings from First People's Cultural Council!</h3>
        <p>We have recently migrated our data from <a href='{fp_artsmap_website}' target='_blank'>{fp_artsmap_website}</a> over to <a href='{fpcc_website}' target='_blank'>{fpcc_website}</a> and would like to invite you to claim your profile(s):</p>
        {profile_links}<br/>
        <h4>Claim Your Profile</h4>
        <p>If you own the following profile(s), please click on the link below to claim it:</p>
        <p>&emsp;<a href='{host}/claim?email={email}&key={key}' target='_blank'>Claim Profile</a></p>
        <p>If it isn't please report that your email is being used by another person on our website by sending an email to <a href='mailto:{fpcc_email}' target='_blank'>{fpcc_email}</a>.</p><br/>
        <p>Thank you very much, and have a good day!</p>
    """.format(
        fp_artsmap_website='https://fp-artsmap.ca',
        fpcc_website='https://maps.fpcc.ca',
        profile_links=profile_links,
        host=settings.HOST,
        fpcc_email='info@fpcc.ca',
        email=email,
        key=key
    )

    # Send out the message
    send_mail(
        subject="Claim Your FPCC Profile",
        message=message,
        from_email="info@fpcc.ca",
        recipient_list=[email],
        html_message=message,
    )


def send_claim_profile_invites():
    """
    Bulk Invite - Sends to every registered
    """
    # This is actual data which we won't use yet
    # emails = RelatedData.objects.exclude(value='').filter(
    #     data_type='email').distinct('value').values_list('value', flat=True)

    # TESTING DATA START
    emails = ['justin@countable.ca']  # Replace with your email
    # TESTING DATA END

    for email in emails:
        # In the case of bulk sending, user_email = profile_email
        send_claim_profile_invite(email)


# def claim_profile(email):
#     """
#     Claim profile - this allows claiming profile despite the user.email and the email not matching
#     """
#     # Send invite
#     send_claim_profile_invite(email)
