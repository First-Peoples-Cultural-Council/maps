import pymysql
from django.core.management.base import BaseCommand, CommandError
from language.models import (
    Language,
    LanguageFamily,
    Community,
    Champion,
    PlaceName,
    Dialect,
    CommunityLink,
    LanguageLink,
    LNA,
    LNAData,
)

import os
import sys
import json
from django.core.files import File
from web import dedruplify


class Client(dedruplify.DeDruplifierClient):
    def load(self):
        """
        Populate Django DB based on Drupal output.
        """
        self.map_drupal_items("tm_language", LanguageFamily)

        for rec, obj in self.map_drupal_items(
            "tm_language_region",
            Language,
            {
                "field_tm_lang_subfam_target_id": "sub_family",
                "field_tm_lr_colour_value": "color",
                "field_tm_other_lang_names_value": "other_names",
                "field_tm_lr_firstvoi_link_url": "fv_archive_link",
                "field_tm_lr_state_note_value": "notes",
                "field_tm_lr_sleeping": "sleeping",
            },
        ):
            for i, v in enumerate(rec.get("field_tm_lr_link_title", [])):
                title = rec["field_tm_lr_link_title"][i]
                url = rec["field_tm_lr_link_url"][i]
                LanguageLink.objects.get_or_create(language=obj, title=title, url=url)

                if "field_tm_region_tid" in rec:
                    # regions are saved in Drupal's taxonomy terms, dig them out.
                    regions = []
                    for term_id in rec["field_tm_region_tid"]:
                        for t in TAX_TERMS:
                            if t[0] == term_id:
                                regions.append(t[2])
                    obj.regions = ",".join(regions)
                    obj.save()

        for rec, obj in self.map_drupal_items(
            "tm_fn_group",
            Community,
            {
                "field_tm_fn_grp_website_url": "website",
                "field_tm_fn_comm_info_value": "notes",
                "field_tm_fn_grp_alt_title_value": "english_name",
                "field_tm_fn_internet_value": "internet_speed",
                "field_tm_fn_latlong_lat": "point",
                "field_tm_fn_total_pop_value": "population",
                "field_tm_fn_grp_alt_title_value": "other_names",
                "field_tm_fn_grp_email1_email": "email",
                "field_tm_fn_grp_fax_value": "fax",
                "field_tm_fn_grp_ph_tf_value": "phone",
                "field_tm_fn_grp_code_value": "nation_id",
                "field_tm_fn_grp_ph_value": "alt_phone",
            },
        ):
            if rec.get("body_value", [""])[0].strip():
                obj.notes += "\n\n" + rec["body_value"][0]
            for title in rec["field_tm_fn_lang_target_id_title"]:
                try:
                    lang = Language.objects.get(name=title)
                except Language.DoesNotExist:
                    continue
                obj.languages.add(lang)
            obj.save()

            for i, v in enumerate(rec.get("field_tm_fn_grp_links_title", [])):
                print("***", rec["field_tm_fn_grp_links_title"][i])
                title = rec["field_tm_fn_grp_links_title"][i]
                url = rec["field_tm_fn_grp_links_url"][i]
                CommunityLink.objects.get_or_create(community=obj, title=title, url=url)

            # regions are saved in Drupal's taxonomy terms, dig them out.
            regions = []
            for term_id in rec["field_tm_region_tid"]:
                for t in TAX_TERMS:
                    if t[0] == term_id:
                        regions.append(t[2])
            obj.regions = "".join(regions)

        self.load_placenames()

        self.load_champs()

        self.map_drupal_items(
            "tm_language_dialect", Dialect, {"field_language_target_id": "language"}
        )

        self.map_drupal_items(
            "lna1",
            LNA,
            {
                "field_tm_lna1_lang_target_id": "language",
                "field_tm_lna1_ass_year_value": "year",
                # "field_tm_lna1_challs_value": "challs",
                # "field_tm_lna1_dial_value": "dial",
                # "field_tm_lna1_funding_app_type_value": "funding_type",
                # "field_tm_lna1_lang_comm_value": "comm",
                # "field_tm_lna1_lna_contact_email_value": "contact_email",
                # "field_tm_lna1_lna_contact_fax_value": "contact_fax",
                # "field_tm_lna1_lna_contact_org_value": "contact_org",
                # "field_tm_lna1_lna_contact_ph_value": "contact_phone",
                # "field_tm_lna1_lna_contact_value": "contact_name",
                # "field_tm_lna1_opps_value": "opps",
                # "field_tm_lna1_status_value": "status",
                # "field_tm_lna1_status_date_value": "status_date",
                # "field_tm_lna1_subd_date_value": "submitted_date",
                # "field_tm_lna1_tot_errors_value": "num_errors",
                # "field_tm_lna1_subd_value": "is_submitted",
            },
        )

        for rec, obj in self.map_drupal_items(
            "lna2",
            LNAData,
            {
                "field_tm_lna2_lna_target_id": "lna",
                "field_tm_lna2_pop_off_res_value": "pop_off_res",
                "field_tm_lna2_pop_on_res_value": "pop_on_res",
                "field_tm_lna2_pop_total_value": "pop_total_value",
                "field_tm_lna2_com_target_id": "community",
            },
        ):
            obj.fluent_speakers = (
                rec["field_tm_lna2_on_fluent_sum_value"][0]
                + rec["field_tm_lna2_off_fluent_sum_value"][0]
            )
            obj.some_speakers = (
                rec["field_tm_lna2_on_some_sum_value"][0]
                + rec["field_tm_lna2_off_some_sum_value"][0]
            )
            obj.learners = (
                rec["field_tm_lna2_on_lrn_sum_value"][0]
                + rec["field_tm_lna2_off_lrn_sum_value"][0]
            )
            # count schools.
            obj.num_schools = 0
            if rec["field_tm_lna2_have_school_value"][0] == "yes":
                obj.num_schools += 1
            if rec["field_tm_lna2_have_school_2_value"][0] == "yes":
                obj.num_schools += 1
            if rec["field_tm_lna2_have_school_3_value"][0] == "yes":
                obj.num_schools += 1

            obj.nest_hours = rec.get("field_tm_lna2_lnest_hours_value", [0])[0]
            obj.oece_hours = rec.get("field_tm_lna2_oece_hours_value", [0])[0]
            obj.info = rec.get("field_tm_lna2_pop_add_info_value", [0])[0]
            obj.school_hours = rec.get("field_tm_lna2_school_hrs_value", [0])[0]
            obj.save()

    def load_champs(self):
        self.map_drupal_items(
            "tm_champ",
            Champion,
            {
                "field_tm_champ_bio_value": "bio",
                "field_language_target_id": "language",
                "field_tm_champ_occup_value": "job",
                "field_tm_nation_target_id": "community",
            },
        )

    def load_placenames(self):

        for rec, obj in self.map_drupal_items(
            "tm_placename",
            PlaceName,
            {
                "field_tm_pn_othername_value": "other_names",
                "field_tm_pn_location_lat": "point",
            },
        ):
            if "field_tm_pn_audio_fid_filename" in rec:
                src = os.path.join(
                    "tmp/files", rec["field_tm_pn_audio_fid_filename"][0]
                )
                print("saving from source ", src)
                f = open(src, "rb")
                obj.audio_file.save(rec["field_tm_pn_audio_fid_filename"][0], File(f))
                obj.save()

    def load_lnadata(self):
        for language in Language.objects.all():
            print(language, "is being updated from LNA data")
            language.fluent_speakers = 0
            language.some_speakers = 0
            language.pop_total_value = 0
            language.learners = 0

            by_nation = {}
            # get most recent lna for each nation
            for lnadata in LNAData.objects.filter(lna__language=language):
                if lnadata.community.id in by_nation:
                    if lnadata.lna.year > by_nation[lnadata.community.id].lna.year:
                        by_nation[lnadata.community.id] = lnadata
                else:
                    by_nation[lnadata.community.id] = lnadata

            # update languages.
            print(len(by_nation.keys()), "lnas found.")
            for id, lnadata in by_nation.items():
                language.fluent_speakers += lnadata.fluent_speakers
                language.some_speakers += lnadata.some_speakers
                language.pop_total_value += lnadata.pop_total_value
                language.learners += lnadata.learners
            language.save()


class Command(BaseCommand):
    help = "Closes the specified poll for voting"

    def handle(self, *args, **options):

        c = Client(
            os.environ["FPLM_HOST"],
            os.environ["FPLM_USER"],
            os.environ["FPLM_PW"],
            os.environ["FPLM_DB"],
            "https://maps.fpcc.ca/sites/default/files/",
        )
        # c.update()
        c.load_champs()
        c.load_placenames()
        # c.load()
        # c.load_lnadata()


# TODO: move to db query.
TAX_TERMS = (
    (1, 1, "South Coast", "", "full_html", 0, "1490fc86-f82b-4083-a927-deb7a110a3ea"),
    (2, 1, "Central Coast", "", "full_html", 0, "0c55c6f0-984d-4e39-8cc0-96988f603449"),
    (3, 1, "North Coast", "", "full_html", 0, "3a00835b-5f66-41d3-8c27-cec2d28fe49b"),
    (
        4,
        1,
        "Vancouver Island",
        "",
        "full_html",
        0,
        "451d13ea-0a81-4d77-bba3-c4a98686e262",
    ),
    (
        5,
        1,
        "Lower Mainland",
        "",
        "full_html",
        0,
        "3ab09683-1d0e-4949-8644-7efc74ee157f",
    ),
    (6, 1, "Fraser Valley", "", "full_html", 0, "a931767a-2092-4205-a941-c7735e6dc557"),
    (7, 1, "Interior", "", "full_html", 0, "d434ce1d-e531-4ff6-9a4e-c1b4949a1bde"),
    (
        8,
        1,
        "Thompson/Okanagan",
        "",
        "full_html",
        0,
        "24a33138-bd17-4c90-90d8-a962b8bb75f9",
    ),
    (
        9,
        1,
        "Kootenay Region",
        "",
        "full_html",
        0,
        "75b89b7a-db41-44bd-a953-6016a1a96df4",
    ),
    (10, 1, "Ten", "", "full_html", 0, "830d7f34-ad26-4a84-bb56-bc14d0fa894c"),
    (
        11,
        1,
        "Northeastern BC",
        "",
        "full_html",
        0,
        "2401376e-f183-4d97-a6cb-98a156a91725",
    ),
    (
        12,
        1,
        "Nachako/Stikine",
        "",
        "full_html",
        0,
        "f907fa16-5b90-45aa-b23d-5cbb71fbb23c",
    ),
)
