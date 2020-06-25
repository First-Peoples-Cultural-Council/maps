import os
import re
import hashlib
import uuid
import copy

from django.conf import settings
from django.core.mail import send_mail
from django.db.models import Q

from users.models import User
from language.models import RelatedData


def _format_fpcc(s):

    s = s.strip().lower()
    s = re.sub(
        r"\\|\/|>|<|\?|\)|\(|~|!|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|'|\"",
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

    email_data = RelatedData.objects.exclude(value='').filter(
        (Q(data_type='email') | Q(data_type='user_email')), placename__creator__isnull=True, value=email)
    email_data_copy = copy.deepcopy(email_data)

    # Exclude data if there is an actual_email. Used to give notif to 
    # the actual email rather than the FPCC admin who seeded the profile
    for data in email_data:
        if data.data_type == 'user_email':
            actual_email = RelatedData.objects.exclude(value='').filter(placename=data.placename, data_type='email')

            if actual_email:
                print('actual_email')
                print(actual_email)
                email_data_copy = email_data_copy.exclude(id=data.id)
    
    email_data = email_data_copy

    # Check if the profile is already claimed. Otherwise, don't include it in the list of profiles to claim
    fully_claimed = True
    for data in email_data:
        if data.placename.creator is None:
            fully_claimed = False
            break
    
    if email_data and not fully_claimed:
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
            <p>If you don't own the profile(s) listed, please report that your email is being used by another person on our website by sending an email to <a href='mailto:{fpcc_email}' target='_blank'>{fpcc_email}</a>.</p><br/>
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

        print('Sent mail to: {}'.format(email))
    else:
        print('User {} has no profiles to claim.'.format(email))
    

def send_claim_profile_invites(email=None):
    """
    Bulk Invite - Sends to every registered
    """
    # This is actual data which we won't use yet
    if not email:
        emails = RelatedData.objects.exclude(value='').filter(
            (Q(data_type='email') | Q(data_type='user_email')),
            placename__creator__isnull=True
        ).distinct('value').values_list('value', flat=True)
    else:
        emails = RelatedData.objects.exclude(value='').filter(
            (Q(data_type='email') | Q(data_type='user_email')),
            placename__creator__isnull=True,
            value=email
        ).distinct('value').values_list('value', flat=True)

    for email in emails:
        send_claim_profile_invite(email)
