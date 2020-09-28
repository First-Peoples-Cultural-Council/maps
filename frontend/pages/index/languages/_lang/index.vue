<template>
  <div class="w-100">
    <div v-if="language" class="w-100">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          Language:
          <span class="font-weight-bold">{{ language.name }}</span>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
        <Logo class="cursor-pointer" :logo-alt="1"></Logo>
        <div
          class="text-center d-none mobile-close"
          :class="{ 'content-mobile': mobileContent }"
          @click="$store.commit('sidebar/setMobileContent', false)"
        >
          <img
            class="d-inline-block"
            src="@/assets/images/arrow_down_icon.svg"
          />
        </div>

        <div class="color-row" :style="'background-color: ' + languageColor">
          &nbsp;
        </div>
        <LanguageDetailCard
          :color="languageColor"
          :name="language.name"
          :server="isServer"
          :link="language.fv_archive_link"
          :audio-file="getMediaUrl(audio_obj.audio_file, isServer)"
          :greeting-file="getMediaUrl(greeting_obj.audio_file, isServer)"
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
          <p class="source-link">
            Source:
            <a
              :href="
                `https://fpcc.ca/wp-content/uploads/2020/07/FPCC-LanguageReport-180716-WEB.pdf`
              "
              target="_blank"
              >Report on the status of B.C. First Nations Languages 2018</a
            >
          </p>
        </section>
        <section>
          <b-row>
            <b-col xs="6">
              <Notification
                :id="language.id"
                :unsubscribe="!!subscribed"
                :subscription="subscribed"
                :is-server="isServer"
                type="language"
                class="ml-3 mr-3 mt-3"
                title="Follow This Language"
              ></Notification>
            </b-col>
            <b-col xs="6"></b-col>
          </b-row>

          <LanguageSeeAll
            :content="`Learn more about ${language.name}`"
            class="mt-3"
            @click.native="handleMoreDetails"
          ></LanguageSeeAll>
        </section>
        <!-- <Filters class="mb-1 mt-2"></Filters> -->
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
                    class="mt-2 hover-left-move"
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
                    :place="place"
                    class="mt-2 hover-left-move"
                    @click.native="
                      handleCardClick($event, place.properties.name, 'places')
                    "
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
                    class="mt-2 hover-left-move"
                    :name="art.properties.name"
                    :kind="art.properties.kind"
                    :geometry="art.geometry"
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
                    class="mt-2 hover-left-move"
                    :name="art.properties.name"
                    :kind="art.properties.kind"
                    :geometry="art.geometry"
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
                    class="mt-2 hover-left-move"
                    :name="art.properties.name"
                    :kind="art.properties.kind"
                    :geometry="art.geometry"
                    :layout="'landscape'"
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
    <ErrorScreen v-else></ErrorScreen>
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
import Badge from '@/components/Badge.vue'
import { getApiUrl, encodeFPCC, getMediaUrl } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import Notification from '@/components/Notification.vue'
import ErrorScreen from '@/layouts/error.vue'

export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge,
    LanguageSummary,
    LanguageSeeAll,
    CommunityCard,
    PlacesCard,
    ArtsCard,
    Badge,
    Logo,
    Notification,
    ErrorScreen
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
        ? this.arts.filter(art => art.properties.kind === 'public_art')
        : []
    },
    orgs() {
      return this.arts
        ? this.arts.filter(art => art.properties.kind === 'organization')
        : []
    },
    artists() {
      return this.arts
        ? this.arts.filter(art => art.properties.kind === 'artist')
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

    if (language) {
      const languageId = language.id
      const isServer = !!process.server
      const result = await Promise.all([
        $axios.$get(
          getApiUrl(`language/${languageId}?timestamp=${new Date().getTime()}`)
        ),
        $axios.$get(getApiUrl(`community/?lang=${languageId}`)),
        $axios.$get(getApiUrl(`art-geo/?lang=${languageId}`)),
        $axios.$get(getApiUrl(`placename-geo/?lang=${languageId}`))
      ])

      try {
        await store.dispatch('user/getNotifications', {
          isServer: !!process.server
        })
      } catch (e) {}

      store.commit('places/setBadgePlaces', result[3].features)
      store.commit('places/setFilteredBadgePlaces', result[3].features)

      let audio_obj = {}
      if (result[0].language_audio) {
        audio_obj = result[0].language_audio
      }

      let greeting_obj = {}
      if (result[0].greeting_audio) {
        greeting_obj = result[0].greeting_audio
      }

      return {
        language: result[0],
        communities: result[1],
        places: result[3].features,
        arts: result[2].features,
        isServer,
        audio_obj,
        greeting_obj
      }
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
  beforeRouteLeave(to, from, next) {
    this.$root.$emit('stopLanguageAudio')
    next()
  },
  methods: {
    getMediaUrl,
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
    },
    getHeaderTitle() {
      if (this.language) {
        return this.language.name + ' Language Resources and Stats'
      } else {
        return 'Language page not found'
      }
    },
    getHeaderDescription() {
      if (this.language) {
        if (this.language.other_names) {
          return `${this.language.name}, also known as ${this.language.other_names}, is an indigenous language of British Columbia.`
        } else {
          return `${this.language.name} is an indigenous language of British Columbia.`
        }
      } else {
        return 'Language page not found.'
      }
    }
  },
  head() {
    return {
      title: this.getHeaderTitle(),
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.getHeaderDescription()
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
.source-link {
  margin: 8px 0;
}
</style>
