import requests
import os
import re

from django.core.management.base import BaseCommand, CommandError
from language.models import PlaceName, Community

from django.conf import settings

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
        communities = Community.objects.filter(audio__isnull=False)
        for community in communities:
            file_path = "{}{}{}".format(settings.BASE_DIR, settings.MEDIA_ROOT, community.audio.audio_file)

            if not os.path.exists(file_path):
                print("{}/content/{}".format(settings.HOST, _format_fpcc(community.name)))
        
        placenames = PlaceName.objects.filter(audio__isnull=False)
        for placename in placenames:
            file_path = "{}{}{}".format(settings.BASE_DIR, settings.MEDIA_ROOT, placename.audio.audio_file)

            if not os.path.exists(file_path):
                print("{}/place-names/{}".format(settings.HOST, _format_fpcc(placename.name)))
