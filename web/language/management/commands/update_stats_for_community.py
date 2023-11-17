import pandas as pd

from django.core.management.base import BaseCommand

from language.models import Language, Community, CommunityLanguageStats


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
        current_community = row["Community"]
        current_language = row["Language"]
        total_population = row["Population"]
        fluent_speakers = row["Fluent Speakers"]
        semi_speakers = row["Semi-Speakers"]
        active_learners = row["Learners"]

        community = None
        language = None

        try:
            community = Community.objects.get(name__unaccent__iexact=current_community)
        except Community.DoesNotExist:
            error = True
            print(f"Row {row_number} - Community not found: {current_community}")

        try:
            language = Language.objects.get(name__unaccent__iexact=current_language)
        except Language.DoesNotExist:
            error = True
            print(f"Row {row_number} - Language not found: {current_language}")

        if community and language:
            language_stats.append(
                {
                    "community": community.id,
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
        community_id = data.get("community")
        language_id = data.get("language")
        total_population = data.get("total_population")
        fluent_speakers = data.get("fluent_speakers")
        semi_speakers = data.get("semi_speakers")
        active_learners = data.get("active_learners")

        latest_stats_for_pair = None
        stats_to_delete = None

        community = Community.objects.get(pk=community_id)
        language = Language.objects.get(pk=language_id)

        # Delete all duplicates, if there are any
        matching_stats = CommunityLanguageStats.objects.filter(
            community=community,
            language=language,
        )

        latest_stats_for_pair = matching_stats.last()

        if latest_stats_for_pair:
            stats_to_delete = matching_stats.exclude(id=latest_stats_for_pair.id)
            stats_to_delete.delete()

        # Save new data
        stats, _created = CommunityLanguageStats.objects.get_or_create(
            community=community,
            language=language,
        )

        # Update community language stats
        stats.fluent_speakers = fluent_speakers
        stats.semi_speakers = semi_speakers
        stats.active_learners = active_learners
        stats.save()

        # Update community population
        community = stats.community
        community.population = total_population
        community.save()
        print(f"Saved {stats.language.name} - {stats.community.name}")
