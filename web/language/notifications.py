from users.models import User
from language.models import PlaceName, Media, Favourite
from django.db.models import Q
from django.core.mail import send_mail
import datetime
from django.utils import timezone
from django.conf import settings
import re


def _format_fpcc(s):

    s = s.strip().lower()
    s = re.sub(
        s,
        r"\\|\/|>|<|\?|\)|\(|~|!|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|'|\"",
        "",
    )
    s = re.sub(s, r"\s+", "-")
    return s


def get_new_media_messages(new_medias):
    messages = []
    if new_medias.count():
        messages.append("<h3>New Media</h3><ul>")
        for media in new_medias:
            if media.placename:
                name = media.placename.name
                link = "https://{}/place-names/{}".format(
                    settings.HOST, _format_fpcc(media.placename.name)
                )
            elif media.community:
                name = media.community.name
                link = "https://{}/community/{}".format(
                    settings.HOST, media.community.id
                )
            else:
                name = "(Orphaned Media)"
                link = "#"
            messages.append(
                """
                <li>{} has new media ({}) - <a href="{}">{}</a></li>
            """.format(
                    name, media.file_type, link, media.description
                )
            )

        messages.append("</ul>")
    return messages


def get_new_places_messages(new_places):
    messages = []
    if new_places.count():
        messages.append("<h3>New Places</h3><ul>")
        for place in new_places:
            link = "https://{}/place-names/{}".format(settings.HOST, place.id)

            messages.append(
                """
                <li><a href="{}">{}</a></li>
            """.format(
                    link, place.name
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
                messages.append(
                    """
                    <li>your place was favourited! <a href="{}">{}</a></li>
                """.format(
                        fav.place.id, fav.place.name
                    )
                )
            else:
                messages.append(
                    """
                    <li>your contribution was favourited! <a href="{}">{}</a></li>
                """.format(
                        fav.media.placename.id, fav.media.placename.name
                    )
                )
        messages.append("</ul>")
    return messages


def notify(user, since=None):
    since = since or user.last_notified
    print("Calculating notifications for", user)
    messages = []
    new_medias = Media.objects.filter(
        Q(placename__language__in=user.languages.all())
        | Q(placename__community__in=user.communities.all()),
        created__gte=since,
    )
    messages += get_new_media_messages(new_medias)

    new_places = PlaceName.objects.filter(
        Q(language__in=user.languages.all()) | Q(community__in=user.communities.all()),
        created__gte=since,
    )
    messages += get_new_places_messages(new_places)

    my_favourites = Favourite.objects.filter(
        Q(media__creator=user) | Q(place__creator=user), created__gte=since
    )
    messages += get_my_favourites_messages(my_favourites)

    if len(messages):
        html = "\n".join(messages)
        html += """
        <p>If you'd like to unsubscribe, change your notification settings <a href="https://{}/profile/{}">here</a>.
        """.format(
            settings.HOST, user.id
        )
        print(html)
        #
        # send_mail(html, "New stuff from FPCC this week!", to=user.email)
    else:
        print("No new information for this person.")


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

