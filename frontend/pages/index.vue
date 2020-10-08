<template>
  <div>
    <FullscreenLoading v-if="showFullscreenLoading"></FullscreenLoading>
    <LoadingModal></LoadingModal>

    <div
      id="map-container"
      class="map-container"
      :class="{
        detailModeContainer: isDetailMode,
        'arts-container': isDrawerShown
      }"
      ￼￼
    >
      <SideBar v-if="this.$route.name === 'index'" active="Languages">
        <template v-slot:content>
          <div v-html="ie"></div>
          <section class="pl-3 pr-3 mt-3">
            <Accordion
              class="no-scroll-accordion"
              :content="accordionContent"
            ></Accordion>
          </section>
          <section class="badge-section pl-3 pr-3 mt-3"></section>
          <hr class="sidebar-divider" />
          <Filters class="mb-2"></Filters>
        </template>
        <template v-slot:badges>
          <section class="pl-2 pr-3 mt-3">
            <Badge
              content="Languages"
              :number="languagesCount"
              class="cursor-pointer"
              type="language"
              :mode="getBadgeStatus(mode, 'lang')"
              @click.native.prevent="handleBadge($event, 'lang')"
            ></Badge>
            <Badge
              content="Communities"
              :number="communities.length"
              class="cursor-pointer"
              type="community"
              bgcolor="#6c4264"
              :mode="getBadgeStatus(mode, 'comm')"
              @click.native.prevent="handleBadge($event, 'comm')"
            ></Badge>
          </section>
        </template>
        <template v-slot:cards>
          <section v-if="mode !== 'comm'" class="language-section pl-3 pr-3">
            <div
              v-for="(familyLanguages, family) in languages"
              :key="'langfamily' + family"
              class="language-family-container"
            >
              <h5 class="language-family mt-0">
                <span class="language-family-header">Language Family:</span>
                <span class="language-family-title">{{
                  family === 'undefined' ? 'No Family' : family
                }}</span>
              </h5>
              <b-row>
                <b-col
                  v-for="language in familyLanguages"
                  :key="'language' + language.id"
                  lg="12"
                  xl="12"
                  md="6"
                  sm="6"
                >
                  <LanguageCard
                    class="mb-2 hover-left-move"
                    :name="language.name"
                    :color="
                      (language.family && language.family.color) ||
                        language.color
                    "
                    @click.native.prevent="
                      handleCardClick($event, language.name, 'lang')
                    "
                  ></LanguageCard>
                </b-col>
              </b-row>
            </div>
          </section>
          <section v-if="mode !== 'lang'" class="community-section pl-3 pr-3">
            <h5 class="language-family mt-2 ">Communities</h5>
            <b-row>
              <b-col
                v-for="community in paginatedCommunities"
                :key="'community ' + community.name"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <CommunityCard
                  class="mb-2 hover-left-move"
                  :name="community.name"
                  :community="community"
                  @click.native.prevent="
                    handleCardClick($event, community.name, 'comm')
                  "
                ></CommunityCard>
              </b-col>
            </b-row>
          </section>
        </template>
      </SideBar>
      <div
        v-else-if="routesToNotRenderChild()"
        class="sb-new-alt-one"
        :class="{
          'sb-detail': isDetailMode,
          'mobile-content-open': mobileContent,
          'hide-scroll-y': isGalleryShown
        }"
      >
        <nuxt-child class="route-child-container" />
      </div>
      <div v-else>
        <nuxt-child />
      </div>

      <div class="maps-panel">
        <div class="map-main-container">
          <LogInOverlay v-if="loggingIn"></LogInOverlay>
          <div v-if="isDrawMode" class="drawing-mode-container">
            <b-alert
              v-if="!isLoggedIn"
              show
              variant="danger"
              class="p-1 pr-2 pl-2 draw-mode-container"
            >
              <h4 class="alert-heading">Please Log In</h4>
              <p>
                This feature requires you to be
                <a :href="getLoginUrl()">logged in.</a>
              </p>
            </b-alert>
            <b-alert
              v-else-if="notAuthenticatedUser"
              show
              class="p-1 pr-2 pl-2 draw-mode-container"
              variant="danger"
            >
              <ul>
                <li>
                  You can't proceed, you need to select your default Language,
                  and Community
                </li>
                <li>
                  Please select your community or language by clicking
                  <router-link :to="`/profile/edit/${userDetail.id}`"
                    >here</router-link
                  >
                </li>
              </ul>
            </b-alert>
            <b-alert
              v-else-if="!notAuthenticatedUser"
              show
              class="p-1 pr-2 pl-2 draw-mode-container"
              variant="light"
            >
              <DrawingTools
                :draw-mode="$route.query.mode"
                class="mt-2"
              ></DrawingTools>
            </b-alert>
          </div>
          <div class="map-loading">
            Loading Map
            <b-spinner type="grow" label="Spinning"></b-spinner>
          </div>
          <Mapbox
            :access-token="MAPBOX_ACCESS_TOKEN"
            :map-options="MAP_OPTIONS"
            :nav-control="{ show: false }"
            @map-init="mapInit"
            @map-load="mapLoaded"
            @map-touchend="mapClicked"
            @map-click="mapClicked"
            @map-zoomend="mapZoomEnd"
            @map-moveend="mapMoveEnd"
            @map-sourcedata="mapSourceData"
          ></Mapbox>
          <div
            v-if="$route.path !== '/splashscreen'"
            class="map-controls-overlay"
          >
            <Zoom class="zoom-control hide-mobile mr-2"></Zoom>
            <ResetMap class="reset-map-control hide-mobile mr-2"></ResetMap>
            <CurrentLocation
              class="current-location-control hide-mobile mr-2"
            ></CurrentLocation>
            <ShareEmbed
              class="share-embed-control hide-mobile mr-2"
            ></ShareEmbed>
            <SaveLocation
              v-if="isLoggedIn"
              class="share-embed-control hide-mobile mr-2"
            ></SaveLocation>
            <Contribute class="contribute-control mr-2"></Contribute>
          </div>
          <ModalNotification></ModalNotification>
          <div v-if="!isDrawMode" class="map-navigation-container">
            <SearchBar
              :key="searchKey"
              :query="searchQuery"
              class="hide-mobile"
            ></SearchBar>
            <transition name="fade-topbar" mode="out-in">
              <SearchOverlay
                v-if="showSearchOverlay"
                :show="showSearchOverlay"
              ></SearchOverlay>

              <EventOverlay
                v-else-if="showEventOverlay"
                :show="showEventOverlay"
              ></EventOverlay>

              <div v-else class="top-bar-container">
                <NavigationBar></NavigationBar>
              </div>
            </transition>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Mapbox from 'mapbox-gl-vue'
import groupBy from 'lodash/groupBy'
import * as Cookies from 'js-cookie'
import '@mapbox/mapbox-gl-draw/dist/mapbox-gl-draw.css'
import * as MapboxDraw from '@mapbox/mapbox-gl-draw/dist/mapbox-gl-draw'
import DrawingTools from '@/components/DrawingTools.vue'
import SearchBar from '@/components/SearchBar.vue'
import NavigationBar from '@/components/NavigationBar.vue'
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import ShareEmbed from '@/components/ShareEmbed.vue'
import SaveLocation from '@/components/SaveLocation.vue'
import ResetMap from '@/components/ResetMap.vue'
import CurrentLocation from '@/components/CurrentLocation.vue'
import Contribute from '@/components/Contribute.vue'
import Zoom from '@/components/Zoom.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import { inBounds, zoomToIdealBox } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import layers from '@/plugins/layers.js'
import ModalNotification from '@/components/ModalNotification.vue'
import SearchOverlay from '@/components/SearchOverlay.vue'
import EventOverlay from '@/components/EventOverlay.vue'
import LogInOverlay from '@/components/LogInOverlay.vue'
import FullscreenLoading from '@/components/FullscreenLoading.vue'
import LoadingModal from '@/components/LoadingModal.vue'

import {
  getApiUrl,
  encodeFPCC,
  filterLanguages,
  getLanguagesFromDraw
} from '@/plugins/utils.js'
const renderArtDetail = props => {
  return `<div class='map-popup'>
            <hr>
            <p>
                <a href="/art/${encodeFPCC(props.name)}" class='art-popup'>${
    props.name
  }</a> |
                <span class='art-popup-type'>${props.kind}</span>
            </p>
        </div>`
}

const markers = {}
let markersOnScreen = {}

export default {
  components: {
    SearchOverlay,
    Mapbox,
    SearchBar,
    NavigationBar,
    SideBar,
    Accordion,
    Badge,
    LanguageCard,
    CommunityCard,
    ShareEmbed,
    SaveLocation,
    ResetMap,
    CurrentLocation,
    Zoom,
    Filters,
    Contribute,
    DrawingTools,
    ModalNotification,
    LogInOverlay,
    EventOverlay,
    FullscreenLoading,
    LoadingModal
  },
  head() {
    return {
      meta: [
        {
          name: 'google-site-verification',
          content: 'wWf4WAoDmF6R3jjEYapgr3-ymFwS6o-qfLob4WOErRA'
        }
      ]
    }
  },
  data() {
    const bbox = [
      [-143.921875, 45.800059446787316],
      [-107.9951171875, 63.568120480921074]
    ]
    const bounds = [bbox[0], bbox[1]]
    return {
      maximumLength: 0,
      searchQuery: '',
      searchKey: 'search',
      showFullscreenLoading: false,
      loggingIn: false,
      showSearchOverlay: false,
      showEventOverlay: false,
      MAPBOX_ACCESS_TOKEN:
        'pk.eyJ1IjoiY291bnRhYmxlLXdlYiIsImEiOiJjamQyZG90dzAxcmxmMndtdzBuY3Ywa2ViIn0.MU-sGTVDS9aGzgdJJ3EwHA',
      MAP_OPTIONS: {
        style:
          'mapbox://styles/countable-web/ck9osxbys0rr71io228y2zonf/draft?optimize=true',
        maxZoom: 19,
        minZoom: 3,
        bounds
        // center: [-125, 55],
        // zoom: 4
      },
      mode: 'All',
      map: {},
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 50% of the First Peoples’ languages of Canada are spoken in B.C. You can access indexes of all the languages, First Nations through the top navigation on all pages of this website.',
      ie: `
        <!--[if lt IE 7]> <div id="ie style="color: red; padding: 0.5rem 2rem;">Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->
        <!--[if IE 7]> <div id="ie style="color: red; padding: 0.5rem 2rem;">Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->
        <!--[if IE 8]> <div id="ie" style="color: red; padding: 0.5rem 2rem;>Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->
        <!--[if IE 9]> <div id="ie" style="color: red; padding: 0.5rem 2rem;">Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->`
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    userDetail() {
      return this.$store.state.user.user
    },
    notAuthenticatedUser() {
      return (
        this.isLoggedIn &&
        this.userDetail.languages &&
        this.userDetail.languages.length === 0 &&
        this.userDetail.communities &&
        this.userDetail.communities.length === 0
      )
    },
    isMobileCollapse() {
      return this.$store.state.responsive.isMobileSideBarOpen
    },
    isGalleryShown() {
      return this.$store.state.sidebar.showGallery
    },
    isMobile() {
      return this.$store.state.app.isMobile
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    },
    isUploadArtMode() {
      return !!this.$route.query.upload_artwork
    },
    drawMode() {
      return this.$store.state.contribute.drawMode
    },
    communities() {
      return this.$store.state.communities.communities
    },
    languages() {
      return this.$store.state.languages.languages || []
    },
    paginatedCommunities() {
      return this.communities.slice(0, this.maximumLength)
    },
    languagesCount() {
      return this.$store.state.languages.languagesCount
    },
    isDetailMode() {
      return this.$store.state.sidebar.isDetailMode
    },
    languageSet() {
      return this.$store.state.languages.languageSet
    },
    communitySet() {
      return this.$store.state.communities.communitySet
    },
    artsSet() {
      return this.$store.state.arts.artsSet
    },
    artsGeoSet() {
      return this.$store.state.arts.artsGeoSet
    },
    artworkSet() {
      return this.$store.state.arts.artworkSet
    },
    placesSet() {
      return this.$store.state.places.placesSet
    },
    isDrawMode() {
      return this.$store.state.contribute.isDrawMode
    },
    catToFilter() {
      return this.$store.state.places.filterCategories
    },
    layers() {
      return this.$store.state.layers.layers
    }
  },
  async asyncData({ params, $axios, store, hash }) {
    const user = await $axios.$get(
      `${getApiUrl('user/auth/?timestamp=${new Date().getTime()')}}`
    )
    if (user.is_authenticated) {
      store.commit('user/setUser', user.user)
      store.commit('user/setPicture', user.user.picture)
      store.commit('user/setLoggedIn', true)
    }
    return { user }
  },
  async fetch({ $axios, store }) {
    // Only fetch search data
    const results = await Promise.all([
      $axios.$get(getApiUrl('language-search')),
      $axios.$get(getApiUrl('community-search')),
      $axios.$get(getApiUrl('placename-search')),
      $axios.$get(getApiUrl('art-search')),
      $axios.$get(getApiUrl('art-geo')),
      $axios.$get(getApiUrl('taxonomy')),
      $axios.$get(getApiUrl('arts/event'))
    ])

    store.commit('languages/setSearchStore', results[0])
    store.commit('communities/setSearchStore', results[1])
    store.commit('places/setSearchStore', results[2])
    store.commit('arts/setSearchStore', results[3])

    // Set Art Geo Set - for visible Arts count
    store.commit('arts/setGeo', results[4].features)
    store.commit('arts/setGeoStore', results[4])

    const taxonomies = [
      ...results[5],
      ...Array.from(['image', 'video', 'audio']).map(type => {
        return {
          id: type,
          name: type
        }
      })
    ]
    store.commit(
      'arts/setTaxonomySearchSet',
      taxonomies.map(tax => {
        tax.isChecked = false
        return tax
      })
    )

    const currentLanguages = store.state.languages.languageSet

    if (currentLanguages.length === 0) {
      // Fetch languages and communites data
      const languages = await $axios.$get(getApiUrl('language'))
      const communities = await $axios.$get(getApiUrl('community'))

      // Set language stores
      store.commit('languages/set', groupBy(languages, 'family.name')) // All data
      store.commit('languages/setStore', languages) // Updating data based on map

      // Set community stores
      store.commit('communities/set', communities) // All data
      store.commit('communities/setStore', communities) // Updating data based on map
    }
  },
  beforeRouteUpdate(to, from, next) {
    // This is how we know when to restore state of the map. We save previous state (lat,lng,zoom) and now state in Vuex.
    // On page landing, there isn't a previous state, only a now state. So we go back to the default map state.
    // On subsequent route changes, we move now state into previous state, allowing us to go back if return/back button is clicked
    // If force reset is true, (by clicking the logo or home in navigation bar), we don't care about state. We want to reset the map
    // so we have a if statement that checks that.
    const map = this.$store.state.mapinstance.mapInstance
    const mapState = this.$store.state.mapinstance.mapState
    const forceReset = this.$store.state.mapinstance.forceReset
    if (
      to.name === 'index' ||
      (to.name === 'index-languages' && from.name === 'index-languages-lang') ||
      (to.name === 'index-art' && from.name === 'index-art-art') ||
      (to.name === 'index-heritages' &&
        from.name === 'index-place-names-placename') ||
      to.name === 'index-place-names' ||
      to.name === 'index-first-nations'
    ) {
      let lat, lng, zoom
      if (!forceReset) {
        if (mapState.previous === null) {
          lat = 55
          lng = -121
          zoom = 4
        } else {
          lat = mapState.previous.lat || mapState.now.lat
          lng = mapState.previous.lng || mapState.now.lng
          zoom = mapState.previous.zoom || mapState.now.zoom
        }
      } else {
        lat = 55
        lng = -121
        zoom = 4
        this.$store.commit('mapinstance/setForceReset', false)
      }
      map.flyTo({
        center: [lng, lat],
        zoom,
        speed: 3
      })
    }
    next()
  },
  created() {
    this.showFullscreenLoading = true
  },
  async mounted() {
    this.$root.$on('updateData', () => {
      this.$eventHub.whenMap(map => {
        this.updateData(map)
      })
    })

    setTimeout(() => {
      if (this.user) {
        this.showFullscreenLoading = false
        if (this.$route.query.search) {
          this.searchQuery = this.$route.query.search
          this.searchKey += this.searchQuery
        }
      }
    }, 2000)

    // Showing the Notification on Media success
    this.$root.$on('fileUploaded', data => {
      // this.modalShow = false
      this.$root.$emit('notification', {
        title: 'Success',
        message: 'Media Successfully uploaded',
        time: 2000,
        variant: 'success'
      })

      this.$root.$emit('closeUploadModal')

      if (this.isUploadArtMode) {
        this.$root.$emit('fileUploadSuccess')
      } else if (this.$route.name === 'index-place-names-placename') {
        this.$root.$emit('fileUploadedPlaces', data)
      } else if (this.$route.name === 'index-content-fn') {
        this.$root.$emit('fileUploadedCommunity', data)
      }
    })

    // Showing of Notification on Media failure
    this.$root.$on('fileUploadFailed', type => {
      this.$root.$emit('notification', {
        title: 'Failed',
        message: `${type} Upload Failed, please try again`,
        time: 2000,
        variant: 'danger'
      })
      this.$root.$emit('closeUploadModal')
      if (this.isUploadArtMode) {
        this.$root.$emit('fileUploadSuccess')
      }
    })

    // Decides to show the splashscreen, if values exist, then its no longer first time visit
    if (localStorage.getItem('fpcc-splashscreen') === null) {
      // Redirect to /languages
      if (this.$route.path === '/') {
        this.$router.push({
          path: '/splashscreen'
        })
      }
    } else if (localStorage.getItem('fpcc-splashscreen') === 'false') {
    }

    // Closes the splashscreen, and add the value to the localStorage, for remembering its not the first visit
    this.$root.$on('closeSplashscreen', () => {
      localStorage.setItem('fpcc-splashscreen', false)
    })

    this.setMobile(window.innerWidth)

    window.addEventListener('resize', () => {
      this.setMobile(window.innerWidth)
    })
    this.$root.$on('updatePlacesCategory', d => {
      this.$eventHub.whenMap(map => {
        if (this.catToFilter.length === 0) {
          this.$store.commit('places/set', this.filterPlaces(map.getBounds()))
        } else {
          this.$store.commit(
            'places/set',
            this.filterPlaces(map.getBounds()).filter(p => {
              return this.catToFilter.find(s => s === p.properties.category)
            })
          )
        }
      })
    })
    this.$root.$on('showSearchOverlay', d => {
      this.showSearchOverlay = true
    })
    this.$root.$on('closeSearchOverlay', d => {
      this.showSearchOverlay = false
    })
    this.$root.$on('toggleEventOverlay', d => {
      this.showEventOverlay = d
    })
    // consume a JWT and authenticate locally.
    if (this.$route.hash.includes('id_token')) {
      this.loggingIn = true
      try {
        const token = this.$route.hash.replace('#', '')
        const user = await this.$axios.$get(
          `${getApiUrl('user/login/')}?${token}`
        )
        if (user.success) {
          this.$store.dispatch('user/setLoggedInUser')
          this.$store.commit('user/setLoggedIn', true)
          if (user.new === true) {
            this.$router.push({
              path: `/profile/edit/${user.id}`
            })
          } else {
            this.$router.push({
              path: '/'
            })
          }
        }
      } catch (e) {
        this.loggingIn = false
      }
      this.loggingIn = false
    }
    // initial zoom on index page
    if (this.$route.path === '/' && !this.$route.hash) {
      this.$eventHub.whenMap(map => {
        zoomToIdealBox({ map })
      })
    }

    if (this.$route.name === 'index') {
      const mobileContainer = document.querySelector('#side-inner-collapse')
      const desktopContainer = document.querySelector('#sidebar-container')

      const containerArray = [mobileContainer, desktopContainer]

      containerArray.forEach(elem => {
        elem.addEventListener('scroll', e => {
          if (
            elem.scrollTop + elem.clientHeight >= elem.scrollHeight &&
            elem.scrollTop !== 0
          ) {
            if (this.communities.length > this.maximumLength) {
              this.loadMoreData()
            }
          }
        })
      })
      this.loadMoreData()
    }

    // Redirect to claim page if during invite mode
    if (Cookies.get('inviteMode')) {
      const email = Cookies.get('inviteEmail')
      const key = Cookies.get('inviteKey')
      this.$router.push({
        path: `/claim?email=${email}&key=${key}`
      })
    }
  },
  methods: {
    getLoginUrl() {
      return `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    },
    closePopover() {
      this.$root.$emit('closeEventPopover')
    },
    loadMoreData() {
      this.$store.commit('sidebar/toggleLoading', true)
      setTimeout(() => {
        this.maximumLength += 10
        this.$store.commit('sidebar/toggleLoading', false)
      }, 250)
    },
    setMobile(screenSizeOnLand) {
      if (screenSizeOnLand <= 992 && this.isMobile === false) {
        this.$store.commit('app/setMobile', true)
      } else if (screenSizeOnLand > 992 && this.isMobile === true) {
        this.$store.commit('app/setMobile', false)
      }
    },
    routesToNotRenderChild() {
      return !(
        this.$route.name === 'index-languages' ||
        this.$route.name === 'index-heritages' ||
        this.$route.name === 'index-art' ||
        this.$route.name === 'index-grants'
      )
    },
    handleCardClick($event, name, type) {
      switch (type) {
        case 'lang':
          this.$router.push({
            path: `/languages/${encodeFPCC(name)}`
          })
          break
        case 'comm':
          this.$router.push({
            path: `/content/${encodeFPCC(name)}`
          })
          break
      }
    },
    isMainPage() {
      return (
        this.$route.name === 'index' ||
        this.$route.name === 'index-languages' ||
        this.$route.name === 'index-art' ||
        this.$route.name === 'index-heritages' ||
        this.$route.name === 'index-place-names' ||
        this.$route.name === 'index-first-nations'
      )
    },

    artsClusterImage(props, coords, map) {
      const html = `<svg class="markerCluster" xmlns="http://www.w3.org/2000/svg" width="54" height="53" viewBox="0 0 54 53"><defs><style>.a{fill:#fff;}.b{fill:#515350;}.c{fill:#b45339;}</style></defs><g transform="translate(-470 -452)"><circle class="a" cx="22.5" cy="22.5" r="22.5" transform="translate(470 460)"/><circle class="b" cx="20.5" cy="20.5" r="20.5" transform="translate(472 462)"/><circle class="a" cx="13.5" cy="13.5" r="13.5" transform="translate(497 452)"/><path class="c" d="M6989.312,282a11.31,11.31,0,1,0,11.309,11.31A11.311,11.311,0,0,0,6989.312,282Zm-8.654,6.817a.362.362,0,0,1,.5-.479,4.74,4.74,0,0,0,5-.428,4.148,4.148,0,0,1,6.021,1.149.468.468,0,0,1-.594.67,4.9,4.9,0,0,0-5.02.219C6984.084,291.716,6981.76,291.029,6980.657,288.817Zm14,4.09c-1.689-.242-4.229-.243-4.229,1.932v.828a.4.4,0,0,1-.4.395h-.636a.394.394,0,0,1-.395-.395v-.828c0-2.126-2.6-2.173-4.409-1.948a.174.174,0,0,1-.077-.337,15.241,15.241,0,0,1,10.233.019A.174.174,0,0,1,6994.661,292.907Zm-.027,2.136h-2.9a.245.245,0,0,1-.188-.4c.56-.668,1.848-1.766,3.279,0A.247.247,0,0,1,6994.633,295.042Zm-7.119,0h-2.929a.24.24,0,0,1-.185-.392c.557-.668,1.856-1.792,3.3,0A.24.24,0,0,1,6987.514,295.042Zm.677,3.261a1.426,1.426,0,1,1,1.426,1.427A1.425,1.425,0,0,1,6988.191,298.3Zm1.875,3.035a.181.181,0,0,1-.032-.359,6.421,6.421,0,0,0,4.893-3.81.181.181,0,0,1,.349.087C6995.026,299.007,6993.994,301.539,6990.066,301.338Zm8.381-10.352c-2.423,1.035-4.361-.6-5.569-2.669a5.777,5.777,0,0,0-2.654-2.289.349.349,0,0,1,.162-.667c1.855.111,3.091.948,4.326,2.955a4.26,4.26,0,0,0,3.611,1.947A.375.375,0,0,1,6998.447,290.986Z" transform="translate(-6478.949 172.052)"/></g><text x="42%" y="65%" text-anchor="middle" fill="white" font-size="0.9em" font-weight="Bold">${props.point_count}</text></svg>`
      const el = document.createElement('div')
      el.innerHTML = html
      el.firstChild.addEventListener('click', function(e) {
        e.preventDefault()
        e.stopPropagation()
        map.flyTo({
          center: [coords[0], coords[1]],
          zoom: map.getZoom() + 1,
          speed: 3,
          curve: 1
        })
        return false
      })
      return el.firstChild
    },
    // deprecated, not called currently
    updateMarkers(map) {
      let newMarkers = {}
      const mapboxgl = require('mapbox-gl')
      const features = map.querySourceFeatures('arts1')
      // for every cluster on the screen, create an HTML marker for it (if we didn't yet),
      // and add it to the map if it's not there already
      // console.log('zoom', map.getZoom(), this.$route.name)
      if (
        map.getZoom() > 6 ||
        this.$route.name === 'index-languages-lang' ||
        this.$route.name === 'index-languages-lang-details'
      ) {
        for (let i = 0; i < features.length; i++) {
          const coords = features[i].geometry.coordinates
          const props = features[i].properties

          if (!props.cluster) continue
          const id = props.cluster_id

          let marker = markers[id]
          if (!marker) {
            const el = this.artsClusterImage(props, coords, map)
            marker = markers[id] = new mapboxgl.Marker({
              element: el
            }).setLngLat(coords)
          }
          newMarkers[id] = marker

          if (!markersOnScreen[id]) marker.addTo(map)
        }
      } else {
        newMarkers = {}
      }

      // for every marker we've added previously, remove those that are no longer visible
      for (const id in markersOnScreen) {
        if (!newMarkers[id]) markersOnScreen[id].remove()
      }
      markersOnScreen = newMarkers
    },
    goToLang() {
      this.$router.push({
        path: `/languages`
      })
    },
    goToCommunity() {
      this.$router.push({
        path: `/first-nations`
      })
    },
    mapInit(map, e) {
      this.map = map
      this.$store.commit('mapinstance/set', map)
    },
    /**
     * Handle clicks centrally so we can control precedence.
     */
    mapClicked(map, e) {
      if (this.isDrawMode) {
        return
      }

      // if drawer is open, close it upon click
      if (this.isDrawerShown) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }

      const features = map.queryRenderedFeatures(e.point)

      let done = false
      features.forEach(feature => {
        if (feature && feature.properties && feature.properties.name) {
          if (feature.layer.id === 'fn-arts') {
            done = true
            return this.$router.push({
              path: `/art/${encodeFPCC(feature.properties.name)}`
            })
          } else if (feature.layer.id === 'fn-nations') {
            done = true
            this.$router.push({
              path: `/content/${encodeFPCC(feature.properties.name)}`
            })
          } else if (feature.layer.id === 'fn-places') {
            done = true
            this.$router.push({
              path: `/place-names/${encodeFPCC(feature.properties.name)}`
            })
          }
        }
        if (feature.layer.id === 'fn-arts-clusters') {
          // console.log(feature)
          const zoom = map.getZoom()
          if (zoom < 13) {
            const lat = feature.geometry.coordinates[1]
            const lng = feature.geometry.coordinates[0]
            map.flyTo({
              center: [lng, lat],
              zoom: zoom + 2,
              speed: 3,
              curve: 1
            })
          } else {
            this.showClusterModal(feature, e.lngLat, map)
          }
          done = true
        }
      })
      if (!done && !this.isMobile)
        features.forEach(feature => {
          // console.log('Feature', feature)
          if (feature.layer.id === 'fn-lang-areas-fill') {
            this.$router.push({
              path: `/languages/${encodeFPCC(feature.properties.name)}`
            })
          }
        })
    },

    showClusterModal(feature, latLng, map) {
      const clusterId = feature.properties.cluster_id
      map
        .getSource('arts1')
        .getClusterLeaves(
          clusterId,
          feature.properties.point_count,
          0,
          function(err, aFeatures) {
            if (err) {
              console.log('Error', err)
            }
            const html = aFeatures.reduce(function(ach, feature) {
              const props = feature.properties
              return ach + renderArtDetail(props)
            }, '')
            const mapboxgl = require('mapbox-gl')
            new mapboxgl.Popup({
              className: 'artPopUp'
            })
              .setLngLat(latLng)
              .setHTML(
                `<div class='popup-inner'>
                    <h4>Art Here:</h4>

                    ${html}
                    <!-- TODO scroll indicator -->
                    <div class="scroll-indicator">
                        <i class="fas fa-angle-down float"></i>
                    </div>

                    </div>`
              )
              .addTo(map)
          }
        )
    },

    mapLoaded(map) {
      this.$root.$on('resetMap', () => {
        zoomToIdealBox({ map })
      })

      this.$root.$on('getLocation', () => {
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(
            onZoomLocationSuccess,
            onGetLocationError,
            locationFetchOptions
          )
        } else {
          alert('Sorry, your browser does not support geolocation!')
        }
      })

      map.addSource('langs1', {
        type: 'geojson',
        data: '/api/language-geo/'
      })
      map.addSource('communities1', {
        type: 'geojson',
        data: '/api/community-geo/'
      })
      map.addSource('arts1', {
        type: 'geojson',
        data: this.artsGeoSet,
        cluster: true,
        // clusterMaxZoom: 14,
        clusterRadius: 50
      })
      map.addSource('places1', {
        type: 'geojson',
        data: '/api/placename-geo/'
      })
      layers.layers(map, this)
      this.zoomToHash(map)
      // Idle event not supported/working by mapbox-gl-vue natively, so we're doing it here.
      map.on('idle', e => {
        this.updateHash(map)
      })

      map.setLayoutProperty('fn-reserve-outlines', 'visibility', 'none')
      map.setLayoutProperty('fn-reserve-areas', 'visibility', 'none')
      MapboxDraw.modes.draw_polygon = require('mapbox-gl-draw-freehand-mode').default
      const draw = new MapboxDraw({
        displayControlsDefault: false,
        controls: {
          polygon: true,
          point: true,
          trash: true,
          line_string: true
        }
      })
      map.addControl(draw, 'bottom-left')

      const locationFetchOptions = {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      }

      // Functions triggered after getCurrentPosition
      const onGetLocationSuccess = position => {
        // We want to define our own FeatureCollection with only one point -- the current location
        const geojson = {
          name: 'CurrentLocationFeature',
          type: 'FeatureCollection',
          features: [
            {
              type: 'Feature',
              id: 'current-location-id',
              geometry: {
                type: 'Point',
                // coordinates: [-143.798273768994, 58.829496604496455]
                coordinates: [
                  position.coords.longitude,
                  position.coords.latitude
                ]
              },
              properties: {}
            }
          ]
        }
        draw.set(geojson)

        // Redirect to current location in map
        map.flyTo({ center: geojson.features[0].geometry.coordinates })

        // We update state data for storage later on and for detecting which
        // languages the user can select when updating the point's info
        const featureCollection = draw.getAll()
        const features = featureCollection.features

        this.$store.commit('contribute/setDrawnFeatures', features)
        this.$store.commit(
          'contribute/setLanguagesInFeature',
          getLanguagesFromDraw(features, this.languageSet)
        )

        // We trigger this function in order to select the newly created
        // point by default - this would make it easier to delete the point
        draw.changeMode('simple_select', {
          featureIds: ['current-location-id']
        })
      }
      function onGetLocationError(error) {
        if (error.code === 1) {
          alert('Error: Location access denied!')
        } else if (error.code === 2) {
          alert('Error: Cannot get current location.')
        }
      }

      // Zoom to my location
      const onZoomLocationSuccess = position => {
        map.flyTo({
          center: [position.coords.longitude, position.coords.latitude],
          zoom: 10,
          speed: 3,
          curve: 1
        })
      }

      let drawInit = false
      const self = this
      map.on('draw.render', e => {
        if (!drawInit) {
          drawInit = true

          if (this.drawMode === 'point') {
            draw.changeMode('draw_point')
          }

          if (this.drawMode === 'polygon') {
            draw.changeMode('draw_polygon')
          }

          if (this.drawMode === 'line_string') {
            draw.changeMode('draw_line_string')
          }

          self.$root.$on('mode_change_draw', data => {
            if (data === 'point') {
              draw.changeMode('draw_point')
            }
            if (data === 'polygon') {
              draw.changeMode('draw_polygon')
            }

            if (data === 'trash') {
              draw.trash()
            }

            if (data === 'line_string') {
              draw.changeMode('draw_line_string')
            }

            if (data === 'location') {
              if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                  onGetLocationSuccess,
                  onGetLocationError,
                  locationFetchOptions
                )
              } else {
                alert('Sorry, your browser does not support geolocation!')
              }
            }
          })
        }
      })

      map.on('draw.create', e => {
        const featuresDrawn = draw.getAll()
        let features = featuresDrawn.features
        // console.log('Feature', features)
        this.$store.commit('contribute/setDrawnFeatures', features)

        if (features.length > 1) {
          const featuresDrawn = draw.getAll()
          featuresDrawn.features = [featuresDrawn.features[1]]
          draw.set(featuresDrawn)
          features = featuresDrawn.features
        }

        this.$store.commit('contribute/setDrawnFeatures', features)
        this.$store.commit(
          'contribute/setLanguagesInFeature',
          getLanguagesFromDraw(features, this.languageSet)
        )
      })

      map.on('draw.delete', e => {
        const featuresDrawn = draw.getAll()
        const features = featuresDrawn.features
        this.$store.commit('contribute/setDrawnFeatures', features)

        if (features.length === 1 || features.length === 0) {
          this.$store.commit(
            'contribute/setLanguagesInFeature',
            getLanguagesFromDraw(features, this.languageSet)
          )
        }
      })

      map.draw = draw

      this.$eventHub.$emit('map-loaded', map)
    },
    zoomToHash(map) {
      const hash = this.$route.hash
      if (hash && !hash.includes('id_token')) {
        try {
          const split = hash.split('/')
          const lat = split[0].substr(1)
          const lng = split[1]
          const zoom = split[2]

          map.flyTo({
            center: [lng, lat],
            zoom,
            speed: 3,
            curve: 1
          })
        } catch (e) {}
      }
    },
    updateHash(map) {
      const center = map.getCenter()
      const zoom = map.getZoom()
      this.$store.commit('mapinstance/setView', {
        lat: center.lat,
        lng: center.lng,
        zoom
      })
    },
    updateData(map) {
      const sleepingLayer = this.layers.find(
        n => n.name === 'Sleeping Languages'
      ).active

      const bounds = map.getBounds()
      this.$store.commit(
        'languages/set',
        filterLanguages(
          this.languageSet,
          bounds,
          'default',
          null,
          this,
          sleepingLayer
        )
      )
      // console.log('This lanuages', this.languages)
      this.$store.commit('communities/set', this.filterCommunities(bounds))
      this.$store.commit('arts/setGeo', this.filterArtsGeo(bounds))
      this.$store.commit('arts/set', this.filterArts(bounds))
      this.$store.commit('arts/setArtworks', this.filterArtworks(bounds))

      if (this.catToFilter.length === 0) {
        this.$store.commit('places/set', this.filterPlaces(bounds))
      } else {
        this.$store.commit(
          'places/set',
          this.filterPlaces(bounds).filter(p => {
            return this.catToFilter.find(s => s === p.properties.category)
          })
        )
      }
    },
    updateMapState(map) {
      if (this.isMainPage()) {
        const center = map.getCenter()
        const zoom = map.getZoom()
        this.$store.commit('mapinstance/setMapState', {
          lat: center.lat,
          lng: center.lng,
          zoom
        })
      }
    },
    mapZoomEnd(map, e) {
      // this.updateMarkers(map)
    },
    mapMoveEnd(map, e) {
      // this.updateMarkers(map)
      this.updateData(map)
      this.updateMapState(map)
    },
    mapSourceData(map, source) {
      if (source.sourceId === 'arts1') {
        // this.updateMarkers(map)
      }
    },

    toggleMapLayers(map) {
      // enumerate ids of the layers
      const toggleableLayerIds = ['fn-nations', 'fn-arts', 'fn-places']

      toggleableLayerIds.forEach(layer => {
        const visibility = map.getLayoutProperty(layer, 'visibility')

        console.log('VISIB VALUE', layer, ' ', visibility)

        // toggle layer visibility by changing the layout object's visibility property
        if (visibility === 'visible') {
          map.setLayoutProperty(layer, 'visibility', 'none')
          this.className = ''
        } else {
          this.className = 'active'
          map.setLayoutProperty(layer, 'visibility', 'visible')
        }
      })
    },

    filterCommunities(bounds) {
      return this.communitySet.filter(comm => {
        if (comm.point !== null) {
          const point = comm.point.coordinates
          return inBounds(bounds, point)
        }
      })
    },
    filterArts(bounds) {
      return this.artsSet.filter(art => {
        const point = art.geometry.coordinates
        return inBounds(bounds, point)
      })
    },
    filterArtworks(bounds) {
      return this.artworkSet.filter(artwork => {
        const point = artwork.geometry.coordinates
        return inBounds(bounds, point)
      })
    },
    filterArtsGeo(bounds) {
      return this.artsGeoSet.features.filter(art => {
        const point = art.geometry.coordinates
        return inBounds(bounds, point)
      })
    },
    filterPlaces(bounds) {
      return this.placesSet.filter(place => {
        if (place.properties.status === 'FL') {
          return false
        }
        if (place.geometry !== null) {
          if (place.geometry.type === 'Point') {
            const point = place.geometry.coordinates
            return inBounds(bounds, point)
          }

          if (place.geometry.type === 'Polygon') {
            let isInBounds = false
            place.geometry.coordinates.map(points => {
              points.map(point => {
                if (inBounds(bounds, point)) {
                  isInBounds = true
                  return true
                }
              })
            })
            return isInBounds
          }

          if (place.geometry.type === 'LineString') {
            let isInBounds = false
            place.geometry.coordinates.map(point => {
              if (inBounds(bounds, point)) {
                isInBounds = true
                return true
              }
            })
            return isInBounds
          }
        }
      })
    }
  }
}
</script>

<style lang="scss">
@font-face {
  font-family: 'Proxima Nova';
  src: url('~@/static/fonts/Proxima/ProximaNova-Regular.otf');
  font-style: normal;
}

.map-container {
  width: 100%;
  height: 100%;
  position: relative;
  padding-left: var(--sidebar-width, 425px);
}

.arts-container {
  padding-left: var(--sidebar-width, 850px);
}

.maps-panel {
  display: flex;
}

.map-main-container {
  position: relative;
  height: 100vh;
  width: 100%;
}

#map {
  width: 100%;
  height: 100%;
}

.map-loading {
  position: absolute;
  left: 50%;
  top: 50%;
  color: #666;
  font-size: 25px;
}

.drawing-mode-container {
  position: absolute;
  top: 20px;
  left: 0;
  background-color: transparent;
  display: flex;
  justify-content: center;
  width: 100%;
  z-index: 50;
}

.draw-mode-container {
  border: 1px solid rgba(0, 0, 0, 0.2);
  padding: 0.75em !important;
  margin: auto auto;
  color: #151515;
  width: fit-content;
  max-width: 80%;
}

.map-navigation-container {
  width: 100%;
  display: flex;
  position: absolute;
  top: 0;
  justify-content: flex-end;
  padding-top: 17.5px;
  padding-left: 4.5em;
  padding-right: 5px;
}

/* When drawer is open */
.arts-container .map-navigation-container {
  padding: 5px !important;
  padding-top: 17.5px !important;
}

.map-controls-overlay {
  position: absolute;
  bottom: 20px;
  right: 10px;
  display: flex;
  color: #151515;
  flex-wrap: wrap;
  align-items: center;
  justify-content: flex-end;
  width: 80%;
}

.map-controls-overlay > * {
  margin-bottom: 0.4em;
  box-shadow: 0px 3px 6px #00000022;
}
.sidebar-divider {
  margin-bottom: 0.5rem;
}
.detailModeContainer {
  padding-left: 500px !important;
}
.markerCluster {
  opacity: 0.5;
}

.language-family-container {
  padding: 0.5em 0;
  border-radius: 0.5em;
}
.language-family {
  color: var(--color-darkgray, #454545);
  font-size: 0.8em;
}

.language-family-header {
  font: Regular 15px/18px Proxima Nova;
  letter-spacing: 0px;
  color: #151515;
  opacity: 0.5;
}
.language-family-title {
  font: Bold 15px/18px Proxima Nova;
  letter-spacing: 0px;
  color: #151515;
  opacity: 0.7;
}

.no-scroll-accordion #inner-collapse {
  overflow: hidden;
}

.artPopUp {
  border-radius: 0.5em;
}

.popup-inner {
  max-height: 300px;
  overflow-y: auto;
  padding: 1em;
  overflow-x: hidden;
}
.artPopUp .mapboxgl-popup-content {
  padding: 0em 0em 0em 0em;
}
.artPopUp .mapboxgl-popup-close-button {
  background-color: white;
}

.mapbox-gl-draw_ctrl-draw-btn {
  display: none !important;
}

.sb-new-alt-one {
  position: fixed;
  top: 0;
  left: 0;
  width: 425px;
  background-color: white;
  z-index: 900;
  height: 100%;
  overflow-y: auto;
}

.route-child-container {
  width: 100%;
}

.sb-detail {
  width: 500px;
}

.content-mobile > div {
  cursor: pointer;
}

.content-mobile-title > div {
  cursor: pointer;
}

@media (min-width: 993px) and (max-width: 1300px) {
  .arts-container {
    padding-left: var(--sidebar-width, 700px);
  }
  .arts-container .sb-new-alt-one {
    width: 350px;
  }
}

@media (max-width: 992px) {
  .arts-container {
    padding-left: 0;
  }
  .drawing-mode-container {
    padding-left: 0;
  }
  .content-mobile-title {
    display: flex !important;
  }

  .sb-new-alt-one {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    top: unset;
    height: 65px;
    width: 100%;
    display: flex;
    align-items: center;
  }
  .map-loading {
    margin-left: -90px;
  }

  .map-container {
    padding-left: 0;
  }

  .mobile-logo {
    display: block !important;
  }

  .top-bar-container {
    position: absolute;
    top: 0px;
    left: 0;
    padding: 0.2em;
    width: 100%;
    /* z-index: 100; */
    background-color: white;
    height: 50px;
  }

  .popover {
    max-height: 300px;
    max-width: 100%;
    width: 96%;
  }

  .detailModeContainer {
    padding-left: 0px !important;
  }

  .content-mobile.mobile-close {
    display: block !important;
    padding: 0.5em;
  }
}

.fade-topbar-enter-active,
.fade-topbar-leave-active {
  transition: opacity 0.15s;
}
.fade-topbar-enter, .fade-topbar-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

.mobile-content-open {
  height: 100%;
  bottom: 0;
  align-items: baseline;
}

.content-mobile {
  display: block !important;
}
.mobile-close {
  display: none !important;
}
.sb-new-alt-one {
  overflow-x: hidden;
}

@media (max-width: 574px) {
  .drawing-mode-container > div {
    width: 75%;
    font-size: 0.8em;
  }
}

/* Global CSS */
.field-kinds {
  font: Bold 13px/15px Proxima Nova;
  color: #707070;
  opacity: 1;
  text-transform: uppercase;
  margin: 0.1em;
  padding: 0;
}

.field-names {
  font-family: 'Proxima Nova', sans-serif;
  font-size: 17px;
  font-weight: 600;
  color: #151515;
  margin: 0.1em;
  padding: 0;
  word-break: break-all;
}

.content-collapse {
  position: relative;
  justify-content: space-between;
  align-items: center;
  padding: 0 0.75em;
  margin: 0 0.75em;
}

.content-collapse-btn {
  position: fixed;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #fff;
  left: 50%;
  bottom: 75px;
  z-index: 9999999999;
  border: 2.5px solid #b57936;
  animation: hover 2.5s infinite;
}

/* Arts Drawer */
.sidebar-side-panel {
  position: fixed;
  top: 0;
  left: 425px;
  width: 425px;
  height: 100vh;
  overflow-x: hidden;
  z-index: 999999;
}

@media (max-width: 992px) {
  .sidebar-side-panel {
    display: block !important;
    position: initial;
    width: 100%;
    height: 100vh;
    left: 0;
    overflow-x: hidden;
    overflow-y: hidden;
    z-index: 999999;
  }
}

/* Sidebar style when screen width is 1300px and drawer is open */
@media (min-width: 993px) and (max-width: 1300px) {
  .arts-container .sidebar-container {
    width: 350px;
  }
  .arts-container .sidebar-side-panel {
    width: 350px;
    left: 350px;
  }
}

/* Main Arts Drawer */

.panel-collapsable {
  width: 15px;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 425px;
  background: #f9f9f9 0% 0% no-repeat padding-box;
  box-shadow: 0px 3px 6px #00000029;
  border: 1px solid #d7d7de;
}

.btn-collapse {
  padding: 1em;
  margin-top: 1.5em;
  margin-left: 0.8em;
  width: 100px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-top-right-radius: 1em;
  border-bottom-right-radius: 1em;
  color: #fff;
  background-color: #b47a2b;
}

.btn-collapse img {
  margin-right: 0.5em;
}

/* Artwork card */
.artist-card {
  cursor: pointer;
  display: flex;
  position: relative;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
}

.arts-card-container {
  width: 100%;
  height: 200px;
  flex-direction: column;
  margin: 0 0.25em;
  overflow: hidden;
}

/* Bookmark ribbon */
.arts-card-tag {
  position: absolute;
  right: 0;
  top: 5px;
  border-top-left-radius: 20px;
  border-bottom-left-radius: 20px;
  border: 1px solid rgba(0, 0, 0, 0.5);
  border-right: 0;
  background: #b57936;
  width: 40%;
  padding: 2px;
  color: #fff;
  font-size: 13px;
  font-weight: bold;
  text-align: center;
  text-transform: capitalize;
}
.arts-card-tag img {
  width: 17px;
  height: 15px;
}

.arts-card-body {
  width: 100%;
  height: 150px;
  overflow: hidden;
}

.card-teaser-img {
  object-fit: fill;
  width: 100%;
  height: 100%;
}

.arts-card-footer {
  font-family: 'Lato', sans-serif;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  padding: 0.25em;
  height: auto;
}

.artist-name a {
  font-weight: normal;
  color: #007bff !important;

  &:hover {
    text-decoration: underline !important;
  }
}

/* Landscape Layout */
.arts-card-landscape {
  display: flex;
  width: 100%;
  height: 150px;
  padding: 0;
  border-radius: 0.25em;

  .arts-card-body {
    flex-basis: 45%;
    overflow: hidden;

    .card-teaser-img {
      object-fit: cover;
      width: 100%;
      background: rgba(0, 0, 0, 0.5);
    }
    .card-teaser-null {
      object-fit: none;
      background-color: rgba(255, 255, 255, 0.8);
    }
  }

  .arts-card-right {
    flex-basis: 55%;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    box-sizing: border-box;
    padding-left: 0.5em;
    color: #151515;

    .arts-card-footer {
      .artist-title {
        width: 100%;
        max-height: 60px;
        overflow-wrap: break-word;
        word-wrap: break-word;
        word-break: break-all;
        overflow: hidden;
        font: Bold 16px/20px Proxima Nova;
        color: #151515;
        margin: 0.1em;
        padding: 0;
      }
      .artist-name {
        font-size: 0.7em;
        font-weight: 800;
        color: #707070;
      }
    }

    .arts-card-more {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .arts-card-tag {
        border-radius: 20px;
        position: initial;
        padding: 3px 8px;
        color: #fff;
        font-size: 0.8em;
        font-weight: 800;
        border: 0;
        width: auto;
      }

      .fpcc-card-more {
        width: 55px;
        background-color: #b57936;
        display: flex;
        align-items: center;
        height: 35px;
        justify-content: center;
        border-top-left-radius: 1em;
        border-bottom-left-radius: 1em;
      }
    }
  }

  &:hover {
    border: 1px solid #b57936;

    .fpcc-card-more {
      background-color: #3d3d3d !important;
    }
  }
}

.card-selected {
  border: 1px solid #b57936;
  transform: translateX(10px);

  .fpcc-card-more {
    background-color: #3d3d3d !important;
  }
}

/* Animation  */

@keyframes hover {
  0% {
    transform: translateY(0);
  }

  25% {
    transform: translateY(5px);
  }

  50% {
    transform: translateY(0);
  }

  70% {
    transform: translateY(5px);
  }

  100% {
    transform: translateY(0);
  }
}

@keyframes shadowpulse {
  0% {
    transform: scale(0.975);
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0.7);
  }

  70% {
    transform: scale(1);
    box-shadow: 0 0 0 5px rgba(0, 0, 0, 0);
  }

  100% {
    transform: scale(0.975);
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0);
  }
}

/********* ART DETAILS CSS STYLE ************/
.artist-content-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin: 0em 1em 0.25em 1em;
  font-family: 'Proxima Nova', sans-serif;
}

.artist-content-field {
  display: flex;
  width: 100%;
  flex-direction: column;
  margin: 1em 0.5em 0.4em 0.5em;
  overflow: hidden;

  a {
    text-decoration: underline;
  }
}

.field-title {
  color: #707070;
  font: Bold 15px/18px Proxima Nova;
  text-transform: capitalize;
}

.field-content {
  display: flex;
  font: normal 16px/25px Proxima Nova;
  flex-direction: column;
  color: #151515;
}

.field-content font {
  font: normal 16px/25px Proxima Nova !important;
}

.field-content a {
  text-decoration: underline;
  color: #c46257;
}

.field-content h1,
.field-content h2,
.field-content h3,
.field-content h4,
.field-content h5 {
  font-size: 1rem;
  font-weight: 600;
  color: #151515;
}

.field-content p,
.field-content span,
.field-content pre,
.field-content label,
.field-content legend {
  font: normal 16px/25px Proxima Nova !important;
  color: #151515 !important;
  background: none !important;
  overflow-x: hidden;
}

.artist-content-field > .field-content-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.field-content-list li {
  display: flex;
  align-items: center;
  & > * {
    margin-right: 0.4em;
  }
}

.artist-social-icons {
  display: flex;
  padding: 0;
  justify-content: flex-start;
  width: 100%;
  list-style: none;
  text-align: center;
}

.artist-social-icons li {
  width: 25px;
  height: 25px;
  margin: 0.25em 0.5em 0.5em 0;
}

.artist-social-icons img {
  width: 25px;
  height: 25px;
}
</style>
