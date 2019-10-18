<template>
  <div>
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        Community:
        <span class="font-weight-bold">{{ commDetails.name }}</span>
      </div>
      <div>
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
      <CommunityDetailCard
        :name="commDetails.name"
        :population="commDetails.population"
        :server="isServer"
        :audio-file="commDetails.audio_file"
      ></CommunityDetailCard>
      <hr class="sidebar-divider mt-0" />
      <Filters class="mb-3"></Filters>
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
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.email || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Website:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.website || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Phone #:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.phone || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Alternate Phone #:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.alt_phone || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Fax #:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.fax || 'N/A' }}
            </span>
          </li>
        </ul>
        <div class="mt-3">
          <b-table
            hover
            :items="lna"
            responsive
            small
            table-class="lna-table"
            thead-class="lna-table-thead"
            tbody-class="lna-table-tbody"
            @row-clicked="handleRowClick"
          ></b-table>
          <client-only>
            <div v-if="showCollapse" class="mb-3">
              <b-button
                block
                variant="light"
                class="font-08"
                @click="handleRowClick"
                >Hide Charts</b-button
              >
            </div>
            <div v-else class="mb-3">
              <b-button
                block
                variant="light"
                class="font-08"
                @click="handleRowClick"
                >Show Charts</b-button
              >
            </div>
            <div v-if="showCollapse">
              <div v-for="(l, index) in lna" :key="`chartlna${index}`">
                <PieChart
                  :chartdata="extractChartData(l)"
                  :options="options"
                ></PieChart>
              </div>
            </div>
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

        <b-row>
          <b-col
            v-for="language in commDetails.languages"
            :key="'language' + language.id"
            lg="12"
            xl="12"
            md="6"
            sm="6"
          >
            <LanguageCard
              v-if="mode !== 'place'"
              class="mt-3 hover-left-move"
              :name="language.name"
              :color="language.color"
              @click.native.prevent="
                handleCardClick($event, language.name, 'lang')
              "
            ></LanguageCard>
            <div
              v-if="
                commDetails.places &&
                  commDetails.places.length > 0 &&
                  mode !== 'lang'
              "
            >
              <PlacesCard
                v-for="(place, index) in filteredPlaces"
                :key="`placescomm${index}`"
                class="mt-3 hover-left-move"
                :name="place.name"
                :place="{ properties: place }"
                @click.native.prevent="
                  handleCardClick($event, place.name, 'place')
                "
              >
              </PlacesCard>
            </div>
          </b-col>
        </b-row>
      </section>
      <section>
        <div v-if="isLoggedIn">
          <hr />
          <UploadTool
            :id="community.id"
            class="m-1 ml-4 mr-4 mb-3"
            type="community"
          ></UploadTool>
          <div
            v-for="media in commDetails.medias"
            :key="'media' + media.id"
            class="mb-4"
          >
            <Media
              class="ml-4 mr-4"
              :media="media"
              :server="isServer"
              type="community"
            ></Media>
            <hr class="mb-2" />
          </div>
        </div>
      </section>
      <section>
        <Notification
          v-if="isLoggedIn"
          :id="community.id"
          :is-server="isServer"
          type="community"
          class="m-4"
          :unsubscribe="!!subscribed"
          :subscription="subscribed"
        ></Notification>
      </section>
    </div>
  </div>
</template>

<script>
import { values, omit } from 'lodash'
import Logo from '@/components/Logo.vue'
import CommunityDetailCard from '@/components/communities/CommunityDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import Badge from '@/components/Badge.vue'
import { getApiUrl, encodeFPCC, makeMarker } from '@/plugins/utils.js'
import PlacesCard from '@/components/places/PlacesCard.vue'
import UploadTool from '@/components/UploadTool.vue'
import Media from '@/components/Media.vue'
import Notification from '@/components/Notification.vue'
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
              console.log('Legend Item', legendItem)
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
              console.log('Data', data)
              console.log('tool', tooltipItems)
              return `${data.labels[tooltipItems.index]}: ${(
                data.datasets[0].data[tooltipItems.index] * 100
              ).toFixed(1) + '%'}`
            }
          }
        }
      },
      showCollapse: false
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
      return this.$store.state.places.filteredBadgePlaces
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
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
    commDetails() {
      const filteredCommDetails = omit(this.communityDetail)
      const details = filteredCommDetails
      return details
    },
    lna() {
      const lnas = values(this.commDetails.lna_by_language)
      return lnas.map(lna => {
        let fluent
        let someSpeakers
        let learners
        const pop = this.commDetails.population || lna.pop_total_value
        // get percentages.
        if (pop) {
          fluent = ((100 * lna.fluent_speakers) / pop).toFixed(1) + '%'
          someSpeakers = ((100 * lna.some_speakers) / pop).toFixed(1) + '%'
          learners = ((100 * lna.learners) / pop).toFixed(1) + '%'
        } else {
          learners = 0
          fluent = 0
          someSpeakers = 0
        }
        return {
          language: lna.lna.language,
          fluent_speakers: fluent,
          some_speakers: someSpeakers,
          learners
        }
      })
    },
    otherNames() {
      if (this.commDetails.other_names) {
        return this.commDetails.other_names.split(',')
      } else {
        return null
      }
    }
  },
  watch: {
    community(newComm, oldComm) {
      if (newComm !== oldComm) {
        this.setupMap()
      }
    }
  },
  async asyncData({ params, $axios, store, $route }) {
    const communities = await $axios.$get(
      getApiUrl(`community?timestamp=${new Date().getTime()}/`)
    )
    const community = communities.find(
      comm => encodeFPCC(comm.name) === params.fn
    )
    const communityDetail = await $axios.$get(
      getApiUrl(`community/${community.id}?timestamp=${new Date().getTime()}/`)
    )
    store.commit('places/setBadgePlaces', communityDetail.places)
    store.commit('places/setFilteredBadgePlaces', communityDetail.places)
    const isServer = !!process.server

    return {
      mode: 'All',
      communityDetail,
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
  },
  async fetch({ store }) {
    if (store.state.user.isLoggedIn) {
      await store.dispatch('user/getNotifications', {
        isServer: !!process.server
      })
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.setupMap()
  },
  mounted() {
    this.$root.$on('fileUploaded', r => {
      this.commDetails.medias.push(r)
    })
  },
  methods: {
    handleRowClick() {
      console.log('Handle Row Click')
      this.showCollapse = !this.showCollapse
    },
    extractChartData(l) {
      const fluent_speakers = parseFloat(l.fluent_speakers) / 100
      const some_speakers = parseFloat(l.some_speakers) / 100
      const learners = parseFloat(l.learners) / 100
      const others =
        (100 - (fluent_speakers * 100 + some_speakers * 100 + learners * 100)) /
        100
      console.log('Others', others)
      return {
        name: l.language,
        labels: ['Fluent', 'Some', 'Learner', 'Other'],
        datasets: [
          {
            label: 'Data One',
            backgroundColor: ['#2ecc71', '#3498db', '#95a5a6', '#efefef'],
            data: [fluent_speakers, some_speakers, learners, others]
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
        makeMarker(this.community.point, icon, 'place-marker').addTo(map)
      })
    },
    handleCardClick($event, name, type) {
      if (type === 'lang') {
        return this.$router.push({
          path: `/languages/${encodeFPCC(name)}`
        })
      }

      if (type === 'place') {
        return this.$router.push({
          path: `/place-names/${encodeFPCC(name)}`
        })
      }
    }
  },
  head() {
    return {
      title: this.community.name + ' Language Speaker Details and Stats',
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `${this.community.name}, also known as ${
            this.community.other_names
          } is an indigenous community of British Columbia.`
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

@media (max-width: 992px) {
  .badge-container {
    display: block !important;
  }
}
</style>
