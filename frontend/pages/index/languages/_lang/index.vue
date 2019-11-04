<template>
  <div class="w-100">
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        Language:
        <span class="font-weight-bold">{{ language.name }}</span>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>
    <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
      <div
        class="text-center d-none mobile-close"
        :class="{ 'content-mobile': mobileContent }"
        @click="$store.commit('sidebar/setMobileContent', false)"
      >
        <img class="d-inline-block" src="@/assets/images/arrow_down_icon.svg" />
      </div>

      <div class="color-row" :style="'background-color: ' + languageColor">
        &nbsp;
      </div>
      <LanguageDetailCard
        :color="languageColor"
        :name="language.name"
        :server="isServer"
        :link="language.fv_archive_link"
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
      <Filters class="mb-1 mt-2"></Filters>
      <Notification
        v-if="isLoggedIn"
        :id="language.id"
        :unsubscribe="!!subscribed"
        :subscription="subscribed"
        :is-server="isServer"
        type="language"
        class="ml-3 mr-3 mt-2"
      ></Notification>
      <div class="badge-container mt-2 ml-3 mr-3">
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
      <div class="language">
        <section class="pl-3 pr-3 pt-2">
          <div
            v-if="
              mode !== 'public_art' &&
                mode !== 'artist' &&
                mode !== 'organization' &&
                mode !== 'place'
            "
          >
            <b-row>
              <b-col
                v-for="community in communities"
                :key="'community' + community.id"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <CommunityCard
                  :name="community.name"
                  :community="community"
                  class="mt-3 hover-left-move"
                  @click.native="
                    handleCardClick($event, community.name, 'comm')
                  "
                ></CommunityCard>
              </b-col>
            </b-row>
          </div>
          <div
            v-if="
              mode !== 'public_art' &&
                mode !== 'artist' &&
                mode !== 'organization' &&
                mode !== 'comm'
            "
          >
            <b-row>
              <b-col
                v-for="place in filteredPlaces"
                :key="'place' + place.id"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <PlacesCard
                  :name="place.name"
                  :place="{ properties: place }"
                  class="mt-3 hover-left-move"
                  @click.native="handleCardClick($event, place.name, 'places')"
                ></PlacesCard>
              </b-col>
            </b-row>
          </div>
          <div
            v-if="
              mode !== 'place' &&
                mode !== 'artist' &&
                mode !== 'organization' &&
                mode !== 'comm'
            "
          >
            <b-row>
              <b-col
                v-for="(art, index) in publicArts"
                :key="'art' + index"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <ArtsCard
                  class="mt-3 hover-left-move"
                  :art="art"
                  @click.native="
                    handleCardClick($event, art.properties.name, 'art')
                  "
                >
                </ArtsCard>
              </b-col>
            </b-row>
          </div>
          <div
            v-if="
              mode !== 'public_art' &&
                mode !== 'artist' &&
                mode !== 'place' &&
                mode !== 'comm'
            "
          >
            <b-row>
              <b-col
                v-for="(art, index) in orgs"
                :key="'art' + index"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <ArtsCard
                  class="mt-3 hover-left-move"
                  :art="art"
                  @click.native="
                    handleCardClick($event, art.properties.name, 'art')
                  "
                >
                </ArtsCard>
              </b-col>
            </b-row>
          </div>
          <div
            v-if="
              mode !== 'public_art' &&
                mode !== 'place' &&
                mode !== 'organization' &&
                mode !== 'comm'
            "
          >
            <b-row>
              <b-col
                v-for="(art, index) in artists"
                :key="'art' + index"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <ArtsCard
                  class="mt-3 hover-left-move"
                  :art="art"
                  @click.native="
                    handleCardClick($event, art.properties.name, 'art')
                  "
                >
                </ArtsCard>
              </b-col>
            </b-row>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script>
import ArtsCard from '@/components/arts/ArtsCard.vue'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageSummary from '@/components/languages/LanguageSummary.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import { zoomToLanguage, selectLanguage } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import Badge from '@/components/Badge.vue'
import { getApiUrl, encodeFPCC } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import Notification from '@/components/Notification.vue'

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
    Badge,
    Logo,
    Notification
  },
  data() {
    return {
      mode: 'All'
    }
  },
  computed: {
    filteredPlaces() {
      return this.$store.state.places.filteredBadgePlaces
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    subscribed() {
      return this.notifications.find(n => n.language === this.language.id)
    },
    notifications() {
      return this.$store.state.user.notifications
    },
    publicArts() {
      return this.arts
        ? this.arts.filter(art => art.properties.art_type === 'public_art')
        : []
    },
    orgs() {
      return this.arts
        ? this.arts.filter(art => art.properties.art_type === 'organization')
        : []
    },
    artists() {
      return this.arts
        ? this.arts.filter(art => art.properties.art_type === 'artist')
        : []
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    languages() {
      return this.$store.state.languages.languageSet
    },
    otherNames() {
      return this.language.other_names.split(',')
    },
    languageColor() {
      return this.language.color
    }
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

    const languages = await $axios.$get(getApiUrl(`language/`))

    const language = languages.find(
      lang => encodeFPCC(lang.name) === languageName
    )
    const languageId = language.id
    const isServer = !!process.server
    const result = await Promise.all([
      $axios.$get(
        getApiUrl(`language/${languageId}?timestamp=${new Date().getTime()}`)
      ),
      $axios.$get(getApiUrl(`community/?lang=${languageId}`)),
      $axios.$get(getApiUrl(`art/?lang=${languageId}`))
    ])

    try {
      await store.dispatch('user/getNotifications', {
        isServer: !!process.server
      })
    } catch (e) {}

    console.log('RegExp Url')

    store.commit('places/setBadgePlaces', result[0].places)
    store.commit('places/setFilteredBadgePlaces', result[0].places)

    return {
      language: result[0],
      communities: result[1],
      places: result[0].places,
      arts: result[2].features,
      isServer
    }
  },
  async fetch({ store }) {
    if (store.state.user.isLoggedIn) {
      await store.dispatch('user/getNotifications', {
        isServer: !!process.server
      })
    }
  },
  mounted() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      if (this.$route.hash.length <= 1) {
        zoomToLanguage({ map, lang: this.language })
      } else {
        selectLanguage({ map, lang: this.language })
      }
    })
  },
  methods: {
    handleNotificationAdded() {},
    handleMoreDetails() {
      this.$router.push({
        path: `${encodeFPCC(this.$route.params.lang)}/details`
      })
    },
    handleCardClick($event, name, type) {
      switch (type) {
        case 'lang':
          this.$router.push({
            path: `/languages/${encodeFPCC(name)}`
          })
          break
        case 'art':
          this.$router.push({
            path: `/art/${encodeFPCC(name)}`
          })
          break
        case 'comm':
          this.$router.push({
            path: `/content/${encodeFPCC(name)}`
          })
          break
        case 'places':
          this.$router.push({
            path: `/place-names/${encodeFPCC(name)}`
          })
          break
      }
    }
  },
  head() {
    return {
      title: this.language.name + ' Language Resources and Stats',
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `${this.language.name}, also known as ${this.language.other_names} is an indigenous language of British Columbia.`
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
  color: var(--color-gray, #6f6f70);
  font-size: 0.8em;
}
</style>
