import os
import csv

from django.core.management.base import BaseCommand
from django.contrib.gis.geos import Point

from web import dedruplify
from grants.models import Grant
from grants.constants import CATEGORY_ABBREVIATIONS, NEW_CATEGORIES
from grants.utils import load_grants_from_spreadsheet


class Command(BaseCommand):
    help = "Load grants from old arts database."

    def handle(self, *args, **options):
        sync_grants()


def sync_grants():

    c = Client(
        os.environ["ARTSMAP_HOST"],
        os.environ["ARTSMAP_USER"],
        os.environ["ARTSMAP_PW"],
        os.environ["ARTSMAP_DB"],
    )
    grants = Grant.objects.all()
    grants.delete()

    c.load_grants_from_arts_db()
    load_grants_from_spreadsheet("grants.xlsx")


class Client(dedruplify.DeDruplifierClient):

    def load_grants_from_arts_db(self):
        grants = self.get_grants()

        grant_data = {}

        with open("old-arts-grants.csv", "w", encoding="utf-8") as file:
            writer = csv.writer(file)
            writer.writerow(
                [
                    "Year",
                    "Grant",
                    "Language",
                    "Recipient",
                    "Community/Affiliation",
                    "Title",
                    "Project Brief",
                    "Amount",
                    "Address",
                    "City",
                    "Province",
                    "Postal Code",
                    "Status",
                    "Category",
                    "Node ID",
                ]
            )

            for grant in grants:
                grant_id = grant.get("nid", "")
                grant_title = grant.get("title", "")

                grant_data["year"] = self.get_year(grant_id)
                grant_data["affiliation"] = self.get_affiliation(grant_id)
                grant_data["project_brief"] = self.get_project_brief(grant_id)

                grant_data["recipient"] = self.update_recipient(
                    self.get_recipient(grant_id), grant_title, grant_id
                )
                grant_data["category"] = self.update_category(
                    self.get_category(grant_id)
                )

                location = self.get_location(grant_id)
                grant_data["address"] = location.get("address", "") if location else ""
                grant_data["city"] = location.get("city", "") if location else ""
                grant_data["province"] = (
                    location.get("province", "") if location else ""
                )
                grant_data["postal_code"] = (
                    location.get("postal_code", "") if location else ""
                )

                updated_grant_title = self.update_grant_title(
                    grant_data["category"], grant_data["year"], grant_title
                )
                grant_data["grant"] = updated_grant_title

                writer.writerow(
                    [
                        f"{grant_data['year']}",
                        f"{grant_data['grant']}",
                        "",  # For language
                        f"{grant_data['recipient']}",
                        f"{grant_data['affiliation']}",
                        f"{grant_title }",  # For title
                        f"{grant_data['project_brief']}",
                        "",  # For Amount
                        f"{grant_data['address']}",
                        f"{grant_data['city']}",
                        f"{grant_data['province']}",
                        f"{grant_data['postal_code']}",
                        "",  # For status
                        f"{grant_data['category']}",
                        f"{grant_id}",
                    ]
                )

                point = None
                if (
                    location
                    and location.get("latitude", None)
                    and location.get("longitude", None)
                ):
                    point = Point(
                        float(location.get("longitude")),
                        float(location.get("latitude")),
                    )

                Grant.objects.create(
                    grant=grant_data["grant"],
                    year=int(grant_data["year"]) if grant_data["year"] else None,
                    recipient=grant_data["recipient"],
                    community_affiliation=grant_data["affiliation"],
                    project_brief=grant_data["project_brief"],
                    address=grant_data["address"],
                    city=grant_data["city"],
                    province=grant_data["province"],
                    postal_code=grant_data["postal_code"],
                    category=grant_data["category"],
                    point=point,
                )

    def update_recipient(self, recipient, title, grant_id):
        is_new_grant = grant_id > 1190

        if is_new_grant:
            if not recipient:
                if title:
                    title_data = title.split("- ")

                    if title_data:
                        return title_data[0].strip()

        return recipient

    def update_category(self, category):
        if category:
            return NEW_CATEGORIES[category]

        return category

    def update_grant_title(self, category, year, title):
        if category and year:
            category_abbreviation = CATEGORY_ABBREVIATIONS[category]
            year_start = int(year)
            year_end = abs(year_start) % 100 + 1

            return "{} {}-{}".format(category_abbreviation, year_start, year_end)

        return title

    def get_grants(self):
        return self.query("SELECT nid, title FROM node WHERE type='grant';")

    def get_year(self, grant_id):
        year = self.query(
            """
            SELECT
                field_grant_award_year_value
            FROM
                node
            LEFT JOIN
                field_data_field_grant_award_year
            ON
                nid=entity_id
            WHERE
                nid=%s;
        """
            % grant_id
        )
        if year:
            return (
                year[0].get("field_grant_award_year_value")
                if year[0].get("field_grant_award_year_value")
                else ""
            )

        return ""

    def get_affiliation(self, grant_id):
        affiliation = self.query(
            """
            SELECT
                field_grant_affiliation_value
            FROM
                field_data_field_grant_affiliation
            where
                entity_id=%s;
        """
            % grant_id
        )
        if affiliation:
            return affiliation[0].get("field_grant_affiliation_value", "")

        return ""

    def get_recipient(self, grant_id):
        recipient = self.query(
            """
            SELECT
                title
            FROM
                field_data_field_grant_recipient,
                (
                    SELECT
                        entity_id, title, type
                    FROM
                        field_data_field_grant_recipient, node
                    WHERE
                        field_grant_recipient_nid=nid
                ) AS recipient_node
            WHERE
                field_data_field_grant_recipient.entity_id = recipient_node.entity_id
            AND
                recipient_node.entity_id=%s;
        """
            % grant_id
        )
        if recipient:
            return recipient[0].get("title", "")

        recipient = self.query(
            """
            SELECT
                field_grant_recipient_text_value
            FROM
                field_data_field_grant_recipient_text
            WHERE
                entity_id=%s;
        """
            % grant_id
        )

        if recipient:
            return recipient[0].get("title", "")

        return ""

    def get_project_brief(self, grant_id):
        project_brief = self.query(
            """
            SELECT
                body_value
            FROM
                field_data_body
            WHERE
                entity_id=%s;
        """
            % grant_id
        )
        if project_brief:
            return project_brief[0].get("body_value", "")

        return ""

    def get_location(self, grant_id):
        location = self.query(
            """
            SELECT
                latitude, longitude, street, city, province, postal_code
            FROM
                location
            JOIN
                field_data_field_shared_location
            ON
                lid=field_shared_location_lid
            WHERE
                entity_id=%s;
        """
            % grant_id
        )
        if location:
            return {
                "latitude": location[0].get("latitude", ""),
                "longitude": location[0].get("longitude", ""),
                "address": location[0].get("street", ""),
                "city": location[0].get("city", ""),
                "province": location[0].get("province", ""),
                "postal_code": location[0].get("postal_code", ""),
            }

        return None

    def get_category(self, grant_id):
        category = self.query(
            """
            SELECT
                name
            FROM
                field_data_field_grant_category
            LEFT JOIN
                taxonomy_term_data
            ON
                field_grant_category_tid=tid
            where
                entity_id=%s;
        """
            % grant_id
        )
        if category:
            return category[0].get("name", "")

        return ""
