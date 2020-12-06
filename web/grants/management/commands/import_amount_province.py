import csv

from django.core.management.base import BaseCommand

from grants.models import Grant


class Command(BaseCommand):
    help = "Import amount and provinces from updated spreadsheet."

    def handle(self, *args, **options):
        import_amount_and_province()

def import_amount_and_province():
    with open('./tmp/spreadsheets/amount_province.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')

        for row in csv_reader:
            grant = Grant.objects.get(pk=row[0])
            amount = row[1]
            province = row[2]

            if amount:
                grant.amount = amount
            if province:
                grant.province = province

            grant.save()

            print("Saving amount and province for {}".format(grant.id))
