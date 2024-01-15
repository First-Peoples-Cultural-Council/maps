from unidecode import unidecode

from django.core.management.base import BaseCommand

from grants.models import Grant
from language.models import Language, Community, PlaceName


class Command(BaseCommand):
    help = ""

    def handle(self, *args, **options):
        migrate_manytomany_fields(options["start_id"])

    def add_arguments(self, parser):
        parser.add_argument("--start_id", type=int)


def migrate_manytomany_fields(start_id):
    get_values("language", start_id)
    get_values("community", start_id)
    get_values("placename", start_id)


def check_invalid_values(search_value, model):
    invalid_values = []
    if model == "community":
        invalid_values = [
            "cree",
            "shuswap",
            "dene",
            "pacheedaht",
            "first nations",
            "first nation",
        ]
    elif model == "recipient":
        invalid_values = ["s", "first nations"]

    # invalid if search value invalid or if search value length 1 or less
    return search_value in invalid_values or len(search_value) <= 1


def get_ids(search_value, all_values, model):
    value = unidecode(search_value).strip().lower() if search_value else None
    results = [
        v["id"]
        for v in all_values
        if value in v["name"].lower() or value in v["other_names"].lower()
    ]

    # if value is invalid, return empty list instead
    if check_invalid_values(value, model):
        return []
    return results


def split_and_get_ids(separator, search_value, all_values, model):
    results = []
    if separator in search_value:
        search_values = [
            v.strip().lower() for v in search_value.split(separator) if v.strip()
        ]
        for value in search_values:
            results += get_ids(value, all_values, model)
    return results


def get_values(model, start_id):
    languages = [
        {"id": l.id, "name": unidecode(l.name), "other_names": unidecode(l.other_names)}
        for l in Language.objects.all()
    ]
    communities = [
        {"id": c.id, "name": unidecode(c.name), "other_names": unidecode(c.other_names)}
        for c in Community.objects.all()
    ]
    recipients = [
        {"id": r.id, "name": unidecode(r.name), "other_names": unidecode(r.other_names)}
        for r in PlaceName.objects.filter(kind="artist")
    ]

    all_values = []
    if model == "language":
        all_values = languages
    elif model == "community":
        all_values = communities
    elif model == "placename":
        all_values = recipients

    if start_id:
        grants = Grant.objects.filter(id__gte=start_id).order_by("id")
    else:
        grants = Grant.objects.order_by("id")

    for grant in grants:
        print("Saving language, community and recipient for {}".format(grant.id))
        search_value = None

        if model == "language":
            search_value = grant.language if grant.language else None
        elif model == "community":
            search_value = (
                grant.community_affiliation if grant.community_affiliation else None
            )
        elif model == "placename":
            search_value = grant.recipient if grant.recipient else None

        if search_value:
            possible_value_ids = []
            possible_values = get_ids(search_value, all_values, model)

            if possible_values:
                possible_value_ids += possible_values
            else:
                possible_value_ids += split_and_get_ids(
                    "/", search_value, all_values, model
                )
                possible_value_ids += split_and_get_ids(
                    ";", search_value, all_values, model
                )
                possible_value_ids += split_and_get_ids(
                    ",", search_value, all_values, model
                )
                possible_value_ids += split_and_get_ids(
                    " and ", search_value, all_values, model
                )
                possible_value_ids += split_and_get_ids(
                    "&", search_value, all_values, model
                )

            value_list = []
            for _id in set(possible_value_ids):
                if model == "language":
                    obj = Language.objects.get(pk=_id)
                    grant.languages.add(obj)
                elif model == "community":
                    obj = Community.objects.get(pk=_id)
                    grant.communities_affiliations.add(obj)
                elif model == "placename":
                    obj = PlaceName.objects.get(pk=_id)
                    grant.recipients.add(obj)
                grant.save()
