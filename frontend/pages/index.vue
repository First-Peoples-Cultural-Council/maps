<template>
  <div class="map-container">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :nav-control="NAV_CONTROL"
      :geolocate-control="GEOLOCATE_CONTROL"
      @map-init="mapInit"
      @map-load="mapLoaded"
      @map-click="mapClicked"
      @geolocate-error="geolocateError"
      @geolocate-geolocate="geolocate"
    ></Mapbox>
    <SearchBar></SearchBar>
    <NavigationBar></NavigationBar>
    <SideBar v-if="this.$route.name === 'index'" active="Languages">
      <div>
        <section class="pl-3 pr-3 mt-3">
          <Accordion :content="accordionContent"></Accordion>
        </section>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge content="Languages" :number="languages.length"></Badge>
          <Badge content="Communities" :number="communities.length"></Badge>
        </section>
        <hr />
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div v-for="language in languages" :key="language.name">
            <LanguageCard
              class="mt-3 hover-left-move"
              :name="language.name"
              :color="language.color"
              @click.native.prevent="handleCardClick($event, language.name)"
            ></LanguageCard>
          </div>
        </section>
        <section class="community-section pl-3 pr-3">
          <div
            v-for="community in communities.features"
            :key="community.properties.name"
          >
            <CommunityCard
              class="mt-3 hover-left-move"
              :name="community.properties.name"
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
import { bbox } from '@turf/turf'

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
      feature: {},
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.'
    }
  },
  async asyncData({ $axios, store }) {
    let api = process.server
      ? 'http://nginx/api/community/'
      : 'http://localhost/api/community/'
    const communities = await $axios.$get(api)

    api = process.server
      ? 'http://nginx/api/language/'
      : 'http://localhost/api/language/'
    const languages = await $axios.$get(api)

    store.commit('languages/set', languages)
    store.commit('communities/set', communities)

    return {
      languages,
      communities
    }
  },
  methods: {
    geolocateError() {},
    geolocate() {},
    handleCardClick(e, data) {
      this.$router.push({
        path: `/languages/${encodeURIComponent(data)}`
      })
    },
    mapInit(map, e) {
      const self = this
      self.$store.commit('mapinstance/set', map)
    },
    mapClicked(map, e) {
      const features = map.queryRenderedFeatures(e.point)
      const feature = features.find(
        feature => feature.layer.id === 'fn-lang-areas-fill'
      )
      this.$store.commit('features/set', feature)
      this.$store.commit('sidebar/set', true)
      const bounds = bbox(feature)
      map.fitBounds(bounds, { padding: 30 })
      console.log(feature)
      this.$router.push({
        path: `/languages/${encodeURIComponent(feature.properties.title)}`
      })
    },
    mapLoaded(map) {
      map.addSource('langs1', {
        type: 'geojson',
        data: '/static/web/langs.json'
      })
      map.addLayer({
        id: 'fn-lang-areas-fill',
        type: 'fill',
        // metadata: {},
        source: 'langs1',
        layout: {},
        paint: {
          'fill-color': ['get', 'color'],
          'fill-opacity': [
            'interpolate',
            ['linear'],
            ['zoom'],
            3,
            0.19,
            9,
            0.08
          ]
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
</style>
