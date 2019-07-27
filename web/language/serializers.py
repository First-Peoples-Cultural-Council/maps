from .models import (
    Language,
    PlaceName,
    Community,
    Champion,
    LanguageSubFamily,
    LanguageFamily,
    LanguageLink,
    Dialect,
    CommunityLink,
    LNA,
    LNAData,
)
from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer


class LanguageFamilySerializer(serializers.ModelSerializer):
    class Meta:
        model = LanguageFamily
        fields = ("name",)


class LanguageSubFamilySerializer(serializers.ModelSerializer):
    family = LanguageFamilySerializer(read_only=True)

    class Meta:
        model = LanguageSubFamily
        fields = ("name", "family")


class ChampionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Champion
        fields = ("name", "bio", "job", "community")


class LanguageLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = LanguageLink
        fields = ("title", "url")


class DialectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dialect
        fields = ("name",)


class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ("name", "id", "color", "bbox")


class LNASerializer(serializers.ModelSerializer):
    language = serializers.SlugRelatedField(read_only=True, slug_field="name")

    class Meta:
        model = LNA
        fields = ("name", "id", "year", "language")


class LNADataSerializer(serializers.ModelSerializer):
    lna = LNASerializer(read_only=True)
    community = serializers.SlugRelatedField(read_only=True, slug_field="name")

    class Meta:
        model = LNAData
        fields = (
            "name",
            "id",
            "lna",
            "community",
            "fluent_speakers",
            "some_speakers",
            "learners",
            "pop_off_res",
            "pop_on_res",
            "pop_total_value",
        )


class LNADetailSerializer(serializers.ModelSerializer):
    """
    Used nested inside LanguageSerializer
    """

    lnadata_set = LNADataSerializer(read_only=True, many=True)

    class Meta:
        model = LNA
        fields = ("name", "id", "year", "language", "lnadata_set")


class LanguageDetailSerializer(serializers.ModelSerializer):
    sub_family = LanguageSubFamilySerializer(read_only=True)
    champion_set = ChampionSerializer(read_only=True, many=True)
    languagelink_set = LanguageLinkSerializer(read_only=True, many=True)
    dialect_set = DialectSerializer(read_only=True, many=True)
    # lna_set = LNADetailSerializer(read_only=True, many=True)

    def to_representation(self, value):
        rep = super().to_representation(value)
        by_nation = {}
        # get most recent lna for each nation
        for lnadata in LNAData.objects.filter(lna__language=value).select_related(
            "lna"
        ):
            if lnadata.community_id in by_nation:
                if lnadata.lna.year > by_nation[lnadata.community_id]["lna"]["year"]:
                    by_nation[lnadata.community_id] = LNADataSerializer(lnadata).data
            else:
                by_nation[lnadata.community_id] = LNADataSerializer(lnadata).data
        rep["lna_by_nation"] = by_nation
        return rep

    class Meta:
        model = Language
        fields = (
            "id",
            "name",
            "other_names",
            "regions",
            "champion_set",
            "languagelink_set",
            # "lna_set",
            "dialect_set",
            "fv_archive_link",
            "color",
            "sub_family",
            "notes",
            "fluent_speakers",
            "learners",
            "some_speakers",
            "pop_total_value",
            "bbox",
        )


class LanguageGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = Language
        fields = ("name", "color")
        geo_field = "geom"


class PlaceNameGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "other_name", "id", "audio_file")
        geo_field = "point"


class CommunityLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityLink
        fields = ("title", "url")


class CommunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "id", "point")


class CommunityDetailSerializer(serializers.ModelSerializer):
    champion_set = ChampionSerializer(read_only=True, many=True)
    communitylink_set = CommunityLinkSerializer(read_only=True, many=True)
    languages = serializers.SlugRelatedField(
        read_only=True, slug_field="name", many=True
    )
    # hide history lnas for now.
    # lnadata_set = LNADataSerializer(read_only=True, many=True)
    def to_representation(self, value):
        rep = super().to_representation(value)
        by_lang = {}
        # get most recent lna for each nation
        for lnadata in LNAData.objects.filter(community=value).select_related("lna"):
            if lnadata.lna.language_id in by_lang:
                if lnadata.lna.year > by_lang[lnadata.lna.language_id]["lna"]["year"]:
                    by_lang[lnadata.lna.language_id] = LNADataSerializer(lnadata).data
            else:
                by_lang[lnadata.lna.language_id] = LNADataSerializer(lnadata).data
        rep["lna_by_language"] = by_lang
        return rep

    class Meta:
        model = Community
        fields = (
            "id",
            "name",
            "languages",
            "regions",
            "champion_set",
            "communitylink_set",
            # "lnadata_set",
            "english_name",
            "other_names",
            "internet_speed",
            "population",
            "email",
            "website",
            "phone",
            "alt_phone",
            "fax",
        )
        geo_field = "point"
