import csv

from django.core.management.base import BaseCommand
from language.models import Taxonomy


class Command(BaseCommand):
    help = 'Loads categories from the csv in '

    def handle(self, *args, **options):
        try:
            # Fetch parent POI taxonomy which we will use
            # as a parent to the newly added taxonomies
            parent_poi_taxonomy = Taxonomy.objects.get(
                name='Point of Interest')
        except Taxonomy.DoesNotExist:
            # Create parent taxonomy if it doesn't exist yet
            parent_poi_taxonomy = Taxonomy.objects.create(
                name='Point of Interest',
                description='Point of Interest'
            )

        # Open the csv and copy it into the database row by row
        with open('./fixtures/categories.csv', 'r') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 1
            for row in csv_reader:
                try:
                    taxonomy = Taxonomy.objects.get(name__iexact=row[0])

                    print('Updating {}'.format(row[0]))
                    # If child taxonomy already exists, just update the details
                    taxonomy.description = row[1]
                    taxonomy.order = line_count
                    taxonomy.save()
                except Taxonomy.DoesNotExist:
                    # Create child taxonomy if it doesn't exist yet
                    taxonomy = Taxonomy.objects.create(
                        name=row[0],
                        description=row[1],
                        order=line_count,
                        parent=parent_poi_taxonomy
                    )
                    print('Creating {}'.format(row[0]))

                line_count += 1

        print('Successfully added categories.')
