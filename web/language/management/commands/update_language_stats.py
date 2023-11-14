import pandas as pd

from django.core.management.base import BaseCommand

from language.models import Language, Community, CommunityLanguageStats


class Command(BaseCommand):
    def handle(self, *args, **options):
        filename = options["filename"]
        check = options["check"] or 1
        update_language_stats(filename, check)

    def add_arguments(self, parser):
        parser.add_argument(
            "--filename", nargs="?", type=str, help="Specify the filename"
        )
        parser.add_argument(
            "--check",
            nargs="?",
            type=int,
            help="Check if there are no missing data from the database",
        )


def update_language_stats(filename, check=1):
    print("Reading ", filename)
    print("Check ", check)

    df = pd.read_csv(filename)

    if check:
        error = False

        for index, row in df.iterrows():
            row_number = index + 1
            current_community = row["Community"]
            current_language = row["Language"]

            try:
                Community.objects.get(name__unaccent__iexact=current_community)
            except Community.DoesNotExist:
                error = True
                print(f"Row {row_number} - Community not found: {current_community}")

            try:
                Language.objects.get(name__unaccent__iexact=current_language)
            except Language.DoesNotExist:
                error = True
                print(f"Row {row_number} - Language not found: {current_language}")

        if not error:
            print("File check passed")
