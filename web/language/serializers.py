from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer


from .models import (
    Language,
    PlaceName,
    PublicArtArtist,
    Recording,
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
    Taxonomy,
    PlaceNameTaxonomy,
    RelatedData
)
from users.serializers import PublicUserSerializer, UserSerializer


# LIGHT SERIALIZERS
class TaxonomyLightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Taxonomy
        fields = (
            "id",
            "name",
        )


class MediaLightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Media
        fields = (
            "id",
            "name",
            "description",
            "file_type",
            "url",
            "media_file",
            "status",
            "creator",
            "placename",
            "community",
            "community_only"
        )


class PlaceNameLightSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = (
            "name",
            "id",
            "kind",
            "other_names",
            "community",
            "community_only",
            "creator",
            "taxonomies"
        )


# NORMAL SERIALIZERS
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


class RecordingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recording
        fields = (
            "id",
            "audio_file",
            "speaker",
            "recorder",
            "created",
            "date_recorded"
        )


class LanguageSerializer(serializers.ModelSerializer):
    family = LanguageFamilySerializer(read_only=True)

    class Meta:
        model = Language
        fields = ("name", "id", "color", "bbox",
                  "sleeping", "family", "other_names")


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


class CommunityLinkSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityLink
        fields = ("title", "url")


class CommunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name", "id", "point", "audio")


class CommunityMemberSerializer(serializers.ModelSerializer):
    user = PublicUserSerializer(read_only=True)
    community = CommunitySerializer(read_only=True)

    class Meta:
        model = CommunityMember
        fields = ("id", "user", "community")


class RelatedPlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = (
            "id",
            "name",
            "image"
        )


class PlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = (
            "id",
            "name",
            "kind",
            "status",
            "status_reason"
        )


class MediaSerializer(serializers.ModelSerializer):
    creator = PublicUserSerializer(read_only=True)
    placename_obj = PlaceNameLightSerializer(
        source="placename", read_only=True)

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
            "mime_type",
            "is_artwork",
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
        fields = ("id", "name", "user", "language",
                  "community", "language_obj", "community_obj")


class FavouritePlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Favourite
        fields = (
            "id",
        )


class TaxonomySerializer(serializers.ModelSerializer):
    class Meta:
        model = Taxonomy
        fields = (
            'id',
            'name',
            'description',
            'order',
            'parent'
        )


class RelatedDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = RelatedData
        fields = '__all__'


# DETAIL SERIALIZERS
class PlaceNameDetailSerializer(serializers.ModelSerializer):
    medias = MediaLightSerializer(many=True, read_only=True)
    creator = PublicUserSerializer(read_only=True)
    community = serializers.PrimaryKeyRelatedField(
        queryset=Community.objects.all(), allow_null=True, required=False
    )
    language = serializers.PrimaryKeyRelatedField(
        queryset=Language.objects.all(), allow_null=True, required=False
    )
    favourites = FavouritePlaceNameSerializer(many=True, read_only=True)
    audio = serializers.PrimaryKeyRelatedField(
        queryset=Recording.objects.all(), allow_null=True, required=False
    )
    audio_obj = RecordingSerializer(source="audio", read_only=True)
    public_arts = RelatedPlaceNameSerializer(many=True, read_only=True)
    related_data = RelatedDataSerializer(many=True, required=False)

    # Primary Key Related fields -> could be updated by passing a list of ids
    artists = serializers.PrimaryKeyRelatedField(
        queryset=PlaceName.objects.filter(kind='artist'), many=True, required=False)
    taxonomies = serializers.PrimaryKeyRelatedField(
        queryset=Taxonomy.objects.all(), many=True, required=False)

    def create(self, validated_data):
        # If related_data is included in the payload, pop it first
        related_data = validated_data.pop('related_data', [])
        artists = validated_data.pop('artists', [])
        taxonomies = validated_data.pop('taxonomies', [])

        # Save the PlaceName without a related_data
        placename = PlaceName.objects.create(**validated_data)

        # Save all related data one by one if they were added in the payload
        if related_data:
            for data in related_data:
                RelatedData.objects.create(**data)
        
        if artists:
            for artist in artists:
                PublicArtArtist.objects.create(
                    public_art=placename,
                    artist=artist
                )
        
        if taxonomies:
            for taxonomy in taxonomies:
                PlaceNameTaxonomy.objects.create(
                    placename=placename,
                    taxonomy=taxonomy
                )

        return placename

    def update(self, instance, validated_data):
        # If the instance already has related_data, we must first delete them
        if 'related_data' in validated_data:
            RelatedData.objects.filter(placename__id=instance.id).delete()

        # If related_data is included in the payload, pop it first
        related_data = validated_data.pop('related_data', [])

        # Update all the other properties in the validated_data
        placename = super().update(instance, validated_data)

        # Save all related data one by one if they were added in the payload
        if len(related_data) > 0:
            for data in related_data:
                data['placename'] = placename
                RelatedData.objects.create(**data)

        return placename

    def to_representation(self, instance):
        # Get original representation
        representation = super(PlaceNameDetailSerializer,
                               self).to_representation(instance)

        # Alter representation for taxonomies
        # From list of ids -> to list of Taxonomy dictionaries
        taxonomies_representation = []
        taxonomies = representation.get('taxonomies')
        for taxonomy_id in taxonomies:
            curr_taxonomy = Taxonomy.objects.get(pk=taxonomy_id)
            serializer = TaxonomySerializer(curr_taxonomy)
            taxonomies_representation.append(serializer.data)
        representation['taxonomies'] = taxonomies_representation

        # Alter representation for taxonomies
        # From list of ids -> to list of PlaceName dictionaries
        artists_representation = []
        artists = representation.get('artists')
        for artist_id in artists:
            curr_artist = PlaceName.objects.get(pk=artist_id)
            serializer = RelatedPlaceNameSerializer(curr_artist)
            artists_representation.append(serializer.data)
        representation['artists'] = artists_representation

        return representation

    class Meta:
        model = PlaceName
        fields = (
            "name",
            "id",
            "geom",
            "image",
            "other_names",
            "audio",
            "audio_obj",
            "kind",
            "common_name",
            "community_only",
            "description",
            "status",
            "status_reason",
            "medias",
            "community",
            "language",
            "creator",
            "favourites",
            "taxonomies",
            "public_arts",
            "artists",
            "related_data"
        )
        depth = 1


class LNADetailSerializer(serializers.ModelSerializer):
    """
    Used nested inside LanguageSerializer
    """

    lnadata_set = LNADataSerializer(read_only=True, many=True)

    class Meta:
        model = LNA
        fields = ("name", "id", "year", "language", "lnadata_set")


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
                    by_nation[lnadata.community_id] = LNADataSerializer(
                        lnadata).data
            else:
                by_nation[lnadata.community_id] = LNADataSerializer(
                    lnadata).data
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
        lnas = []
        # get most recent lna for each nation
        lnadatas = LNAData.objects.filter(
            community=value).select_related("lna").order_by("-lna__year")
        for lnadata in lnadatas:
            if not lnadata.lna:
                continue
            lid = getattr(lnadata.lna, "language_id")
            if not lid:
                continue

            lna_serialized = LNADataSerializer(lnadata).data
            lna_name = lna_serialized["lna"]["name"]
            # print(lna_name)
            lna_serialized['lna']['url'] = self.build_lna_external_url(
                lna_name)
            # print(lna_serialized['lna'])

            if lid in by_lang:
                if lnadata.lna.year > by_lang[lid]["lna"]["year"]:
                    by_lang[lid] = lna_serialized
            else:
                by_lang[lid] = lna_serialized

            lnas.append(lna_serialized)

        # print(lnas)
        rep["lna_by_language"] = by_lang
        rep["lnas"] = lnas
        return rep

    def build_lna_external_url(self, lna_name):
        permalink = "https://maps.fpcc.ca/lna/"
        try:
            lna_external_id = lna_name.split('-')[0].strip().replace("LNA","")
            lna_link = permalink + lna_external_id
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


# GEO SERIALIZERS
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
        fields = ("id", "name", "kind", "community")
        geo_field = "geom"


# SEARCH SERIALIZERS
class PlaceNameSearchSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = ("id", "name", "other_names", "kind")


class LanguageSearchSerializer(serializers.ModelSerializer):
    family = LanguageFamilySerializer(read_only=True)

    class Meta:
        model = Language
        fields = ("name", "other_names", "family")


class CommunitySearchSerializer(serializers.ModelSerializer):
    class Meta:
        model = Community
        fields = ("name",)


# ARTS SERIALIZERS
# Base serializer
class ArtPlaceNameSerializer(GeoFeatureModelSerializer):
    taxonomies = TaxonomyLightSerializer(many=True, read_only=True)

    class Meta:
        model = PlaceName
        fields = (
            "id",
            "name",
            "kind",
            "image",
            "taxonomies"
        )
        geo_field = "geom"


class EventArtSerializer(ArtPlaceNameSerializer):
    related_data = RelatedDataSerializer(many=True, read_only=True)

    class Meta:
        model = PlaceName
        fields = ArtPlaceNameSerializer.Meta.fields + (
            "related_data",
        )
        geo_field = "geom"


class ArtworkPlaceNameSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlaceName
        fields = (
            "id",
            "name",
            "image",
            "kind",
            "geom",
            
        )


class ArtworkSerializer(serializers.ModelSerializer):
    placename = ArtworkPlaceNameSerializer(read_only=True)

    class Meta:
        model = Media
        fields = (
            "id",
            "name",
            "file_type",
            "url",
            "media_file",
            "placename"
        )

    def to_representation(self, value):
        representation = super().to_representation(value)

        updated_representation = {}
        # Add a kind field
        updated_representation["id"] = representation["id"]
        updated_representation["geometry"] = representation["placename"]["geom"]
        updated_representation["type"] = "Feature"
        updated_representation["properties"] = {
            "name": representation["name"],
            "kind": "artwork",
            "file_type": representation["file_type"],
            "media_file": representation["media_file"],
            "url": representation["url"],
            "placename": representation["placename"]
        }

        return updated_representation
