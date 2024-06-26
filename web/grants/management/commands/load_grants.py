from django.core.management.base import BaseCommand

from grants.utils import load_grants_from_spreadsheet


class Command(BaseCommand):
    def handle(self, *args, **options):
        load_grants_from_spreadsheet(options["file_name"], options["test"])

    def add_arguments(self, parser):
        parser.add_argument("--file_name", type=str)
        parser.add_argument("--test", type=bool)
