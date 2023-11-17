import pandas as pd

from django.core.management.base import BaseCommand

from language.models import Language, LanguageFamily


class Command(BaseCommand):
    def handle(self, *args, **options):
        filename = options.get("filename")
        check = options.get("check", 1)
        update_language_stats_from_file(filename, check)

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


def update_language_stats_from_file(filename, check=1):
    print("Reading ", filename)
    print("Check ", check)

    df = pd.read_csv(filename)

    error = False
    language_stats = []

    for index, row in df.iterrows():
        row_number = index + 2
        current_family = row["Family"]
        current_language = row["Language"]
        total_population = row["Population"]
        fluent_speakers = row["Fluent Speakers"]
        semi_speakers = row["Semi-Speakers"]
        active_learners = row["Learners"]

        family = None
        language = None

        try:
            family = LanguageFamily.objects.get(name__unaccent__iexact=current_family)
        except LanguageFamily.DoesNotExist:
            error = True
            print(f"Row {row_number} - Language Family not found: {current_family}")

        try:
            language = Language.objects.get(name__unaccent__iexact=current_language)
        except Language.DoesNotExist:
            error = True
            print(f"Row {row_number} - Language not found: {current_language}")

        if family and language:
            language_stats.append(
                {
                    "family": family.id,
                    "language": language.id,
                    "total_population": total_population,
                    "fluent_speakers": fluent_speakers,
                    "semi_speakers": semi_speakers,
                    "active_learners": active_learners,
                }
            )

    if check and error:
        return print("File check failed, upload will not proceed")

    print("Uploading")

    for data in language_stats:
        family_id = data.get("family")
        language_id = data.get("language")
        total_population = data.get("total_population")
        fluent_speakers = data.get("fluent_speakers")
        semi_speakers = data.get("semi_speakers")
        active_learners = data.get("active_learners")

        family = LanguageFamily.objects.get(pk=family_id)
        language = Language.objects.get(pk=language_id, family=family)

        # Update community language stats
        language.fluent_speakers = fluent_speakers
        language.some_speakers = semi_speakers
        language.learners = active_learners
        language.pop_total_value = total_population
        language.save()

        print(f"Saved {family.name} - {language.name}")
