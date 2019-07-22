<template>
  <div class="map-container" :class="{ detailModeContainer: isDetailMode }">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :geolocate-control="GEOLOCATE_CONTROL"
      :nav-control="{ show: false }"
      @map-sourcedata="mapSourceData"
      @map-init="mapInit"
      @map-load="mapLoaded"
      @map-click="mapClicked"
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
            @click.native.prevent="goToCommunity"
          ></Badge>
        </section>
        <hr class="sidebar-divider" />
        <Filters class="mb-4"></Filters>
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div v-for="(language, index) in languages" :key="index">
            <LanguageCard
              class="mt-3 hover-left-move"
              :name="language.properties.name"
              :color="language.properties.color"
              @click.native.prevent="
                handleCardClick($event, language.properties.name, 'languages')
              "
            ></LanguageCard>
          </div>
        </section>
        <section class="community-section pl-3 pr-3">
          <div
            v-for="community in communities"
            :key="community.properties.title"
          >
            <CommunityCard
              class="mt-3 hover-left-move"
              :name="community.properties.title"
              @click.native.prevent="
                handleCardClick(
                  $event,
                  community.properties.title,
                  'content',
                  community.geometry
                )
              "
            ></CommunityCard>
          </div>
        </section>
      </div>
    </SideBar>
    <nuxt-child v-else />
  </div>
</template>

<script>
import Mapbox from 'mapbox-gl-vue'
import { uniqBy } from 'lodash'
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
import { zoomToCommunity } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'

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
        style: 'mapbox://styles/countable-web/cjwcq8ybe06so1cpin5lz5sfj/draft',
        center: [-125, 55],
        maxZoom: 19,
        minZoom: 3,
        zoom: 5
      },
      GEOLOCATE_CONTROL: {
        show: true,
        position: 'bottom-right'
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
      return this.$store.state.languages.languages
    },
    isDetailMode() {
      return this.$store.state.sidebar.isDetailMode
    }
  },
  async fetch({ $axios, store }) {
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }
    const results = await Promise.all([
      $axios.$get(getApiUrl('language/')),
      $axios.$get(getApiUrl('community/')),
      $axios.$get(getApiUrl('placename/')),
      $axios.$get(getApiUrl('arts'))
    ])

    store.commit('languages/setStore', results[0])
    store.commit('communities/setStore', results[1])
    store.commit('places/setStore', results[2].features)
    store.commit('arts/setStore', results[3].features)
  },
  methods: {
    artsClusterImage(props) {
      const html = `<svg xmlns="http://www.w3.org/2000/svg" width="54" height="53" viewBox="0 0 54 53"><defs><style>.a{fill:#fff;}.b{fill:#515350;}.c{fill:#b45339;}</style></defs><g transform="translate(-470 -452)"><circle class="a" cx="22.5" cy="22.5" r="22.5" transform="translate(470 460)"/><circle class="b" cx="20.5" cy="20.5" r="20.5" transform="translate(472 462)"/><circle class="a" cx="13.5" cy="13.5" r="13.5" transform="translate(497 452)"/><path class="c" d="M6989.312,282a11.31,11.31,0,1,0,11.309,11.31A11.311,11.311,0,0,0,6989.312,282Zm-8.654,6.817a.362.362,0,0,1,.5-.479,4.74,4.74,0,0,0,5-.428,4.148,4.148,0,0,1,6.021,1.149.468.468,0,0,1-.594.67,4.9,4.9,0,0,0-5.02.219C6984.084,291.716,6981.76,291.029,6980.657,288.817Zm14,4.09c-1.689-.242-4.229-.243-4.229,1.932v.828a.4.4,0,0,1-.4.395h-.636a.394.394,0,0,1-.395-.395v-.828c0-2.126-2.6-2.173-4.409-1.948a.174.174,0,0,1-.077-.337,15.241,15.241,0,0,1,10.233.019A.174.174,0,0,1,6994.661,292.907Zm-.027,2.136h-2.9a.245.245,0,0,1-.188-.4c.56-.668,1.848-1.766,3.279,0A.247.247,0,0,1,6994.633,295.042Zm-7.119,0h-2.929a.24.24,0,0,1-.185-.392c.557-.668,1.856-1.792,3.3,0A.24.24,0,0,1,6987.514,295.042Zm.677,3.261a1.426,1.426,0,1,1,1.426,1.427A1.425,1.425,0,0,1,6988.191,298.3Zm1.875,3.035a.181.181,0,0,1-.032-.359,6.421,6.421,0,0,0,4.893-3.81.181.181,0,0,1,.349.087C6995.026,299.007,6993.994,301.539,6990.066,301.338Zm8.381-10.352c-2.423,1.035-4.361-.6-5.569-2.669a5.777,5.777,0,0,0-2.654-2.289.349.349,0,0,1,.162-.667c1.855.111,3.091.948,4.326,2.955a4.26,4.26,0,0,0,3.611,1.947A.375.375,0,0,1,6998.447,290.986Z" transform="translate(-6478.949 172.052)"/></g><text x="42%" y="65%" text-anchor="middle" fill="white" font-size="0.9em" font-weight="Bold">${
        props.point_count
      }</text></svg>`
      const el = document.createElement('div')
      el.innerHTML = html
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
          const el = this.artsClusterImage(props)
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
      if (type === 'languages') {
        // const lang = this.languages.find(l => l.name === data)
        // zoomToLanguage({ map: this.map, lang: lang })
      } else {
        zoomToCommunity({ map: this.map, comm: data, geom })
      }
      this.$router.push({
        path: `/${type}/${encodeURIComponent(data)}`
      })
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
      const feature = features.find(
        feature => feature.layer.id === 'fn-lang-areas-fill'
      )
      // const lang = this.languages.find(l => l.name === feature.properties.name)
      // zoomToLanguage({ map, lang })
      if (feature) {
        this.$router.push({
          path: `/languages/${encodeURIComponent(feature.properties.name)}`
        })
      }
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

      map.addLayer(
        {
          id: 'fn-lang-areas-fill',
          type: 'fill',
          source: 'langs1',
          layout: {},
          paint: {
            'fill-color': ['get', 'color'],
            'fill-opacity': [
              'interpolate',
              ['linear'],
              ['zoom'],
              3,
              0.5,
              9,
              0.08
            ]
          }
        },
        'fn-nations'
      )
      map.addLayer(
        {
          id: 'fn-lang-area-outlines',
          type: 'line',
          source: 'langs1',
          layout: {},
          paint: {
            'line-color': ['get', 'color'],
            'line-blur': 0,
            'line-width': ['interpolate', ['linear'], ['zoom'], 4, 2, 18, 10],
            'line-offset': ['interpolate', ['linear'], ['zoom'], 4, 1, 18, 5],
            'line-opacity': [
              'interpolate',
              ['linear'],
              ['zoom'],
              4,
              0.45,
              18,
              0.2
            ]
          }
        },
        'fn-nations'
      )
      map.addLayer(
        {
          id: 'langs-highlighted',
          type: 'fill',
          source: 'langs1',
          layout: {},
          paint: {
            'fill-color': 'black',
            'fill-opacity': 0.4
          }
        },
        'fn-nations'
      )
      map.setFilter('langs-highlighted', ['in', 'name', ''])
      /*
      map.addLayer(
        {
          id: 'fn-arts-clusters',
          type: 'circle',
          source: 'arts1',
          filter: ['has', 'point_count'],
          paint: {
            'circle-color': [
              'step',
              ['get', 'point_count'],
              '#51bbd6',
              100,
              '#f1f075',
              750,
              '#f28cb1'
            ],
            'circle-radius': [
              'step',
              ['get', 'point_count'],
              20,
              100,
              30,
              750,
              40
            ]
          }
        },
        'fn-nations'
      )
  */
      map.addLayer(
        {
          id: 'cluster-count',
          type: 'symbol',
          source: 'arts1',
          filter: ['has', 'point_count'],
          layout: {
            'text-field': '{point_count_abbreviated}',
            'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
            'text-size': 12
          }
        },
        'fn-nations'
      )

      map.addLayer(
        {
          id: 'fn-arts',
          type: 'circle',
          source: 'arts1',
          filter: ['!', ['has', 'point_count']],
          paint: {
            'circle-color': '#11b4da',
            'circle-radius': 4,
            'circle-stroke-width': 1,
            'circle-stroke-color': '#fff'
          }
        },
        'fn-nations'
      )

      const hash = this.$route.hash
      if (hash) {
        try {
          const split = hash.split('/')
          const lat = split[0].substr(1)
          const lng = split[1]
          const zoom = split[2]
          map.setCenter([lat, lng])
          map.setZoom(zoom)
        } catch (e) {}
      }
      // Idle event not supported/working by mapbox-gl-vue natively, so we're doing it here.
      map.on('idle', e => {
        const renderedFeatures = e.target.queryRenderedFeatures()
        const communities = renderedFeatures.filter(
          feature => feature.layer.id === 'fn-nations'
        )
        this.$store.commit('communities/set', communities)
        const places = renderedFeatures.filter(
          feature => feature.layer.id === 'fn-places'
        )
        this.$store.commit('places/set', places)
        const arts = renderedFeatures.filter(
          feature => feature.layer.id === 'fn-arts'
        )

        const clusters = renderedFeatures.filter(
          feature => feature.layer.id === 'fn-arts-clusters'
        )

        const clusterSource = this.map.getSource('arts1')
        clusters.map(cluster => {
          clusterSource.getClusterLeaves(
            cluster.properties.cluster_id,
            Infinity,
            0,
            (err, features) => {
              if (err) return
              arts.push(...features)
            }
          )
        })
        this.$store.commit('arts/set', arts)

        const center = map.getCenter()
        const zoom = map.getZoom()
        this.$router.push({
          hash: `${center.lat}/${center.lng}/${zoom}`
        })

        this.updateMarkers(map)
      })
      this.$eventHub.$emit('map-loaded', map)
    },
    mapSourceData(map, source) {
      if (source.isSourceLoaded) {
        const languages = uniqBy(
          map.querySourceFeatures('langs1'),
          lang => lang.properties.name
        )
        if (languages.length > 0) {
          this.$store.commit('languages/set', languages)
        }
      }
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
  right: 50px;
  bottom: 30px;
}

.zoom-control {
  right: 267px;
}

.reset-map-control {
  position: absolute;
  right: 170px;
  bottom: 30px;
}
.sidebar-divider {
  margin-bottom: 0.5rem;
}
.detailModeContainer {
  padding-left: 500px !important;
}
</style>
