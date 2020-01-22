from django.core.management.base import BaseCommand, CommandError
from language.models import PlaceNameCategory

import csv
import re

class Command(BaseCommand):
    help = 'Loads categories from the csv in '

    def handle(self, *args, **options):



        # Open the csv and copy it into the database row by row
        with open('./fixtures/categories.csv', 'r') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 1
            for row in csv_reader:
                curr_icon = self.format_icon_name(row[0])
                self.category = PlaceNameCategory.objects.create(name=row[0], icon_name=curr_icon)
                line_count += 1

        print('Successfully added categories.')

    # Function to format icon names based on category names
    def format_icon_name(self, string):

        # Remove all non alphanumeric characters
        string = re.sub(r"[^\w\s]", '', string)

        # Replace all spaces with an underscore
        string = re.sub(r"\s+", '_', string)

        # Make all characters lowercase
        string = string.lower()

        return string

