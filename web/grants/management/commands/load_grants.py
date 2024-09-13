from django.core.management.base import BaseCommand
import pandas as pd


from grants.models import Grant, GrantCategory


class Command(BaseCommand):
    help = "Load grants from an excel spreadsheet. Run migrate_manytomany_fields.py and geocode_grants.py after."

    def handle(self, *args, **options):
        load_grants_from_spreadsheet(options["file_name"], options["test"])

    def add_arguments(self, parser):
        parser.add_argument("--file_name", type=str)
        parser.add_argument("--test", type=bool)


def load_grants_from_spreadsheet(file_name, test=False):
    # Convert excel into dataframe
    grants_dataframe = pd.read_excel(file_name, sheet_name=0)

    # Replace NaN values with empty string
    grants_dataframe.fillna("", inplace=True)

    for _, sheet_row in grants_dataframe.iterrows():
        category_abbreviation = sheet_row["Grant"].strip().split(" ")[0]

        grant_category = GrantCategory.objects.get(abbreviation=category_abbreviation)

        if test:
            print(sheet_row["Grant"])
            continue

        print("Saving ", sheet_row["Grant"])

        Grant.objects.create(
            grant=sheet_row["Grant"],
            language=sheet_row["Language"],
            year=int(sheet_row["Year"]) if sheet_row["Year"] else None,
            recipient=sheet_row["Recipient"],
            community_affiliation=sheet_row["Community/Affiliation"],
            title=sheet_row["Title"],
            project_brief=sheet_row["Project Brief"],
            amount=sheet_row["Amount"],
            address=sheet_row["Address"],
            city=sheet_row["City"],
            province=sheet_row["Province"],
            postal_code=sheet_row["Postal Code"],
            grant_category=grant_category,
        )
