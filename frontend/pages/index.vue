<template>
  <div class="map-container">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :nav-control="NAV_CONTROL"
      :geolocate-control="GEOLOCATE_CONTROL"
      @map-sourcedata="mapSourceData"
      @map-init="mapInit"
      @map-load="mapLoaded"
      @map-click="mapClicked"
    ></Mapbox>
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
        <hr />
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
import SearchBar from '@/components/SearchBar.vue'
import NavigationBar from '@/components/NavigationBar.vue'
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import LangFamilyTitle from '@/components/languages/LangFamilyTitle.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import { zoomToCommunity } from '@/mixins/map.js'

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
    CommunityCard
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
      NAV_CONTROL: {
        show: true,
        position: 'bottom-right'
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
        const places = renderedFeatures.filter(
          feature => feature.layer.id === 'fn-places'
        )
        const arts = renderedFeatures.filter(
          feature => feature.layer.id === 'fn-arts'
        )
        console.log('Map bounds', e.target.getBounds())
        this.$store.commit('communities/set', communities)
        this.$store.commit('places/set', places)
        this.$store.commit('arts/set', arts)

        const center = map.getCenter()
        const zoom = map.getZoom()
        this.$router.push({
          hash: `${center.lat}/${center.lng}/${zoom}`
        })
      })
      this.$eventHub.$emit('map-loaded', map)
    },
    mapSourceData(map, source) {
      if (source.isSourceLoaded) {
        const languages = map.querySourceFeatures('langs1')
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
</style>
