from .models import (
    Language,
    PlaceName,
    Recording,
    PlaceNameCategory,
    Community,
    Champion,
    LanguageFamily,
    LanguageLink,
    Dialect,
    CommunityLink,
    CommunityMember,
    LNA,
    LNAData,
    Media,
    Favourite,
    Notification,
    CommunityLanguageStats,
)
from users.serializers import PublicUserSerializer, UserSerializer
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

class RecordingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recording
        fields = ("id", "audio_file", "speaker", "recorder", "created", "date_recorded")

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


class CommunityLanguageStatsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityLanguageStats
        fields = (
            "language",
            "community",
            "fluent_speakers",
            "semi_speakers",
            "active_learners",
        )

class PlaceNameLightSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "id", "category", "other_names")


class LanguageDetailSerializer(serializers.ModelSerializer):
    places = PlaceNameLightSerializer(many=True, read_only=True)
    family = LanguageFamilySerializer(read_only=True)
    champion_set = ChampionSerializer(read_only=True, many=True)
    languagelink_set = LanguageLinkSerializer(read_only=True, many=True)
    dialect_set = DialectSerializer(read_only=True, many=True)
    # lna_set = LNADetailSerializer(read_only=True, many=True)
    # Atomic Writable APIs
    family_id = serializers.PrimaryKeyRelatedField(
        queryset=LanguageFamily.objects.all(), write_only=True, source="family"
    )
    champion_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Champion.objects.all(),
        write_only=True,
        source="champion_set",
        required=False,
    )
    languagelink_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=LanguageLink.objects.all(),
        write_only=True,
        source="languagelink_set",
        required=False,
    )
    language_audio = RecordingSerializer(read_only=True)
    greeting_audio = RecordingSerializer(read_only=True)

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
            "language_audio",
            "greeting_audio",
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
            "family_id",
            "champion_ids",
            "languagelink_ids",
            "places",
            "total_schools",
            "avg_hrs_wk_languages_in_school",
            "ece_programs",
            "avg_hrs_wk_languages_in_ece",
            "language_nests",
            "avg_hrs_wk_languages_in_language_nests", 
            "community_adult_language_classes",
            "fv_guid",
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
        fields = ("name", "other_names", "id", "audio_file", "status", "category")
        geo_field = "geom"


class CommunityLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityLink
        fields = ("title", "url")


class CommunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "id", "point", "audio_file")


class CommunityMemberSerializer(serializers.ModelSerializer):
    user = PublicUserSerializer(read_only=True)
    community = CommunitySerializer(read_only=True)

    class Meta:
        model = CommunityMember
        fields = ("id", "user", "community")



class MediaLightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Media
        fields = ("id", "name", "description", "file_type", "url", "media_file", "status", "creator", "placename", "community", "community_only")


class CommunityDetailSerializer(serializers.ModelSerializer):
    champion_set = ChampionSerializer(read_only=True, many=True)
    communitylink_set = CommunityLinkSerializer(read_only=True, many=True)
    languages = LanguageSerializer(read_only=True, many=True)
    places = PlaceNameLightSerializer(many=True, read_only=True)
    medias = MediaLightSerializer(many=True, read_only=True)
    audio = serializers.PrimaryKeyRelatedField(
        queryset=Recording.objects.all(), allow_null=True, required=False
    )
    audio_obj = RecordingSerializer(source="audio", read_only=True)

    # Atomic Writable APIs
    language_ids = serializers.PrimaryKeyRelatedField(
        many=True, queryset=Language.objects.all(), write_only=True, source="languages"
    )
    champion_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Champion.objects.all(),
        write_only=True,
        source="champion_set",
        required=False,
    )
    communitylink_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=CommunityLink.objects.all(),
        write_only=True,
        source="communitylink_set",
        required=False,
    )

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
                    lna_name = by_lang[lid]["lna"]["name"]
                    print(lna_name)
                    by_lang[lid]['lna']['url'] = self.build_lna_external_url(lna_name)
                    # print(by_lang[lid]['lna'])
            else:
                by_lang[lid] = LNADataSerializer(lnadata).data
                lna_name = by_lang[lid]["lna"]["name"]
                print(lna_name)
                by_lang[lid]['lna']['url'] = "denis"
                # print(by_lang[lid]['lna'])

        rep["lna_by_language"] = by_lang
        return rep

    def build_lna_external_url(self, lna_name):
        permalink = "https://maps.fpcc.ca/lna/"
        try:
            lna_external_id = lna_name.split('-')[0].strip().replace("LNA","")
            print(lna_external_id)
            lna_link = permalink + lna_external_id
            print(lna_link)
        except:
            lna_link = permalink
        return lna_link

    class Meta:
        model = Community
        fields = (
            "id",
            "name",
            "languages",
            "regions",
            "audio",
            "audio_obj",
            "audio_file",
            "champion_set",
            "communitylink_set",
            "english_name",
            "other_names",
            "internet_speed",
            "population",
            "point",
            "email",
            "website",
            "phone",
            "alt_phone",
            "fax",
            "language_ids",
            "champion_ids",
            "communitylink_ids",
            "places",
            "medias",
            "notes",
            "nation_id",
            "population_on_reserve",
            "population_off_reserve",
            "fv_guid",
            "fv_archive_link",
        )


class PlaceNameCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceNameCategory
        fields = ("id", "name", "icon_name")


class PlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("name", "id", "kind", "category", "status", "status_reason")


class MediaSerializer(serializers.ModelSerializer):
    creator = PublicUserSerializer(read_only=True)
    placename_obj = PlaceNameLightSerializer(source="placename", read_only=True)
    class Meta:
        model = Media
        fields = (
            "id",
            "name",
            "description",
            "file_type",
            "url",
            "media_file",
            "community_only",
            "placename",
            "placename_obj",
            "community",
            "status",
            "status_reason",
            "creator",
        )


class FavouriteSerializer(serializers.ModelSerializer):
    user = PublicUserSerializer(read_only=True)
    placename_obj = PlaceNameLightSerializer(source="place", read_only=True)
    media_obj = MediaLightSerializer(source="media", read_only=True)
    class Meta:
        model = Favourite
        fields = (
            "id", 
            "name", 
            "media", 
            "media_obj", 
            "user", 
            "place", 
            "placename_obj",
            "favourite_type", 
            "description", 
            "point", 
            "zoom"
        )


class NotificationSerializer(serializers.ModelSerializer):
    user = PublicUserSerializer(read_only=True)
    language_obj = LanguageSerializer(source="language", read_only=True)
    community_obj = CommunitySerializer(source="community", read_only=True)

    class Meta:
        model = Notification
        fields = ("id", "name", "user", "language", "community","language_obj", "community_obj")


class FavouritePlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Favourite
        fields = (
            "id", 
        )


class PlaceNameDetailSerializer(serializers.ModelSerializer):
    medias = MediaLightSerializer(many=True, read_only=True)
    creator = PublicUserSerializer(read_only=True)
    community = serializers.PrimaryKeyRelatedField(
        queryset=Community.objects.all(), allow_null=True, required=False
    )
    language = serializers.PrimaryKeyRelatedField(
        queryset=Language.objects.all(), allow_null=True, required=False
    )
    category = serializers.PrimaryKeyRelatedField(
        queryset=PlaceNameCategory.objects.all(), allow_null=True, required=False
    )
    category_obj = PlaceNameCategorySerializer(source="category", read_only=True)
    favourites = FavouritePlaceNameSerializer(many=True, read_only=True)
    audio = serializers.PrimaryKeyRelatedField(
        queryset=Recording.objects.all(), allow_null=True, required=False
    )
    audio_obj = RecordingSerializer(source="audio", read_only=True)

    class Meta:
        model = PlaceName
        fields = (
            "name",
            "id",
            "geom",
            "other_names",
            "audio",
            "audio_obj",
            "audio_file",
            "audio_name",
            "audio_description",
            "kind",
            "common_name",
            "community_only",
            "description",
            "status",
            "status_reason",
            "category",
            "category_obj",
            "medias",
            "community",
            "language",
            "creator",
            "favourites",
        )
        depth = 1
