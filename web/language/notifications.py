import datetime

from django.db.models import Q
from django.core.mail import send_mail
from django.utils import timezone
from django.conf import settings

from language.models import (
    PlaceName,
    Media,
    Favourite,
    CommunityMember,
    Language,
    Community,
    PublicArtArtist,
)
from users.models import User
from web.utils import get_lang_link, get_comm_link, get_place_link, format_fpcc
from web.constants import VERIFIED


def get_new_media_messages(new_medias):
    messages = []
    if new_medias.count():
        messages.append("<h3>New Media in Your Languages and Communities</h3><ul>")
        for media in new_medias:
            if media.placename:
                link = get_place_link(media.placename)
            elif media.community:
                link = get_comm_link(media.community)
            else:
                link = "(Orphaned Media)"
            preview = ""
            file_name = " - " + media.name
            if "image" in media.file_type:
                preview = "<br><img src='{}/media/{}' width=100 style='width:100px;height:auto'/>".format(
                    settings.HOST, media.media_file
                )
            if media.url:
                link = media.url
            messages.append(
                """
                <li>{} has a new media uploaded: {}{}</li>
                """.format(
                    link, preview, file_name
                )
            )
        messages.append("</ul>")
    return messages


def get_new_places_messages(new_places, scope="New Places"):
    messages = []
    if new_places.count():
        messages.append("<h3>{}</h3><ul>".format(scope))

        for place in new_places:
            placename_type = (
                "place" if place.kind in ["", "poi"] else place.kind.replace("_", " ")
            )

            link = get_place_link(place)

            if place.creator:
                creator_name = str(place.creator)
            else:
                creator_name = "Someone"

            messages.append(
                """
                    <li>{} uploaded a new {}: {}.</li>
                """.format(
                    creator_name, placename_type, link
                )
            )

        messages.append("</ul>")
    return messages


def get_my_favourites_messages(my_favourites):
    messages = []
    if my_favourites.count():
        messages.append("<h3>New Favourites</h3><ul>")
        for fav in my_favourites:
            if fav.place:
                link = get_place_link(fav.place)
                messages.append(
                    """
                        <li>Your place was favourited: {}</li>
                    """.format(
                        link
                    )
                )
            else:
                link = get_place_link(fav.media.placename)
                messages.append(
                    """
                        <li>Your contribution was favourited: {}</li>
                    """.format(
                        link
                    )
                )
        messages.append("</ul>")
    return messages


# pylint:disable=line-too-long
def notify(user, since=None):
    since = since or user.last_notified
    user_is_admin = user.email in [a[1] for a in settings.ADMINS] or user.email in [
        a[1] for a in settings.FPCC_ADMINS
    ]
    intro = [
        "(We are in test mode, sending more data than you should actually receive, please let us know of any bugs!)"
    ]

    languages = []
    communities = []
    communities_awaiting_verification = []

    user_name = " ".join([user.first_name, user.last_name])

    intro.append("<p>Hello, {}!".format(user_name))

    if user_is_admin:
        languages = Language.objects.all()
        communities = Community.objects.all()

        intro.append(
            "<p>As an Admin, you will be receiving updates to all Languages and Communities."
        )

        intro.append(
            "<p>This is a test-only setup. We are not expecting that many updates, so even if the updates are for every single language and community, we will not be overwhelemed."
        )
    else:
        languages = user.languages.all()

        for membership in CommunityMember.objects.filter(user=user):
            if membership.status == VERIFIED:
                communities.append(membership.community)
            else:
                communities_awaiting_verification.append(membership.community)

        if languages.count():
            intro.append(
                "<p>You are receiving updates related to the following languages: {}</p>".format(
                    ",".join([get_lang_link(l) for l in languages])
                )
            )

        if len(communities) > 0:
            intro.append(
                "<p>You are receiving updates related to the following communities: {}</p>".format(
                    ",".join([get_comm_link(c) for c in communities])
                )
            )
        if len(communities_awaiting_verification) > 0:
            intro.append(
                "<p>You are still awaiting membership verification in the following communities: {}</p>".format(
                    ",".join(
                        [get_comm_link(c) for c in communities_awaiting_verification]
                    )
                )
            )

    messages = []

    # If somethe user is a member of a language, notify them of all the public places in their language of interest.
    for language in languages:
        new_places = PlaceName.objects.filter(
            language=language, community_only=False, created__gte=since
        )
        messages += get_new_places_messages(
            new_places, "New Places for the {} Language".format(language.name)
        )

    # all placenames, shared with verified members.
    for community in communities:
        new_places = PlaceName.objects.filter(communities=community, created__gte=since)
        messages += get_new_places_messages(
            new_places, "New Places in {}".format(community.name)
        )

    if not user_is_admin:
        # public placenames.
        for community in communities_awaiting_verification:
            new_places = PlaceName.objects.filter(
                communities=community, created__gte=since, community_only=False
            )
            messages += get_new_places_messages(
                new_places,
                "New Places in {} (public updates only)".format(community.name),
            )

    # all media, shared only with verified members.
    new_medias_private = Media.objects.filter(
        Q(placename__communities__in=communities) | Q(community__in=communities),
        created__gte=since,
    )
    messages += get_new_media_messages(new_medias_private)

    if not user_is_admin:
        # public media. Show public stuff to anyone who has signed up.
        new_medias_public = Media.objects.filter(
            Q(placename__language__in=languages)
            | Q(placename__community__in=communities_awaiting_verification)
            | Q(community__in=communities_awaiting_verification),
            # public items.
            Q(community_only=False) & Q(placename__community_only=False),
            created__gte=since,
        )
        messages += get_new_media_messages(new_medias_public)

    my_favourites = Favourite.objects.filter(
        Q(media__creator=user) | Q(place__creator=user), created__gte=since
    )
    messages += get_my_favourites_messages(my_favourites)

    if len(messages) > 0:
        html = "\n".join(intro + messages)
        html += """
        <p>If you'd like to unsubscribe, change your notification settings <a href='{}/profile/edit/{}'>here</a>.</p>
        """.format(
            settings.HOST, user.id
        )
        send_mail(
            "Your Updates on the First Peoples' Language Map",
            html,
            "maps@fpcc.ca",
            [user.email],
            html_message=html,
        )
        return html

    return None


def notify_no_media(user):
    """
    Notify Users that their Artist Profiles do not have any Media/Artwork associated to it
    """

    user_name = " ".join([user.first_name, user.last_name])
    artist_profiles = user.placename_set.filter(kind="artist")
    artist_profiles_ids = artist_profiles.values_list("id", flat=True)

    # Don't send any notifications if the user does not
    # have an artist profile attached to his account
    if not artist_profiles:
        return

    # Don't send any notifications if the user already posted something
    posted_media = Media.objects.filter(placename_id__in=artist_profiles_ids)
    posted_public_arts = PublicArtArtist.objects.filter(artist__in=artist_profiles_ids)
    if posted_public_arts or posted_media:
        return

    artist_profiles_with_media = list(
        posted_media.values_list("placename_id", flat=True)
    ) + list(posted_public_arts.values_list("artist_id", flat=True))
    profiles_html = ""

    # List profiles without media/public art for convenience
    for profile in artist_profiles:
        if profile.id not in artist_profiles_with_media:
            profiles_html += f"<li><a href='{settings.HOST}/art/{format_fpcc(profile.name)}/' target='_blank'>{profile.name}</a></li>"

    subject = "No Artwork or Public Art in your First People's Language Map Profile"
    html = f"""
    <p>Hello, <b>{user_name}!</b></p>
    <p>
        We have noticed that you haven't posted an artwork or a public art in your Profile(s) at
        <a href='{settings.HOST}/art/' target='_blank'>First People's Language Map Profile</a>.
        Please take this opportunity to showcase your skills by sharing your lovely art with us.
        We would really appreciate it if you do.
    </p>
    <p>
        <div>Profiles with no Artwork or Public Art</div>
        <ul>{profiles_html}</ul>
    </p>
    <p>Thank you so much!<br><b>FPCC Team</b></p>
    """
    send_mail(
        subject,
        html,
        "maps@fpcc.ca",
        [user.email],
        html_message=html,
    )


def send_notifications():
    now = timezone.now()
    # find everyone who needs an update.
    users = User.objects.filter(
        # TODO: allow arbitrary notification frequency from account setting instead of hardcoding 7 here?
        last_notified__lte=now - datetime.timedelta(days=30),
        notification_frequency__gt=-1,
    )
    for user in users:
        user_is_admin = user.email in [a[1] for a in settings.ADMINS] or user.email in [
            a[1] for a in settings.FPCC_ADMINS
        ]

        if user_is_admin:
            notify(user)
        user.last_notified = now
        user.save()
