<template>
  <DetailSideBar>
    <template v-slot:badges>
      <div>
        <h5
          class="color-gray font-08 p-0 m-0"
          style="margin-bottom: 0.2em !important;"
        >
          Language:
          <span class="font-weight-bold">{{ language.name }}</span>
        </h5>
      </div>
      <div>
        <Badge
          content="Communities"
          :number="communities.length"
          class="cursor-pointer"
          type="community"
          bgcolor="#6c4264"
          :mode="getBadgeStatus(mode, 'comm')"
          @click.native.prevent="handleBadge($event, 'comm')"
        ></Badge>
        <Badge
          content="Public Arts"
          :number="publicArts.length"
          class="cursor-pointer"
          bgcolor="#848159"
          type="part"
          :mode="getBadgeStatus(mode, 'public_art')"
          @click.native.prevent="handleBadge($event, 'public_art')"
        ></Badge>
        <Badge
          content="Organization"
          :number="orgs.length"
          class="cursor-pointer"
          bgcolor="#a48116"
          type="org"
          :mode="getBadgeStatus(mode, 'organization')"
          @click.native.prevent="handleBadge($event, 'organization')"
        ></Badge>
        <Badge
          content="Artists"
          :number="artists.length"
          class="cursor-pointer"
          bgcolor="#db531f"
          type="event"
          :mode="getBadgeStatus(mode, 'artist')"
          @click.native.prevent="handleBadge($event, 'artist')"
        ></Badge>
        <Badge
          content="Points Of Interest"
          :number="places.length"
          class="cursor-pointer mb-1"
          bgcolor="#c46156"
          type="poi"
          :mode="getBadgeStatus(mode, 'place')"
          @click.native.prevent="handleBadge($event, 'place')"
        ></Badge>
      </div>
    </template>
    <div class="language">
      <div
        class="color-row"
        :style="'background-color: ' + languageColor"
      ></div>
      <LanguageDetailCard
        :color="languageColor"
        :name="this.$route.params.lang"
        :server="isServer"
      ></LanguageDetailCard>
      <section class="ml-2 mr-2">
        <h5 class="other-lang-names-title text-uppercase mt-4">
          Other Language Names
        </h5>
        <LanguageDetailBadge
          v-for="name in otherNames"
          :key="name"
          :content="name"
          class="mr-2"
        ></LanguageDetailBadge>
        <LanguageSummary
          :population="language.pop_total_value.toString() || 'NA'"
          :speakers="language.fluent_speakers.toString() || 'NA'"
          :somewhat="language.some_speakers.toString() || 'NA'"
          :learners="language.learners.toString() || 'NA'"
          class="mt-4"
        ></LanguageSummary>
      </section>
      <section>
        <LanguageSeeAll
          :content="`Learn more about ${language.name}`"
          class="mt-3"
          @click.native="handleMoreDetails"
        ></LanguageSeeAll>
      </section>
      <Filters class="mb-4 mt-2"></Filters>
      <section class="pl-3 pr-3 pt-2">
        <div
          v-if="
            mode !== 'public_art' &&
              mode !== 'artist' &&
              mode !== 'organization' &&
              mode !== 'place'
          "
        >
          <CommunityCard
            v-for="community in communities"
            :key="'community' + community.id"
            :name="community.name"
            class="mt-3 hover-left-move"
            @click.native="
              $router.push({
                path: `/content/${encodeURIComponent(community.name)}`
              })
            "
          ></CommunityCard>
        </div>
        <div
          v-if="
            mode !== 'public_art' &&
              mode !== 'artist' &&
              mode !== 'organization' &&
              mode !== 'comm'
          "
        >
          <PlacesCard
            v-for="place in places"
            :key="'place' + place.id"
            :name="place.properties.name"
            class="mt-3 hover-left-move"
            @click.native="
              $router.push({
                path: `/place-names/${encodeURIComponent(
                  place.properties.name
                )}`
              })
            "
          ></PlacesCard>
        </div>
        <div
          v-if="
            mode !== 'place' &&
              mode !== 'artist' &&
              mode !== 'organization' &&
              mode !== 'comm'
          "
        >
          <ArtsCard
            v-for="(art, index) in publicArts"
            :key="'art' + index"
            class="mt-3 hover-left-move"
            :arttype="art.properties.art_type"
            :name="art.properties.name"
            @click.native="
              $router.push({
                path: `/art/${encodeURIComponent(art.properties.name)}`
              })
            "
          >
          </ArtsCard>
        </div>
        <div
          v-if="
            mode !== 'public_art' &&
              mode !== 'artist' &&
              mode !== 'place' &&
              mode !== 'comm'
          "
        >
          <ArtsCard
            v-for="(art, index) in orgs"
            :key="'art' + index"
            class="mt-3 hover-left-move"
            :arttype="art.properties.art_type"
            :name="art.properties.name"
            @click.native="
              $router.push({
                path: `/art/${encodeURIComponent(art.properties.name)}`
              })
            "
          >
          </ArtsCard>
        </div>
        <div
          v-if="
            mode !== 'public_art' &&
              mode !== 'place' &&
              mode !== 'organization' &&
              mode !== 'comm'
          "
        >
          <ArtsCard
            v-for="(art, index) in artists"
            :key="'art' + index"
            class="mt-3 hover-left-move"
            :arttype="art.properties.art_type"
            :name="art.properties.name"
            @click.native="
              $router.push({
                path: `/art/${encodeURIComponent(art.properties.name)}`
              })
            "
          >
          </ArtsCard>
        </div>
      </section>
    </div>
  </DetailSideBar>
</template>

<script>
import { mapState } from 'vuex'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageSummary from '@/components/languages/LanguageSummary.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import { zoomToLanguage } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import Badge from '@/components/Badge.vue'

export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge,
    LanguageSummary,
    LanguageSeeAll,
    CommunityCard,
    PlacesCard,
    ArtsCard,
    Filters,
    DetailSideBar,
    Badge
  },
  data() {
    return {
      mode: 'All'
    }
  },
  computed: {
    publicArts() {
      return this.arts.filter(art => art.properties.art_type === 'public_art')
    },
    orgs() {
      return this.arts.filter(art => art.properties.art_type === 'organization')
    },
    artists() {
      return this.arts.filter(art => art.properties.art_type === 'artist')
    },
    ...mapState({
      mapinstance: state => state.mapinstance.mapInstance,
      languages() {
        return this.$store.state.languages.languageSet
      },
      otherNames() {
        return this.language.other_names.split(',')
      },
      languageColor() {
        return this.language.color
      }
    })
  },
  watch: {
    language(newlang, oldlang) {
      if (oldlang && newlang && oldlang.name !== newlang.name) {
        zoomToLanguage({ map: this.mapinstance, lang: newlang })
      }
    }
  },
  async asyncData({ $axios, store, params }) {
    const languageName = params.lang

    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const languages = await $axios.$get(getApiUrl(`language/`))
    const language = languages.find(
      lang => lang.name.toLowerCase() === languageName.toLowerCase()
    )
    const languageId = language.id

    const result = await Promise.all([
      $axios.$get(getApiUrl(`language/${languageId}`)),
      $axios.$get(getApiUrl(`community/?lang=${languageId}`)),
      $axios.$get(getApiUrl(`placename-geo/?lang=${languageId}`)),
      $axios.$get(getApiUrl(`art/?lang=${languageId}`))
    ])

    const isServer = !!process.server

    return {
      language: result[0],
      communities: result[1],
      places: result[2].features,
      arts: result[3].features,
      isServer
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      zoomToLanguage({ map, lang: this.language })
    })
  },
  methods: {
    handleMoreDetails() {
      this.$router.push({
        path: `${encodeURIComponent(this.$route.params.lang)}/details`
      })
    }
  },
  head() {
    return {
      title: this.language.name + ' Language Resources and Stats',
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `${this.language.name}, also known as ${
            this.language.other_names
          } is an indigenous language of British Columbia.`
        }
      ]
    }
  }
}
</script>

<style scoped>
.color-row {
  background-color: black;
  height: 7px;
}
.other-lang-names-title {
  color: var(--color-gray);
  font-size: 0.8em;
}
</style>
