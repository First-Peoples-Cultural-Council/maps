from django.core.management.base import BaseCommand
from django.conf import settings
from language.models import Media

import os

import pymysql
import requests
import glob
import shutil
from web import dedruplify


class Command(BaseCommand):
    help = "Download artworks from https://fp-artsmap.ca."

    def handle(self, *args, **options):
        sync_artworks()


def sync_artworks():

    c = Client(
        os.environ["ARTSMAP_HOST"],
        os.environ["ARTSMAP_USER"],
        os.environ["ARTSMAP_PW"],
        os.environ["ARTSMAP_DB"],
    )
    c.load_artworks()


class Client(dedruplify.DeDruplifierClient):
    def load_artworks(self):
        # [TODO JRC] - Set these urls as env variables
        # Artsmap url - source website
        artsmap_url = "https://www.fp-artsmap.ca"

        # Files url - source from which to download media files
        files_url = "https://www.fp-artsmap.ca/sites/default/files/"

        # Only trigger function if the website is still up
        # This will prevent accidentally deleting all stored
        # media migrated from fp-artsmap.ca
        artsmap_response = requests.get(artsmap_url)
        if artsmap_response.status_code == 200:
            print('Loading artworks from {}'.format(artsmap_url))

            db = pymysql.connect(
                os.environ["ARTSMAP_HOST"],
                os.environ["ARTSMAP_USER"],
                os.environ["ARTSMAP_PW"],
                os.environ["ARTSMAP_DB"],
            )

            # prepare a cursor object using cursor() method
            cursor = db.cursor()

            sql = """
            SELECT
                node.nid,
                file_managed.*
            FROM
                node
                join file_usage ON node.nid = file_usage.id
                join file_managed ON file_usage.fid = file_managed.fid;
            """
            # Execute the SQL command
            cursor.execute(sql)
            # Fetch all the rows in a list of lists.
            results = cursor.fetchall()

            # Delete existing artwork media
            media = Media.objects.filter(is_artwork=True)
            media.delete()

            # Set artsmap path - directory for media files downloaded from fp-artsmap.ca
            artsmap_path = "{}{}{}".format(settings.BASE_DIR, settings.MEDIA_URL, "fp-artsmap")

            # Delete fp-artsmap directory contents if it exists
            if os.path.exists(artsmap_path):
                files = glob.glob("{}/*".format(artsmap_path))
                for f in files:
                    if os.path.isfile(f):
                        os.remove(f)
                    elif os.path.isdir(f):
                        shutil.rmtree(f)

            # Create fp-artsmap directory
            if not os.path.exists(artsmap_path):
                os.mkdir(artsmap_path)

            for row in results:
                # Extract data from query row
                nid = row[0]
                filename = row[3]
                uri = row[4]
                mime_type = row[5]
                file_type = row[9]

                print('Processing {}'.format(filename))

                # Instantiate Media object and fill data
                current_media = Media()

                current_media.node_id = nid
                current_media.name = filename
                current_media.mime_type = mime_type
                current_media.file_type = file_type
                current_media.is_artwork = True
                current_media.status = "VE"

                # If the video is from youtube/vimeo, only store their url
                # Else, download the file from fp-artsmap.ca and set the media_file
                from_youtube = uri.startswith("youtube://v/")
                from_vimeo = uri.startswith("vimeo://v/")

                if from_youtube or from_vimeo:
                    if from_youtube:
                        current_media.url = uri.replace("youtube://v/", "https://youtube.com/watch?v=")
                    elif from_vimeo:
                        current_media.url = uri.replace("vimeo://v/", "https://vimeo.com/")
                else:
                    # Set up paths
                    download_url = uri.replace("public://", files_url)
                    storage_path = "{}/{}".format(artsmap_path, uri.replace("public://", ""))
                    media_path = "{}/{}".format("fp-artsmap", uri.replace("public://", ""))

                    if not os.path.exists(os.path.dirname(storage_path)):
                        print('Creating ' + os.path.dirname(storage_path))
                        os.makedirs(os.path.dirname(storage_path), exist_ok=True)

                    response = requests.get(download_url, allow_redirects=True)
                    open(storage_path, 'wb').write(response.content)

                    current_media.media_file = media_path

                current_media.save()
        else:
            print("{} is no longer up.".format(files_url))
