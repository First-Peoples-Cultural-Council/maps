<template>
  <div class="map-container">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :nav-control="NAV_CONTROL"
      :geolocate-control="GEOLOCATE_CONTROL"
      @map-click="handleClick"
    ></Mapbox>
    <SearchBar></SearchBar>
    <NavigationBar></NavigationBar>
    <Languages v-if="'index'"></Languages>
    <nuxt-child v-else />
  </div>
</template>

<script>
import Mapbox from 'mapbox-gl-vue'
import SearchBar from '@/components/SearchBar.vue'
import NavigationBar from '@/components/NavigationBar.vue'
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
        style: 'mapbox://styles/countable-web/cjwcq8ybe06so1cpin5lz5sfj',
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
      }
    }
  },
  methods: {
    handleClick(map, e) {
      console.log(map.queryRenderedFeatures(e.point))
    },
    mapLoaded(map) {
      map.addLayer({
        id: 'fn-lang-areas-fill',
        type: 'fill',
        metadata: {},
        source: 'composite',
        'source-layer': 'langs-0brkvj',
        layout: {},
        paint: {
          'fill-color': ['get', 'color'],
          'fill-opacity': [
            'case',
            ['boolean', ['feature-state', 'hover'], false],
            1,
            0.5
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
