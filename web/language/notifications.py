from users.models import User, Administrator
import datetime

from language.models import PlaceName, Media, Favourite, CommunityMember

from django.db.models import Q
from django.core.mail import send_mail
from django.utils import timezone
from django.conf import settings

import re


def _format_fpcc(s):

    s = s.strip().lower()
    s = re.sub(
        r"\\|\/|>|<|\)|\(|~|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|\"",
        "",
        s,
    )
    s = re.sub(r"\s+", "-", s)
    return s


def get_new_media_messages(new_medias):
    messages = []
    if new_medias.count():
        messages.append(
            "<h3>New Media in Your Languages and Communities</h3><ul>")
        for media in new_medias:
            if media.placename:
                link = _place_link(media.placename)
            elif media.community:
                link = _comm_link(media.community)
            else:
                link = "(Orphaned Media)"
            preview = ''
            kind = 'media'
            if 'image' in media.file_type:
                link = ""
                kind = "image"
                preview = "<br><img src='{}/static/{}' width=100 style='width:100px;height:auto'/>".format(
                    settings.HOST, media.media_file)
            if media.url:
                link = media.url
                kind = "video"
            messages.append(
                """
                <li>The location {} has a new media uploaded. {}</li>
            """.format(
                    link, preview
                )
            )

        messages.append("</ul>")
    return messages


def get_new_places_messages(new_places, scope="New Places"):
    messages = []
    if new_places.count():
        messages.append("<h3>{}</h3><ul>".format(scope))
        for place in new_places:
            link = _place_link(place)
            if place.creator:
                creator_name = str(place.creator)
            else:
                creator_name = "Someone"
            messages.append(
                """
                <li>{} uploaded a new place: {}.</li>
            """.format(
                    creator_name, link
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
                link = _place_link(fav.place)
                messages.append(
                    """
                    <li>your place was favourited! {}</li>
                """.format(
                        link
                    )
                )
            else:
                link = _place_link(fav.media.placename)
                messages.append(
                    """
                    <li>your contribution was favourited! {}</li>
                """.format(
                        link
                    )
                )
        messages.append("</ul>")
    return messages


def _lang_link(l):
    return '<a href="{}/languages/{}">{}</a>'.format(
        settings.HOST, _format_fpcc(l.name), l.name
    )


def _comm_link(c):
    return '<a href="{}/content/{}">{}</a>'.format(
        settings.HOST, _format_fpcc(c.name), c.name
    )


def _place_link(p):
    return '<a href="{}/place-names/{}">{}</a>'.format(
        settings.HOST, _format_fpcc(p.name), p.name
    )


def notify(user, since=None):
    since = since or user.last_notified
    print("Calculating notifications for", user)
    intro = ["(We are in test mode, sending more data than you should actually receive, please let us know of any bugs!)"]

    languages = user.languages.all()
    communities = []
    communities_awaiting_verification = []
    for membership in CommunityMember.objects.filter(user=user):
        if membership.status == CommunityMember.VERIFIED:
            communities.append(membership.community)
        else:
            communities_awaiting_verification.append(membership.community)
    if languages.count():
        intro.append(
            "<p>You are receiving updates related to the following languages: {}</p>".format(
                ",".join([_lang_link(l) for l in languages])
            )
        )
    if len(communities):
        intro.append(
            "<p>You are receiving updates related to the following communities: {}</p>".format(
                ",".join([_comm_link(c) for c in communities])
            )
        )
    if len(communities_awaiting_verification):
        intro.append(
            "<p>You are still awaiting membership verification in the following communities: {}</p>".format(
                ",".join([_comm_link(c)
                          for c in communities_awaiting_verification])
            )
        )
    messages = []
    # If somethe user is a member of a language, notify them of all the public places in their language of interest.
    for language in languages:
        new_places = PlaceName.objects.filter(
            # don't double-show items in their community.
            ~Q(community__in=communities+communities_awaiting_verification),
            language=language,
            community_only=False, created__gte=since)
        messages += get_new_places_messages(
            new_places, "New Places for the {} Language".format(language.name)
        )

    # all placenames, shared with verified members.
    for community in communities:
        new_places = PlaceName.objects.filter(
            community=community, created__gte=since)
        messages += get_new_places_messages(
            new_places, "New Places in {}".format(community.name)
        )

    # public placenames.
    for community in communities_awaiting_verification:
        new_places = PlaceName.objects.filter(
            community=community, created__gte=since, community_only=False)
        messages += get_new_places_messages(
            new_places, "New Places in {} (public updates only)".format(
                community.name)
        )

    # all media, shared only with verified members.
    new_medias_private = Media.objects.filter(
        Q(placename__community__in=communities),
        created__gte=since,
    )
    messages += get_new_media_messages(new_medias_private)

    # public media. Show public stuff to anyone who has signed up.
    new_medias_public = Media.objects.filter(
        Q(placename__language__in=languages) | Q(
            placename__community__in=communities_awaiting_verification),
        # public items.
        Q(community_only=False) & Q(placename__community_only=False),
        created__gte=since,
    )
    messages += get_new_media_messages(new_medias_public)

    my_favourites = Favourite.objects.filter(
        Q(media__creator=user) | Q(place__creator=user), created__gte=since
    )
    messages += get_my_favourites_messages(my_favourites)

    if len(messages):
        html = "\n".join(intro + messages)
        html += """
        <p>If you'd like to unsubscribe, change your notification settings <a href="{}/profile/edit/{}">here</a>.</p>
        """.format(
            settings.HOST, user.id
        )
        print(html)
        if user.email in [a[1] for a in settings.ADMINS]:
            print("sending to ", user.email)
            send_mail(
                "Your Updates on the First Peoples' Language Map",
                html,
                "info@fpcc.ca",
                [user.email],
                html_message=html,
            )
        return html
    else:
        print("No new information for this person.", intro)


def send():
    now = timezone.now()
    # find everyone who needs an update.
    users = User.objects.filter(
        # TODO: allow arbitrary notification frequency from account setting instead of hardcoding 7 here?
        last_notified__lte=now - datetime.timedelta(days=7),
        notification_frequency__gt=-1,
    )
    for user in users:

        notify(user)
        user.last_notified = now
        user.save()


def inform_placename_rejected_or_flagged(placename_id, reason, status):

    # Getting the PlaceName
    placename = PlaceName.objects.get(pk=placename_id)

    # Getting user
    creator = placename.creator

    intro = "<p>(We are in test mode, sending more data than you should actually receive, please let us know of any bugs!)</p>"

    # Defining the label for the status
    state = ""
    if status == PlaceName.REJECTED:
        state = "rejected"
    else:
        state = "flagged"

    # Building the message
    message = ""
    if placename.language and placename.language.name:
        if placename.community and placename.community.name:
            message += "<p>Your contribution to {} Language and {} Community has been {}.</p>".format(
                _lang_link(placename.language), _comm_link(
                    placename.community), state
            )
        else:
            message += "<p>Your contribution to {} Language has been {}.</p>".format(
                _lang_link(placename.language), state
            )
    else:
        if placename.community and placename.community.name:
            message += "<p>Your contribution to {} Community has been {}.</p>".format(
                _comm_link(placename.community), state
            )
        else:
            message += "<p>Your contribution has been {}.</p>".format(state)

    if placename.name:
        message += "<p>Contribution: {}</p>".format(placename.name)

    message += "<p>Reason: {}</p>".format(reason)

    message += "<p>Please apply the suggested changes and try to submit your contribution for evaluation again.</p>"

    # if the creator is a system admin
    if creator.email in [a[1] for a in settings.ADMINS]:
        message = intro + message

        print("sending to ", creator.email)
        print(message)

        send_mail(
            "Your contribution has been {} on the First Peoples' Language Map".format(
                state),
            message,
            "info@fpcc.ca",
            [creator.email],
            html_message=message,
        )
    return message


def inform_placename_to_be_verified(placename_id):

    # Getting the PlaceName
    placename = PlaceName.objects.get(pk=placename_id)

    intro = "<p>(We are in test mode, sending more data than you should actually receive, please let us know of any bugs!)</p>"

    # Defining the label for the status
    state = ""
    if placename.status == PlaceName.UNVERIFIED:
        state = "created"
    else:
        state = "flagged"

    # To store the pair language/community to search for an Administrator later
    language = None
    community = None

    # Building the message
    message = ""
    if placename.language and placename.language.name:
        if placename.community and placename.community.name:
            message += "<p>A contribution at {} Language and {} Community has been {}.</p>".format(
                _lang_link(placename.language), _comm_link(
                    placename.community), state
            )
            # Storing the pair language/community of the contribution
            language = placename.language
            community = placename.community
        else:
            message += "<p>A contribution at {} Language has been {}.</p>".format(
                _lang_link(placename.language), state
            )
    else:
        if placename.community and placename.community.name:
            message += "<p>A contribution at {} Community has been {}.</p>".format(
                _comm_link(placename.community), state
            )
        else:
            message += "<p>A contribution has been {}.</p>".format(state)

    if placename.name:
        message += "<p>Contribution: {}</p>".format(placename.name)

    message += "<p>Reason: {}</p>".format(placename.status_reason)

    # If we could get a language and community form the contribution
    if language and community:

        # Checking if there is a Administrator for the pair language/community
        administrators = Administrator.objects.filter(
            language=language, community=community)

        # If there are Administrators for the pair language/community
        if administrators:
            for administrator in administrators:
                # if the administrator is a system admin
                if administrator.user.email in [a[1] for a in settings.ADMINS]:
                    message = intro + message

                print("sending to ", administrator.user.email)
                print(message)

                send_mail(
                    "A contribution has been {} on the First Peoples' Language Map".format(
                        state),
                    message,
                    "info@fpcc.ca",
                    [administrator.user.email],
                    html_message=message,
                )
                return message


def inform_media_rejected_or_flagged(media_id, reason, status):

    # Getting the Media
    media = Media.objects.get(pk=media_id)

    # Getting user
    creator = media.creator

    intro = "<p>(We are in test mode, sending more data than you should actually receive, please let us know of any bugs!)</p>"

    # Defining the label for the status
    state = ""
    if status == Media.REJECTED:
        state = "rejected"
    else:
        state = "flagged"

    # Building the message
    message = ""
    if media.placename:
        if media.placename.language and media.placename.language.name:
            if media.placename.community and media.placename.community.name:
                message += "<p>Your contribution to {} Language and {} Community has been {}.</p>".format(
                    _lang_link(media.placename.language), _comm_link(
                        media.placename.community), state
                )
            else:
                message += "<p>Your contribution to {} Language has been {}.</p>".format(
                    _lang_link(media.placename.language), state
                )
        else:
            if media.placename.community and media.placename.community.name:
                message += "<p>Your contribution to {} Community has been {}.</p>".format(
                    _comm_link(media.placename.community), state
                )
            else:
                message += "<p>Your contribution has been {}.</p>".format(
                    state)
    else:
        if media.community and media.community.name:
            message += "<p>Your contribution to {} Community has been {}.</p>".format(
                _comm_link(media.community), state
            )
        else:
            message += "<p>Your contribution has been {}.</p>".format(state)

    if media.name:
        message += "<p>Contribution: {}</p>".format(media.name)

    message += "<p>Reason: {}</p>".format(reason)

    message += "<p>Please apply the suggested changes and try to submit your contribution for evaluation again.</p>"

    # if the creator is a system admin
    if creator.email in [a[1] for a in settings.ADMINS]:
        message = intro + message

    print("sending to ", creator.email)
    print(message)

    send_mail(
        "Your contribution has been {} on the First Peoples' Language Map".format(
            state),
        message,
        "info@fpcc.ca",
        [creator.email],
        html_message=message,
    )
    return message


def inform_media_to_be_verified(media_id):

    # Getting the Media
    media = Media.objects.get(pk=media_id)

    intro = "<p>(We are in test mode, sending more data than you should actually receive, please let us know of any bugs!)</p>"

    # Defining the label for the status
    state = ""
    if media.status == Media.UNVERIFIED:
        state = "created"
    else:
        state = "flagged"

    # To store the pair language/community to search for an Administrator later
    language = None
    community = None

    # Building the message
    message = ""
    if media.placename:
        if media.placename.language and media.placename.language.name:
            if media.placename.community and media.placename.community.name:
                message += "<p>A contribution at {} Language and {} Community has been {}.</p>".format(
                    _lang_link(media.placename.language), _comm_link(
                        media.placename.community), state
                )

                # Storing the pair language/community of the contribution
                language = media.placename.language
                community = media.placename.community
            else:
                message += "<p>A contribution at {} Language has been {}.</p>".format(
                    _lang_link(media.placename.language), state
                )
                language = media.placename.language
        else:
            if media.placename.community and media.placename.community.name:
                message += "<p>A contribution at {} Community has been {}.</p>".format(
                    _comm_link(media.placename.community), state
                )
                community = media.placename.community
            else:
                message += "<p>A contribution has been {}.</p>".format(state)
    else:
        if media.community and media.community.name:
            message += "<p>A contribution at {} Community has been {}.</p>".format(
                _comm_link(media.community), state
            )
            community = media.community
        else:
            message += "<p>A contribution has been {}.</p>".format(state)

    if media.name:
        message += "<p>Contribution: {}</p>".format(media.name)

    message += "<p>Reason: {}</p>".format(media.status_reason)

    # If we could get a language and community form the contribution
    if language and community:

        # Checking if there is a Administrator for the pair language/community
        administrators = Administrator.objects.filter(
            language=language, community=community)

        # If there are Administrators for the pair language/community
        if administrators:
            for administrator in administrators:
                # if the administrator is a system admin
                if administrator.user.email in [a[1] for a in settings.ADMINS]:
                    message = intro + message

                print("sending to ", administrator.user.email)
                print(message)

                send_mail(
                    "A contribution has been {} on the First Peoples' Language Map".format(
                        state),
                    message,
                    "info@fpcc.ca",
                    [administrator.user.email],
                    html_message=message,
                )
                return message
