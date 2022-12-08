import os
import re

from django.core.management.base import BaseCommand
from django.conf import settings

from language.models import PlaceName, Community, Media


def _format_fpcc(s):

    s = s.strip().lower()
    s = re.sub(
        r"\\|\/|>|<|\?|\)|\(|~|!|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|'|\"",
        "",
        s,
    )
    s = re.sub(r"\s+", "-", s)
    return s


class Command(BaseCommand):
    help = 'Checks if there are any recordings that do not have actual audio files.'

    def handle(self, *args, **options):
        print('FILE,PAGE')
        communities = Community.objects.filter(audio__isnull=False)
        for community in communities:
            file_path = "{}{}".format(
                settings.MEDIA_ROOT, community.audio.audio_file)

            if not os.path.exists(file_path):
                print('"Pronunciation","{}/content/{}"'.format(settings.HOST,
                                                               _format_fpcc(community.name)))

            media = Media.objects.filter(
                community=community, media_file__isnull=False)

            if media:
                for m in media:
                    file_path = "{}{}".format(
                        settings.MEDIA_ROOT, m.media_file)

                    if not os.path.exists(file_path):
                        print('"{}","{}/content/{}"'.format(m.name,
                                                            settings.HOST, _format_fpcc(community.name)))

        placenames = PlaceName.objects.filter(audio__isnull=False)
        for placename in placenames:
            file_path = "{}{}".format(
                settings.MEDIA_ROOT, placename.audio.audio_file)

            if not os.path.exists(file_path):
                print('"Pronunciation","{}/place-names/{}"'.format(settings.HOST,
                                                                   _format_fpcc(placename.name)))

            media = Media.objects.filter(
                placename=placename, media_file__isnull=False)

            if media:
                for m in media:
                    file_path = "{}{}".format(
                        settings.MEDIA_ROOT, m.media_file)

                    if not os.path.exists(file_path):
                        print('"{}","{}/place-names/{}"'.format(m.name,
                                                                settings.HOST, _format_fpcc(placename.name)))
