<template>
  <div class="map-container" :class="{ detailModeContainer: isDetailMode }">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :geolocate-control="GEOLOCATE_CONTROL"
      :nav-control="{ show: false }"
      @map-init="mapInit"
      @map-load="mapLoaded"
      @map-click="mapClicked"
      @map-zoomend="mapZoomEnd"
      @map-moveend="mapMoveEnd"
      @map-sourcedata="mapSourceData"
    ></Mapbox>
    <Zoom class="zoom-control"></Zoom>
    <ShareEmbed class="share-embed-control"></ShareEmbed>
    <ResetMap class="reset-map-control"></ResetMap>
    <SearchBar></SearchBar>
    <NavigationBar></NavigationBar>
    <SideBar v-if="this.$route.name === 'index'" active="Languages">
      <div>
        <section class="pl-3 pr-3 mt-3">
          <Accordion :content="accordionContent"></Accordion>
        </section>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge
            content="Languages"
            :number="languages.length"
            class="cursor-pointer"
            @click.native.prevent="goToLang"
          ></Badge>
          <Badge
            content="Communities"
            :number="communities.length"
            class="cursor-pointer"
            bgcolor="#6c4264"
            @click.native.prevent="goToCommunity"
          ></Badge>
        </section>
        <hr class="sidebar-divider">
        <Filters class="mb-4"></Filters>
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)">
            <!--TODO: Aaron please remove this, why is it hardcoded? -->
          </LangFamilyTitle>
          <div v-for="(language, index) in languages" :key="index">
            <LanguageCard
              class="mt-3 hover-left-move"
              :name="language.name"
              :color="language.color"
              @click.native.prevent="
                handleCardClick($event, language.name, 'languages')
              "
            ></LanguageCard>
          </div>
        </section>
        <section class="community-section pl-3 pr-3">
          <div v-for="community in communities" :key="community.name">
            <CommunityCard
              class="mt-3 hover-left-move"
              :name="community.name"
              @click.native.prevent="
                handleCardClick(
                  $event,
                  community.name,
                  'content',
                  community.name
                )
              "
            ></CommunityCard>
          </div>
        </section>
      </div>
    </SideBar>
    <nuxt-child v-else/>
  </div>
</template>

<script>
import Mapbox from 'mapbox-gl-vue'
import SearchBar from '@/components/SearchBar.vue'
import NavigationBar from '@/components/NavigationBar.vue'
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import ShareEmbed from '@/components/ShareEmbed.vue'
import ResetMap from '@/components/ResetMap.vue'
import Zoom from '@/components/Zoom.vue'
import LangFamilyTitle from '@/components/languages/LangFamilyTitle.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import { inBounds } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import layers from '@/plugins/layers.js'

const markers = {}
let markersOnScreen = {}

export default {
  components: {
    Mapbox,
    SearchBar,
    NavigationBar,
    SideBar,
    Accordion,
    Badge,
    LangFamilyTitle,
    LanguageCard,
    CommunityCard,
    ShareEmbed,
    ResetMap,
    Zoom,
    Filters
  },
  data() {
    return {
      MAPBOX_ACCESS_TOKEN:
        'pk.eyJ1IjoiY291bnRhYmxlLXdlYiIsImEiOiJjamQyZG90dzAxcmxmMndtdzBuY3Ywa2ViIn0.MU-sGTVDS9aGzgdJJ3EwHA',
      MAP_OPTIONS: {
        style: 'mapbox://styles/countable-web/cjyhw87ck01w01cp4u35a73lx', // hero
        center: [-125, 55],
        maxZoom: 19,
        minZoom: 3,
        zoom: 5
      },
      GEOLOCATE_CONTROL: {
        show: true,
        position: 'bottom-left'
      },
      map: {},
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.'
    }
  },
  computed: {
    communities() {
      return this.$store.state.communities.communities
    },
    languages() {
      return this.$store.state.languages.languages || []
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
    }
  },
  async fetch({ $axios, store }) {
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }
    const results = await Promise.all([
      $axios.$get(getApiUrl('language/')),
      $axios.$get(getApiUrl('community/')),
      $axios.$get(getApiUrl('placename-geo/')),
      $axios.$get(getApiUrl('arts'))
    ])

    if (process.server) {
      store.commit('languages/set', results[0])
      store.commit('communities/set', results[1])
      store.commit('places/set', results[2].features)
      store.commit('arts/set', results[3].features)
    }

    store.commit('languages/setStore', results[0])
    store.commit('communities/setStore', results[1])
    store.commit('places/setStore', results[2].features)
    store.commit('arts/setStore', results[3].features)
  },
  methods: {
    artsClusterImage(props, coords, map) {
      const html = `<svg xmlns="http://www.w3.org/2000/svg" width="54" height="53" viewBox="0 0 54 53"><defs><style>.a{fill:#fff;}.b{fill:#515350;}.c{fill:#b45339;}</style></defs><g transform="translate(-470 -452)"><circle class="a" cx="22.5" cy="22.5" r="22.5" transform="translate(470 460)"/><circle class="b" cx="20.5" cy="20.5" r="20.5" transform="translate(472 462)"/><circle class="a" cx="13.5" cy="13.5" r="13.5" transform="translate(497 452)"/><path class="c" d="M6989.312,282a11.31,11.31,0,1,0,11.309,11.31A11.311,11.311,0,0,0,6989.312,282Zm-8.654,6.817a.362.362,0,0,1,.5-.479,4.74,4.74,0,0,0,5-.428,4.148,4.148,0,0,1,6.021,1.149.468.468,0,0,1-.594.67,4.9,4.9,0,0,0-5.02.219C6984.084,291.716,6981.76,291.029,6980.657,288.817Zm14,4.09c-1.689-.242-4.229-.243-4.229,1.932v.828a.4.4,0,0,1-.4.395h-.636a.394.394,0,0,1-.395-.395v-.828c0-2.126-2.6-2.173-4.409-1.948a.174.174,0,0,1-.077-.337,15.241,15.241,0,0,1,10.233.019A.174.174,0,0,1,6994.661,292.907Zm-.027,2.136h-2.9a.245.245,0,0,1-.188-.4c.56-.668,1.848-1.766,3.279,0A.247.247,0,0,1,6994.633,295.042Zm-7.119,0h-2.929a.24.24,0,0,1-.185-.392c.557-.668,1.856-1.792,3.3,0A.24.24,0,0,1,6987.514,295.042Zm.677,3.261a1.426,1.426,0,1,1,1.426,1.427A1.425,1.425,0,0,1,6988.191,298.3Zm1.875,3.035a.181.181,0,0,1-.032-.359,6.421,6.421,0,0,0,4.893-3.81.181.181,0,0,1,.349.087C6995.026,299.007,6993.994,301.539,6990.066,301.338Zm8.381-10.352c-2.423,1.035-4.361-.6-5.569-2.669a5.777,5.777,0,0,0-2.654-2.289.349.349,0,0,1,.162-.667c1.855.111,3.091.948,4.326,2.955a4.26,4.26,0,0,0,3.611,1.947A.375.375,0,0,1,6998.447,290.986Z" transform="translate(-6478.949 172.052)"/></g><text x="42%" y="65%" text-anchor="middle" fill="white" font-size="0.9em" font-weight="Bold">${
        props.point_count
      }</text></svg>`
      const el = document.createElement('div')
      el.innerHTML = html
      el.firstChild.addEventListener('click', function(e) {
        map.flyTo({
          center: [coords[0], coords[1]],
          zoom: map.getZoom() + 1,
          speed: 1,
          curve: 1
        })
      })
      return el.firstChild
    },
    updateMarkers(map) {
      const newMarkers = {}
      const mapboxgl = require('mapbox-gl')
      const features = map.querySourceFeatures('arts1')
      // for every cluster on the screen, create an HTML marker for it (if we didn't yet),
      // and add it to the map if it's not there already
      for (let i = 0; i < features.length; i++) {
        const coords = features[i].geometry.coordinates
        const props = features[i].properties

        if (!props.cluster) continue
        const id = props.cluster_id

        let marker = markers[id]
        if (!marker) {
          const el = this.artsClusterImage(props, coords, map)
          marker = markers[id] = new mapboxgl.Marker({ element: el }).setLngLat(
            coords
          )
        }
        newMarkers[id] = marker

        if (!markersOnScreen[id]) marker.addTo(map)
      }
      // for every marker we've added previously, remove those that are no longer visible
      for (const id in markersOnScreen) {
        if (!newMarkers[id]) markersOnScreen[id].remove()
      }
      markersOnScreen = newMarkers
    },
    handleCardClick(e, data, type, geom) {
      if (type === 'community') {
        this.$router.push({
          path: `/content/${encodeURIComponent(data)}`
        })
      } else {
        this.$router.push({
          path: `/${type}/${encodeURIComponent(data)}`
        })
      }
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
    mapClicked(map, e) {
      const features = map.queryRenderedFeatures(e.point)

      const art = features.find(feat => feat.layer.id === 'fn-arts')
      console.log('Art Found', art)
      const community = features.find(
        feat => feat.layer.id === 'fn-nations copy'
      )
      console.log('Community Found', community)
      /*
      const feature = features.find(
        feature => feature.layer.id === 'fn-lang-areas-shaded'
      )
      */
      console.log('Features on click', features)
      /*
      if (feature) {
        this.$router.push({
          path: `/languages/${encodeURIComponent(feature.properties.name)}`
        })
      }
      */
    },
    mapLoaded(map) {
      this.$root.$on('resetMap', () => {
        map.setCenter(this.MAP_OPTIONS.center)
        map.setZoom(this.MAP_OPTIONS.zoom)
      })

      map.addSource('langs1', {
        type: 'geojson',
        data: '/api/language-geo/'
      })
      map.addSource('arts1', {
        type: 'geojson',
        data: '/static/web/arts1.json',
        cluster: true,
        clusterMaxZoom: 14,
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

        // this.updateData(map)
      })
      this.$eventHub.$emit('map-loaded', map)
    },
    zoomToHash(map) {
      const hash = this.$route.hash
      if (hash) {
        try {
          const split = hash.split('/')
          const lat = split[0].substr(1)
          const lng = split[1]
          const zoom = split[2]

          map.flyTo({
            center: [lng, lat],
            zoom: zoom,
            speed: 1,
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
      this.$store.commit('languages/set', this.filterLanguages(bounds))
      this.$store.commit('communities/set', this.filterCommunities(bounds))
      this.$store.commit('arts/set', this.filterArts(bounds))
      this.$store.commit('places/set', this.filterPlaces(bounds))
    },
    mapZoomEnd(map, e) {
      this.updateMarkers(map)
      this.updateData(map)
    },
    mapMoveEnd(map, e) {
      this.updateMarkers(map)
      this.updateData(map)
    },
    mapSourceData(map, source) {
      if (source.sourceId === 'arts1') {
        this.updateMarkers(map)
      }
    },
    filterLanguages(bounds) {
      return this.languageSet.filter(lang => {
        const sw = lang.bbox.coordinates[0][0]
        const nw = lang.bbox.coordinates[0][1]
        const ne = lang.bbox.coordinates[0][2]
        const se = lang.bbox.coordinates[0][3]
        return (
          inBounds(bounds, sw) || inBounds(bounds, ne) || inBounds(bounds, nw),
          inBounds(bounds, se)
        )
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
    filterPlaces(bounds) {
      return this.placesSet.filter(place => {
        if (place.geometry !== null) {
          const point = place.geometry.coordinates
          return inBounds(bounds, point)
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

.map-container {
  width: 100%;
  height: 100%;
  position: relative;
  padding-left: var(--sidebar-width, 350px);
}
.share-embed-control,
.zoom-control {
  position: absolute;
  right: 10px;
  bottom: 30px;
}

.zoom-control {
  right: 230px;
}

.reset-map-control {
  position: absolute;
  right: 135px;
  bottom: 30px;
}
.sidebar-divider {
  margin-bottom: 0.5rem;
}
.detailModeContainer {
  padding-left: 500px !important;
}
</style>
