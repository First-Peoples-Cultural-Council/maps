<template>
  <div class="map-container">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :nav-control="NAV_CONTROL"
      :geolocate-control="GEOLOCATE_CONTROL"
      @map-load="mapLoaded"
      @map-click="mapClicked"
      @geolocate-error="geolocateError"
      @geolocate-geolocate="geolocate"
    ></Mapbox>
    <SearchBar></SearchBar>
    <NavigationBar></NavigationBar>
    <Languages v-if="this.$route.name === 'index'"></Languages>
    <nuxt-child v-else />
  </div>
</template>

<script>
import Mapbox from 'mapbox-gl-vue'
import SearchBar from '@/components/SearchBar.vue'
import NavigationBar from '@/components/NavigationBar.vue'
import { bbox } from '@turf/turf'
import Languages from './index/languages.vue'
export default {
  components: {
    Mapbox,
    SearchBar,
    NavigationBar,
    Languages
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
      feature: {}
    }
  },
  methods: {
    geolocateError() {},
    geolocate() {},
    mapClicked(map, e) {
      const features = map.queryRenderedFeatures(e.point)
      const feature = features.find(
        feature => feature.layer.id === 'fn-lang-areas'
      )
      console.log(feature)
      console.log(e.target)
      const bounds = bbox(feature)
      map.fitBounds(bounds, { padding: 30 })
      this.$store.commit('features/set', feature)
      this.$store.commit('sidebar/set', true)

      this.$router.push({
        path: `/languages/${encodeURIComponent(feature.properties.title)}`
      })
    },
    mapLoaded(map) {
      console.log('adding sources')
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
  padding-left: var(-sidebar-width, 350px);
}
</style>
