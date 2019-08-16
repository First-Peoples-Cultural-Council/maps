from .models import (
    Language,
    PlaceName,
    PlaceNameCategory,
    Community,
    Champion,
    LanguageFamily,
    LanguageLink,
    Dialect,
    CommunityLink,
    LNA,
    LNAData,
    Media
)
from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer


class LanguageFamilySerializer(serializers.ModelSerializer):
    class Meta:
        model = LanguageFamily
        fields = ("name", "color")


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
    family = LanguageFamilySerializer(read_only=True)

    class Meta:
        model = Language
        fields = ("name", "id", "color", "bbox", "sleeping", "family", "other_names")


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
    family = LanguageFamilySerializer(read_only=True)
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
            "audio_file",
            "sleeping",
            "dialect_set",
            "fv_archive_link",
            "color",
            "family",
            "notes",
            "fluent_speakers",
            "learners",
            "some_speakers",
            "pop_total_value",
            "bbox",
            "audio_file",
        )


class LanguageGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = Language
        fields = ("name", "color", "sleeping")
        geo_field = "geom"


class CommunityGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "other_names")
        geo_field = "point"


class PlaceNameGeoSerializer(GeoFeatureModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "other_names", "id", "audio_file")
        geo_field = "point"


class CommunityLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityLink
        fields = ("title", "url")


class CommunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "id", "point", "audio_file")


class CommunityDetailSerializer(serializers.ModelSerializer):
    champion_set = ChampionSerializer(read_only=True, many=True)
    communitylink_set = CommunityLinkSerializer(read_only=True, many=True)
    languages = LanguageSerializer(read_only=True, many=True)
    # hide history lnas for now, just show most recent
    def to_representation(self, value):
        rep = super().to_representation(value)
        by_lang = {}
        # get most recent lna for each nation
        for lnadata in LNAData.objects.filter(community=value).select_related("lna"):
            if not lnadata.lna:
                continue
            lid = getattr(lnadata.lna, "language_id")
            if not lid:
                continue
            if lid in by_lang:
                if lnadata.lna.year > by_lang[lid]["lna"]["year"]:
                    by_lang[lid] = LNADataSerializer(lnadata).data
            else:
                by_lang[lid] = LNADataSerializer(lnadata).data
        rep["lna_by_language"] = by_lang
        return rep

    class Meta:
        model = Community
        fields = (
            "id",
            "name",
            "languages",
            "regions",
            "audio_file",
            "champion_set",
            "communitylink_set",
            "english_name",
            "other_names",
            "internet_speed",
            "population",
            "email",
            "website",
            "phone",
            "alt_phone",
            "fax",
            "audio_file",
        )
        geo_field = "point"


class PlaceNameCategory(serializers.ModelSerializer):
    class Meta:
        model = PlaceNameCategory
        fields = ("id", "name", "icon_file")


class PlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "id", "point", "other_names", "audio_file", 
                    "kind", "western_name", "traditional_name", 
                    "community_only", "description", "status")


# Serializer only for composing PlaceName data
class PlaceNameMediaSerializer(serializers.ModelSerializer):
	class Meta:
		model = Media
		fields = ("id", "name", "description", "file_type", "url", "media_file")
                    

class MediaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Media
        fields = ("id", "name", "description", "file_type", "url", "media_file", "placename")


class PlaceNameDetailSerializer(serializers.ModelSerializer):
    medias = PlaceNameMediaSerializer(many=True, read_only=True)
    class Meta:
        model = PlaceName
        fields = ("name", "id", "point", "other_names", "audio_file", 
                    "kind", "western_name", "traditional_name", 
                    "community_only", "description", "status", "category", "medias")
        depth = 1
