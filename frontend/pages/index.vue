<template>
  <div
    class="map-container"
    :class="{
      detailModeContainer: isDetailMode
    }"
  >
    <div v-if="isDrawMode" class="drawing-mode-container">
      <b-alert show class="p-1 pr-2 pl-2 draw-mode-container" variant="light">
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
      @map-click="mapClicked"
      @map-touchend="mapClicked"
      @map-zoomend="mapZoomEnd"
      @map-moveend="mapMoveEnd"
      @map-sourcedata="mapSourceData"
    ></Mapbox>
    <div class="map-controls-overlay">
      <Zoom class="zoom-control hide-mobile mr-2"></Zoom>
      <ResetMap class="reset-map-control hide-mobile mr-2"></ResetMap>
      <ShareEmbed class="share-embed-control hide-mobile mr-2"></ShareEmbed>
      <Contribute class="hide-mobile contribute-control"></Contribute>
    </div>
    <SideBar v-if="this.$route.name === 'index'">
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
        <section class="pl-3 pr-3 mt-3">
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
          >
            <h5 class="language-family mt-3">
              Language Family:
              {{ family === 'undefined' ? 'No Family' : family }}
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
                  class="mt-3 hover-left-move"
                  :name="language.name"
                  :color="
                    (language.family && language.family.color) || language.color
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
          <b-row>
            <h5 class="language-family mt-3 pl-3 pr-3">Communities</h5>
            <b-col
              v-for="community in communities"
              :key="'community ' + community.name"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <CommunityCard
                class="mt-3 hover-left-move"
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
        'mobile-content-open': mobileContent
      }"
    >
      <nuxt-child class="w-100" />
    </div>
    <div v-else>
      <nuxt-child />
    </div>
    <ModalNotification></ModalNotification>
    <transition name="fade-topbar" mode="out-in">
      <SearchOverlay
        v-if="showSearchOverlay"
        :show="showSearchOverlay"
      ></SearchOverlay>
      <div v-else class="top-bar-container shadow-sm">
        <SearchBar class="hide-mobile"></SearchBar>
        <NavigationBar></NavigationBar>
      </div>
    </transition>
  </div>
</template>

<script>
import Mapbox from 'mapbox-gl-vue'
import { groupBy } from 'lodash'
import '@mapbox/mapbox-gl-draw/dist/mapbox-gl-draw.css'
import * as MapboxDraw from '@mapbox/mapbox-gl-draw/dist/mapbox-gl-draw'
import DrawingTools from '@/components/DrawingTools.vue'
import SearchBar from '@/components/SearchBar.vue'
import NavigationBar from '@/components/NavigationBar.vue'
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import ShareEmbed from '@/components/ShareEmbed.vue'
import ResetMap from '@/components/ResetMap.vue'
import Contribute from '@/components/Contribute.vue'
import Zoom from '@/components/Zoom.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import { inBounds, zoomToIdealBox } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import layers from '@/plugins/layers.js'
import ModalNotification from '@/components/ModalNotification.vue'
import SearchOverlay from '@/components/SearchOverlay.vue'

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
                <span class='art-popup-type'>${props.art_type}</span>
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
    ResetMap,
    Zoom,
    Filters,
    Contribute,
    DrawingTools,
    ModalNotification
  },
  data() {
    return {
      showSearchOverlay: false,
      MAPBOX_ACCESS_TOKEN:
        'pk.eyJ1IjoiY291bnRhYmxlLXdlYiIsImEiOiJjamQyZG90dzAxcmxmMndtdzBuY3Ywa2ViIn0.MU-sGTVDS9aGzgdJJ3EwHA',
      MAP_OPTIONS: {
        style: 'mapbox://styles/countable-web/cjyhw87ck01w01cp4u35a73lx/draft', // hero
        center: [-125, 55],
        maxZoom: 19,
        minZoom: 3,
        zoom: 4
      },
      mode: 'All',
      map: {},
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
      ie: `
        <!--[if lt IE 7]> <div id="ie style="color: red; padding: 0.5rem 2rem;">Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->
        <!--[if IE 7]> <div id="ie style="color: red; padding: 0.5rem 2rem;">Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->
        <!--[if IE 8]> <div id="ie" style="color: red; padding: 0.5rem 2rem;>Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->
        <!--[if IE 9]> <div id="ie" style="color: red; padding: 0.5rem 2rem;">Please upgrade your browser to IE11 or higher, Firefox or Chrome</div> <![endif]-->`
    }
  },
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
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
    placesSet() {
      return this.$store.state.places.placesSet
    },
    isDrawMode() {
      return this.$store.state.contribute.isDrawMode
    }
  },
  async asyncData({ params, $axios, store }) {
    // Check if already logged in here
    const user = await $axios.$get(
      `${getApiUrl('user/auth/?timestamp=${new Date().getTime()')}}`
    )
    if (user.is_authenticated) {
      store.commit('user/setUser', user.user)
      store.commit('user/setPicture', user.user.picture)
      store.commit('user/setLoggedIn', true)
    }
    return user
  },
  async fetch({ $axios, store }) {
    const results = await Promise.all([
      $axios.$get(getApiUrl('language/')),
      $axios.$get(getApiUrl('community/')),
      $axios.$get(
        getApiUrl(`placename-geo?timestamp=${new Date().getTime()}/`)
      ),
      $axios.$get(getApiUrl('arts'))
    ])

    if (process.server) {
      store.commit('languages/set', groupBy(results[0], 'family.name'))
      store.commit('communities/set', results[1])
      store.commit('places/set', results[2].features)
      store.commit('arts/set', results[3].features)
      store.commit('languages/setLanguagesCount', results[0].length)
    }

    store.commit('languages/setStore', results[0])
    store.commit('communities/setStore', results[1])
    store.commit('places/setStore', results[2].features)
    store.commit('arts/setStore', results[3].features)
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
  async mounted() {
    this.$root.$on('showSearchOverlay', d => {
      this.showSearchOverlay = true
    })
    this.$root.$on('closeSearchOverlay', d => {
      this.showSearchOverlay = false
    })
    // consume a JWT and authenticate locally.
    if (this.$route.hash.includes('id_token')) {
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
    }
    // initial zoom on index page
    if (this.$route.path === '/' && !this.$route.hash) {
      this.$eventHub.whenMap(map => {
        zoomToIdealBox({ map })
      })
    }
  },
  methods: {
    routesToNotRenderChild() {
      return !(
        this.$route.name === 'index-languages' ||
        this.$route.name === 'index-heritages' ||
        this.$route.name === 'index-arts'
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
      const html = `<svg class="markerCluster" xmlns="http://www.w3.org/2000/svg" width="54" height="53" viewBox="0 0 54 53"><defs><style>.a{fill:#fff;}.b{fill:#515350;}.c{fill:#b45339;}</style></defs><g transform="translate(-470 -452)"><circle class="a" cx="22.5" cy="22.5" r="22.5" transform="translate(470 460)"/><circle class="b" cx="20.5" cy="20.5" r="20.5" transform="translate(472 462)"/><circle class="a" cx="13.5" cy="13.5" r="13.5" transform="translate(497 452)"/><path class="c" d="M6989.312,282a11.31,11.31,0,1,0,11.309,11.31A11.311,11.311,0,0,0,6989.312,282Zm-8.654,6.817a.362.362,0,0,1,.5-.479,4.74,4.74,0,0,0,5-.428,4.148,4.148,0,0,1,6.021,1.149.468.468,0,0,1-.594.67,4.9,4.9,0,0,0-5.02.219C6984.084,291.716,6981.76,291.029,6980.657,288.817Zm14,4.09c-1.689-.242-4.229-.243-4.229,1.932v.828a.4.4,0,0,1-.4.395h-.636a.394.394,0,0,1-.395-.395v-.828c0-2.126-2.6-2.173-4.409-1.948a.174.174,0,0,1-.077-.337,15.241,15.241,0,0,1,10.233.019A.174.174,0,0,1,6994.661,292.907Zm-.027,2.136h-2.9a.245.245,0,0,1-.188-.4c.56-.668,1.848-1.766,3.279,0A.247.247,0,0,1,6994.633,295.042Zm-7.119,0h-2.929a.24.24,0,0,1-.185-.392c.557-.668,1.856-1.792,3.3,0A.24.24,0,0,1,6987.514,295.042Zm.677,3.261a1.426,1.426,0,1,1,1.426,1.427A1.425,1.425,0,0,1,6988.191,298.3Zm1.875,3.035a.181.181,0,0,1-.032-.359,6.421,6.421,0,0,0,4.893-3.81.181.181,0,0,1,.349.087C6995.026,299.007,6993.994,301.539,6990.066,301.338Zm8.381-10.352c-2.423,1.035-4.361-.6-5.569-2.669a5.777,5.777,0,0,0-2.654-2.289.349.349,0,0,1,.162-.667c1.855.111,3.091.948,4.326,2.955a4.26,4.26,0,0,0,3.611,1.947A.375.375,0,0,1,6998.447,290.986Z" transform="translate(-6478.949 172.052)"/></g><text x="42%" y="65%" text-anchor="middle" fill="white" font-size="0.9em" font-weight="Bold">${
        props.point_count
      }</text></svg>`
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
      console.log('zoom', map.getZoom(), this.$route.name)
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
      console.log('Click Disabled', this.isDrawMode)
      if (this.isDrawMode) {
        return
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
          console.log(feature)
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
            const clusterId = feature.properties.cluster_id
            map
              .getSource('arts1')
              .getClusterLeaves(
                clusterId,
                feature.properties.point_count,
                0,
                function(err, aFeatures) {
                  console.log('getClusterLeaves', err, aFeatures)
                  const html = aFeatures.reduce(function(ach, feature) {
                    const props = feature.properties
                    return ach + renderArtDetail(props)
                  }, '')
                  const mapboxgl = require('mapbox-gl')
                  new mapboxgl.Popup({
                    className: 'artPopUp'
                  })
                    .setLngLat(e.lngLat)
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
          }
          done = true
        }
      })

      if (!done)
        features.forEach(feature => {
          if (feature.layer.id === 'fn-lang-areas-shaded') {
            this.$router.push({
              path: `/languages/${encodeFPCC(feature.properties.name)}`
            })
          }
        })
    },

    mapLoaded(map) {
      this.$root.$on('resetMap', () => {
        zoomToIdealBox({ map })
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
        data: '/api/art/',
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
            console.log('This got called')
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
          })
        }
      })

      map.on('draw.create', e => {
        const featuresDrawn = draw.getAll()
        let features = featuresDrawn.features
        console.log('Feature', features)
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
      const bounds = map.getBounds()
      this.$store.commit(
        'languages/set',
        filterLanguages(this.languageSet, bounds, 'default', null, this)
      )
      this.$store.commit('communities/set', this.filterCommunities(bounds))
      this.$store.commit('arts/set', this.filterArts(bounds))
      this.$store.commit('places/set', this.filterPlaces(bounds))
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
    filterPlaces(bounds) {
      return this.placesSet.filter(place => {
        if (place.properties.status === 'UN') {
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

<style>
#map {
  width: 100%;
  height: 100%;
}

.draw-mode-container {
  border: 1px solid rgba(0, 0, 0, 0.2);
  padding: 0.75em !important;
}

.map-container {
  width: 100%;
  height: 100%;
  position: relative;
  padding-left: var(--sidebar-width, 350px);
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
  top: 60px;
  left: 0;
  background-color: transparent;
  display: flex;
  justify-content: center;
  width: 100%;
  padding-left: 500px;
  z-index: 50;
}

.map-controls-overlay {
  position: absolute;
  bottom: 20px;
  right: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
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

.language-family {
  color: var(--color-darkgray, #454545);
  font-size: 0.9em;
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
  width: 350px;
  background-color: white;
  z-index: 1000;
  height: 100%;
  overflow-y: auto;
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
@media (max-width: 992px) {
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
    height: 50px;
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
    position: fixed;
    top: 0px;
    left: 0;
    padding: 0.2em;
    width: 100%;
    z-index: 100;
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
  top: 0;
  align-items: baseline;
}

.content-mobile {
  display: block !important;
}
.mobile-close {
  display: none !important;
}

@media (max-width: 574px) {
  .drawing-mode-container > div {
    width: 75%;
    font-size: 0.8em;
  }
}
</style>
