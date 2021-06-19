<template>
  <div class="w-100">
    <div v-if="community" class="w-100">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          Community:
          <span class="font-weight-bold">{{ commDetails.name }}</span>
        </div>
        <div class="content-collapse-btn" @click="handleCollapseClick(true)">
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
        <Logo :logo-alt="1" class="cursor-pointer "></Logo>
        <div
          class="text-center d-none mobile-close"
          :class="{ 'content-mobile': mobileContent }"
          @click="handleCollapseClick(false)"
        >
          <img
            class="d-inline-block"
            src="@/assets/images/arrow_down_icon.svg"
          />
        </div>
        <CommunityDetailCard
          :name="commDetails.name"
          :population="commDetails.population"
          :server="isServer"
          :audio-file="getMediaUrl(audio_obj.audio_file, isServer)"
        >
          <template v-slot:notification>
            <Notification
              :id="community.id"
              :is-server="isServer"
              type="community"
              :unsubscribe="!!subscribed"
              :subscription="subscribed"
              title="Follow This Community"
            ></Notification>
          </template>
        </CommunityDetailCard>

        <hr class="sidebar-divider mt-0" />
        <Filters class="mb-3"></Filters>
        <section></section>
        <section class="pl-3 pr-3">
          <div v-if="otherNames">
            <h5 class="other-lang-names-title text-uppercase mt-">
              Other Community Names
            </h5>
            <LanguageDetailBadge
              v-for="(name, index) in otherNames"
              :key="index"
              :content="name"
              class="mr-2"
            ></LanguageDetailBadge>
          </div>
          <ul class="list-style-none m-0 p-0 mt-2">
            <li>
              <span class="font-08 color-gray">Email:</span>
              <span class="font-08 font-weight-bold color-gray">{{
                commDetails.email || 'N/A'
              }}</span>
            </li>
            <li>
              <span class="font-08 color-gray">Website:</span>
              <span class="font-08 font-weight-bold color-gray">{{
                commDetails.website || 'N/A'
              }}</span>
            </li>
            <li>
              <span class="font-08 color-gray">Phone #:</span>
              <span class="font-08 font-weight-bold color-gray">{{
                commDetails.phone || 'N/A'
              }}</span>
            </li>
            <li>
              <span class="font-08 color-gray">Alternate Phone #:</span>
              <span class="font-08 font-weight-bold color-gray">{{
                commDetails.alt_phone || 'N/A'
              }}</span>
            </li>
            <li>
              <span class="font-08 color-gray">Fax #:</span>
              <span class="font-08 font-weight-bold color-gray">{{
                commDetails.fax || 'N/A'
              }}</span>
            </li>
          </ul>
          <div v-if="hasCommunityPopulation" class="mt-3">
            <b-table
              hover
              :items="lnaByCommunity"
              responsive
              small
              table-class="lna-table"
              thead-class="lna-table-thead"
              tbody-class="lna-table-tbody"
              @row-clicked="handleRowClick"
            ></b-table>
            <client-only>
              <template v-if="lnaByCommunity.length !== 0">
                <div class="mb-3 ">
                  <b-button
                    block
                    variant="light"
                    class="font-08 "
                    @click="handleRowClick"
                    >{{
                      showCollapse ? 'Hide Charts' : 'Show Charts'
                    }}</b-button
                  >
                </div>
                <!-- <div class="mb-3 mt-3 showHide">
                  <b-button
                    block
                    variant="light"
                    class="font-08"
                    @click="toggleLNAPanel"
                    >{{ showLNAs ? 'Hide LNAs' : 'Show LNAs' }}</b-button
                  >
                </div> -->
              </template>

              <div v-if="showCollapse">
                <div
                  v-for="(lna, index) in lnaByCommunity"
                  :key="`chartlna${index}`"
                  class="mt-4 mb-4"
                >
                  <PieChart
                    :chartdata="extractChartData(lna)"
                    :options="options"
                  ></PieChart>
                </div>
              </div>
              <!-- <div v-if="showLNAs">
                <h5 class="mt-4">Language Needs Assessments</h5>
                <ul
                  v-for="(lnalink, index) in commDetails['lnas']"
                  :key="'lnalink' + index"
                  class="m-0 p-0 list-style-none"
                >
                  <li class="mt-2 mb-2">
                    <div>
                      <a :href="lnalink.lna['url']">{{ lnalink.name }}</a>
                    </div>
                    <div>Language: {{ lnalink.lna.language }}</div>
                  </li>
                </ul>
              </div> -->
            </client-only>
          </div>
        </section>
        <section class="pl-3 pr-3">
          <Badge
            v-if="commDetails.languages && commDetails.languages.length > 0"
            content="Languages"
            :number="commDetails.languages.length"
            class="cursor-pointer"
            type="language"
            :mode="getBadgeStatus(mode, 'lang')"
            @click.native.prevent="handleBadge($event, 'lang')"
          ></Badge>
          <Badge
            v-if="commDetails.places && commDetails.places.length > 0"
            content="Points Of Interest"
            :number="filteredPlaces.length"
            class="cursor-pointer mb-1"
            bgcolor="#c46156"
            type="poi"
            :mode="getBadgeStatus(mode, 'place')"
            :places="commDetails.places"
            @click.native.prevent="handleBadge($event, 'place')"
          ></Badge>
          <Badge
            content="Grants"
            :number="grantsList.length"
            class="cursor-pointer mb-1"
            bgcolor="#B47A2B"
            :mode="getBadgeStatus(mode, 'grant')"
            :places="commDetails.places"
            @click.native.prevent="handleBadge($event, 'grant')"
          ></Badge>
          <div v-if="mode !== 'place' && mode !== 'grant'">
            <b-row>
              <b-col
                v-for="language in commDetails.languages"
                :key="'language' + language.id"
                lg="12"
                xl="12"
                md="12"
                sm="12"
              >
                <LanguageCard
                  class="mt-2 hover-left-move"
                  :name="language.name"
                  :color="language.color"
                  @click.native.prevent="
                    handleCardClick($event, language.name, 'lang')
                  "
                ></LanguageCard>
              </b-col>
            </b-row>
          </div>

          <div
            v-if="
              commDetails.places &&
                commDetails.places.length > 0 &&
                mode !== 'lang' &&
                mode !== 'grant'
            "
          >
            <b-row>
              <b-col
                v-for="(place, index) in filteredPlaces"
                :key="`placescomm${index}`"
                lg="12"
                xl="12"
                md="12"
                sm="12"
                class="mt-2 hover-left-move"
              >
                <PlacesCard
                  v-if="place.kind === '' || place.kind === 'poi'"
                  :name="place.name"
                  :place="{ properties: place }"
                  @click.native.prevent="
                    handleCardClick($event, place.name, 'place')
                  "
                ></PlacesCard>
                <ArtsCard
                  v-else
                  :name="place.name"
                  :kind="place.kind"
                  @click.native.prevent="
                    handleCardClick($event, place.name, 'placename')
                  "
                ></ArtsCard>
              </b-col>
            </b-row>
          </div>
          <div v-if="mode !== 'lang' && mode !== 'place'">
            <b-row>
              <b-col
                v-for="(grant, index) in grantsList"
                :key="`grants-item-${index}`"
                lg="12"
                xl="12"
                md="12"
                sm="12"
                class="mt-2 hover-left-move"
              >
                <GrantsCard
                  :grant="grant"
                  :is-selected="currentGrant && currentGrant.id === grant.id"
                ></GrantsCard>
              </b-col>
            </b-row>
          </div>
        </section>
        <section class="ml-4 mr-4">
          <div v-if="isLoggedIn">
            <hr />
            <UploadTool
              :id="community.id"
              class="m-1 mb-3"
              type="community"
            ></UploadTool>
            <section v-if="medias && medias.length > 0">
              <h5 class="font-08 text-uppercase color-gray mb-3">
                {{ medias.length }} Uploaded Media
              </h5>
              <div
                v-for="media in medias"
                :key="'media' + media.id"
                class="mb-4"
              >
                <Media
                  :media="media"
                  :is-owner="isMediaCreator(media, user)"
                  :server="isServer"
                  type="community"
                  :community-only="media.community_only"
                ></Media>
                <hr class="mb-2" />
              </div>
            </section>
          </div>
        </section>
      </div>
    </div>
    <ErrorScreen v-else></ErrorScreen>
    <ScrollDownIndicator
      :desktop-container="'#sb-new-alt-one'"
    ></ScrollDownIndicator>
  </div>
</template>

<script>
import omit from 'lodash/omit'
import Logo from '@/components/Logo.vue'
import CommunityDetailCard from '@/components/communities/CommunityDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import Badge from '@/components/Badge.vue'
import ErrorScreen from '@/layouts/error.vue'
import {
  getApiUrl,
  encodeFPCC,
  makeMarker,
  getMediaUrl
} from '@/plugins/utils.js'
import PlacesCard from '@/components/places/PlacesCard.vue'
import UploadTool from '@/components/UploadTool.vue'
import Media from '@/components/Media.vue'
import Notification from '@/components/Notification.vue'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import GrantsCard from '@/components/grants/GrantsCard.vue'
import ScrollDownIndicator from '@/components/ScrollDownIndicator.vue'
import PieChart from '@/components/PieChart.vue'

export default {
  components: {
    // DetailSideBar,
    CommunityDetailCard,
    LanguageDetailBadge,
    Filters,
    LanguageCard,
    Badge,
    PlacesCard,
    Logo,
    UploadTool,
    Media,
    Notification,
    ArtsCard,
    ErrorScreen,
    GrantsCard,
    ScrollDownIndicator,
    PieChart
  },
  data() {
    return {
      mode: 'All',
      options: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          labels: {
            filter(legendItem, chartData) {
              if (legendItem.index === 3) {
                return false
              }
              return true
            }
          }
        },
        tooltips: {
          callbacks: {
            label(tooltipItems, data) {
              return `${data.labels[tooltipItems.index]}: ${(
                data.datasets[0].data[tooltipItems.index] * 100
              ).toFixed(1) + '%'}`
            }
          }
        },
        animation: {
          duration: 500,
          onProgress(animation) {
            const chartContext = this.chart.canvas.getContext('2d', {
              alpha: false
            })
            chartContext.fillStyle = '#4a4a4a'
            chartContext.font = '100 32px BCSans'
            chartContext.textBaseline = 'middle'
            chartContext.fillText(
              (this.data.datasets[0].learnerData[0] * 100).toFixed(2) + '%',
              this.chart.width / 2 - 30,
              this.chart.height / 2 - 5,
              200
            )
            chartContext.fillText(
              'Learners',
              this.chart.width / 2 - 58,
              this.chart.height / 2 + 25,
              200
            )
          }
        }
      },
      showCollapse: false,
      showLNAs: false
    }
  },

  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    badgePlaces() {
      return this.$store.state.places.badgePlaces
    },
    filteredPlaces() {
      const placesList = this.$store.state.places.filteredBadgePlaces

      return placesList.sort((a, b) => a.kind.localeCompare(b.kind))
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    user() {
      return this.$store.state.user.user
    },
    communities() {
      return this.$store.state.communities.communitySet
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    subscribed() {
      return this.notifications.find(n => n.community === this.community.id)
    },
    notifications() {
      return this.$store.state.user.notifications
    },
    medias() {
      return this.$store.state.places.medias
    },
    commDetails() {
      const filteredCommDetails = omit(this.communityDetail)
      const details = filteredCommDetails
      return details
    },
    lnaByCommunity() {
      /**  Remove Duplicate Language LNA data **/
      const lnaReduced = this.lnaData.reduce((uniqueLna, lnaItem) => {
        return uniqueLna.length !== 0 &&
          uniqueLna.some(lna => {
            return lna.language.id === lnaItem.language.id
          })
          ? uniqueLna
          : [...uniqueLna, lnaItem]
      }, [])

      /** * Get LNA percentage based on Community Population **/
      return lnaReduced
        .filter(lna => {
          const { fluent_speakers, semi_speakers, active_learners } = lna

          return (
            fluent_speakers !== 0 ||
            semi_speakers !== 0 ||
            active_learners !== 0
          )
        })
        .map(lna => {
          let fluentPercentage, semiSpeakersPercentage, activeLearnerPercentage
          const { fluent_speakers, semi_speakers, active_learners } = lna
          const communityPopulation = this.communityPopulation

          if (communityPopulation) {
            fluentPercentage =
              ((100 * fluent_speakers) / communityPopulation).toFixed(1) + '%'
            semiSpeakersPercentage =
              ((100 * semi_speakers) / communityPopulation).toFixed(1) + '%'
            activeLearnerPercentage =
              ((100 * active_learners) / communityPopulation).toFixed(1) + '%'
          } else {
            activeLearnerPercentage = 0
            fluentPercentage = 0
            semiSpeakersPercentage = 0
          }
          return {
            language: lna.language.name,
            fluent_speakers: fluentPercentage,
            semi_speakers: semiSpeakersPercentage,
            learners: activeLearnerPercentage
          }
        })
    },
    otherNames() {
      if (this.commDetails.other_names) {
        return this.commDetails.other_names.split(',')
      } else {
        return null
      }
    },
    grantsList() {
      return this.communityDetail.grants.features
    },
    currentGrant() {
      return this.$store.state.grants.currentGrant
    },

    communityPopulation() {
      return this.commDetails.population
    },
    hasCommunityPopulation() {
      return this.communityPopulation && this.communityPopulation !== 0
    }
  },
  watch: {
    community(newComm, oldComm) {
      if (newComm !== oldComm) {
        this.setupMap()
      }
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$emit('stopCommunityAudio')
    next()
  },
  async asyncData({ params, $axios, store, $route }) {
    const communities = await $axios.$get(
      getApiUrl(`community?timestamp=${new Date().getTime()}/`)
    )
    const community = communities.find(
      comm => encodeFPCC(comm.name) === params.fn
    )

    if (community) {
      const result = await Promise.all([
        $axios.$get(
          getApiUrl(
            `community/${community.id}?timestamp=${new Date().getTime()}/`
          )
        ),
        $axios.$get(getApiUrl(`stats?community=${community.id}`))
      ])

      const communityDetail = result[0]
      const lnaData = result[1]

      let audio_obj = {}
      if (communityDetail.audio_obj) {
        audio_obj = communityDetail.audio_obj
      } else {
        audio_obj = {
          audio_obj: null
        }
      }

      store.commit('places/setBadgePlaces', communityDetail.places)
      store.commit('places/setFilteredBadgePlaces', communityDetail.places)
      store.commit('places/setMedias', communityDetail.medias)

      const isServer = !!process.server

      return {
        audio_obj,
        mode: 'All',
        communityDetail,
        lnaData,
        isServer,
        community,
        datacollection: {
          labels: [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July'
          ],
          datasets: [
            {
              label: 'Data One',
              backgroundColor: '#f87979',
              data: [40, 39, 10, 40, 39, 80, 40]
            }
          ]
        }
      }
    }
  },
  async fetch({ store }) {
    try {
      await store.dispatch('user/getNotifications', {
        isServer: !!process.server
      })
    } catch (e) {}
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.setupMap()
  },
  mounted() {
    this.$root.$on('fileUploadedCommunity', r => {
      this.$store.dispatch('places/getCommunityMedias', {
        id: this.commDetails.id
      })
    })
    this.$root.$emit('triggerScrollVisibilityCheck')
  },
  methods: {
    getMediaUrl,
    isMediaCreator(media, user) {
      if (media.creator && user) {
        return user.id === media.creator.id || user.id === media.creator
      }
    },
    handleCollapseClick(value) {
      this.$store.commit('sidebar/setMobileContent', value)
      this.$root.$emit('togglehideScrollIndicator')
    },
    handleRowClick() {
      this.showCollapse = !this.showCollapse
      this.showLNAs = false
    },
    toggleLNAPanel() {
      this.showLNAs = !this.showLNAs
      this.showCollapse = false
    },
    extractChartData(lna) {
      // LNA Variabale Declaration
      const fluentSpeakerParse = parseFloat(lna.fluent_speakers)
      const semiSpeakerParse = parseFloat(lna.semi_speakers)
      const learnerSpeakerParse = parseFloat(lna.learners)

      // Result Variables
      const fluent_speakers = fluentSpeakerParse / 100
      const semi_speakers = semiSpeakerParse / 100
      const learners = learnerSpeakerParse / 100
      const others =
        (100 - (fluent_speakers * 100 + semi_speakers * 100 + learners * 100)) /
        100

      return {
        name: lna.language,
        labels: ['Fluent', 'Semi Fluent', 'Other'],
        datasets: [
          {
            label: 'Data One',
            backgroundColor: ['#2ecc71', '#3498db', '#efefef'],
            data: [fluent_speakers, semi_speakers, others],
            learnerData: [learners]
          }
        ]
      }
    },
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          zoomToPoint({ map, geom: this.community.point, zoom: 11 })
        }
        const icon = 'community_icon.svg'
        makeMarker(this.community.point, icon, this).addTo(map)
      })
    },
    handleCardClick($event, name, type) {
      if (type === 'lang') {
        return this.$router.push({
          path: `/languages/${encodeFPCC(name)}`
        })
      } else if (type === 'place') {
        return this.$router.push({
          path: `/place-names/${encodeFPCC(name)}`
        })
      } else if (type === 'placename') {
        this.$router.push({
          path: `/art/${encodeFPCC(name)}`
        })
      }
    },
    getHeaderTitle() {
      if (this.community) {
        return this.community.name + ' Language Speaker Details and Stats'
      } else {
        return 'Community page not found'
      }
    },
    getHeaderDescription() {
      if (this.community) {
        if (this.community.other_names) {
          return `${this.community.name}, also known as ${this.community.other_names}, is an indigenous community of British Columbia.`
        } else {
          return `${this.community.name} is an indigenous community of British Columbia.`
        }
      } else {
        return 'Community page not found.'
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

<style>
.other-lang-names-title {
  color: var(--color-gray, #6f6f70);
  font-size: 0.8em;
}
.lang-detail-table th {
  font-size: 0.6em;
  text-transform: uppercase;
  color: var(--color-gray, #6f6f70);
}
.lang-detail-table {
  width: 100%;
}

.lna-table {
  border: 1px solid #ebe6dc;
  margin-bottom: 0;
}
.lna-table-thead {
  font-size: 0.8em;
  color: var(--color-gray, #6f6f70);
}

.lna-table-thead th {
  font-weight: normal;
  vertical-align: middle !important;
  border: 0;
  border-bottom: 0 !important;
  padding-left: 0.5em;
  padding-right: 0.5em;
}

.lna-table-tbody {
  font-size: 0.8em;
}

.lna-table-tbody td {
  padding-left: 0.5em;
  padding-right: 0.5em;
  color: var(--color-gray, #6f6f70);
  vertical-align: middle;
}

.showHide {
  width: 49%;
  display: inline-block;
}

@media (max-width: 992px) {
  .badge-container {
    display: block !important;
  }
}
</style>
