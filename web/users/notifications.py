import os
import re
import hashlib
import copy

from django.conf import settings
from django.core.mail import send_mail
from django.db.models import Q

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

    email_data = RelatedData.objects.exclude(
        (Q(value='') | Q(placename__kind__in=['resource', 'grant']))
    ).filter(
        (Q(data_type='email') | Q(data_type='user_email')), placename__creator__isnull=True, value=email
    )
    email_data_copy = copy.deepcopy(email_data)

    # Exclude data if there is an actual_email. Used to give notif to
    # the actual email rather than the FPCC admin who seeded the profile
    for data in email_data:
        if data.data_type == 'user_email':
            actual_email = RelatedData.objects.exclude(value='').filter(
                placename=data.placename, data_type='email')

            if actual_email:
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
            profile_links += """<p style="margin-left:24px;"><a href='{host}/art/{profile}' target='_blank'>{host}/art/{profile}</a></p>""".format(
                host=settings.HOST,
                profile=_format_fpcc(data.placename.name),
            )

        message = """
            <img src="http://www.fpcc.ca/files/Images/Logos/FPCC-Logo-Set-03.jpg" width="300" height="75" />
            <h3>Greetings from First People's Cultural Council!</h3>
            <p>We recently sent you a message, telling you that the First Peoples’ Arts Map is being amalgamated into the <strong>First Peoples’ Map</strong>, which now includes Indigenous Language, Arts and Heritage in B.C. This update has provided an opportunity for us to make important changes and improvements to the map’s functions, features and design.</p>
            <p>We have now moved all of the data, including your profile(s) to the new website. All of the content you have published on the old Arts Map has been saved within the new First Peoples’ Map. To access your profile, do updates, and add new images, sound or video, you will need <strong>to register and claim your material</strong>. Listed below are the new links to your profile(s) for you to review:</p>
            {profile_links}<br/>
            <h4>Please claim your profile(s) through the link below. Before you click on the link, here are a couple of helpful notes:</h4>
            <ul>
                <li>If you don't have an account registered on the <strong>new First Peoples’ Map</strong>, you will need to <strong>Sign-up</strong> after clicking on the link.</li>
                <li>Please carefully enter your <strong>valid email</strong> address as the system will send you a <strong>verification code</strong> to confirm that email address.</li>
                <li>In some cases, the email containing the verification code might end up as spam, so please thoroughly check your inbox.</li>
            </ul>
            <a  style="margin-left:24px;" href='{host}/claim?email={email}&key={key}' target='_blank'>Claim Profile</a></p>
            <p>If you don't own the profile(s) listed above, or if you are in need of assistance, please contact us through <a href='mailto:{fpcc_email}' target='_blank'>{fpcc_email}</a>. We are here to help!</p><br/>
            <p>Miigwech, and have a good day!</p>
        """.format(
            fp_artsmap_website='https://fp-artsmap.ca',
            fpcc_website='https://maps.fpcc.ca',
            profile_links=profile_links,
            host=settings.HOST,
            fpcc_email='maps@fpcc.ca',
            email=email,
            key=key
        )

        # Send out the message
        send_mail(
            subject="Claim Your FPCC Profile",
            message=message,
            from_email="First Peoples' Cultural Council <maps@fpcc.ca>",
            recipient_list=[email],
            html_message=message,
        )

        print('Sent mail to: {}'.format(email))
    else:
        print('User {} has no profiles to claim.'.format(email))


def send_claim_profile_invites(email=None):
    """
    Bulk Invite - Sends to every old artsmap users with profiles
    """
    if not email:
        emails = RelatedData.objects.exclude(
            (Q(value='') | Q(placename__kind__in=['resource', 'grant']))
        ).filter(
            (Q(data_type='email') | Q(data_type='user_email')), placename__creator__isnull=True
        ).distinct('value').values_list('value', flat=True)
    else:
        emails = RelatedData.objects.exclude(
            (Q(value='') | Q(placename__kind__in=['resource', 'grant']))
        ).filter(
            (Q(data_type='email') | Q(data_type='user_email')), placename__creator__isnull=True, value=email
        ).distinct('value').values_list('value', flat=True)

    for email in emails:
        send_claim_profile_invite(email)
