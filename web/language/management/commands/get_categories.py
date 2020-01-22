from django.core.management.base import BaseCommand, CommandError

import psycopg2

class Command(BaseCommand):

    # Get the local database address passed in from the bash script
    def add_arguments(self, parser):
            parser.add_argument('hostAddress')

    def handle(self, *args, **options):
        hostAddress = options['hostAddress']

        # Connect to the database
        conn = psycopg2.connect(host=hostAddress, dbname="postgres", user="postgres")
        cur = conn.cursor()

        # Open the csv and copy it into the database row by row
        with open('./fixtures/categories.csv', 'r') as f:
            next(f)

            cur.copy_from(f, 'language_placenamecategory', sep=',')

            conn.commit()

        print('Successfully added categories.')