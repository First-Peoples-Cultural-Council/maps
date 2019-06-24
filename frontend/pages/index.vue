<template>
  <div class="map-container">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :nav-control="NAV_CONTROL"
      :geolocate-control="GEOLOCATE_CONTROL"
    ></Mapbox>
  </div>
</template>

<script>
import MapboxGL from 'mapbox-gl'
import {} from '../node_modules/mapbox-gl/dist/mapbox-gl.css'
import Mapbox from 'mapbox-gl-vue'

console.log('Mapbox', Mapbox)
console.log('MapboxGL', MapboxGL)
export default {
  components: {
    Mapbox
  },

  data() {
    return {
      MAPBOX_ACCESS_TOKEN:
        'pk.eyJ1IjoiY291bnRhYmxlLXdlYiIsImEiOiJjamQyZG90dzAxcmxmMndtdzBuY3Ywa2ViIn0.MU-sGTVDS9aGzgdJJ3EwHA',
      MAP_OPTIONS: {
        style: 'mapbox://styles/mapbox/streets-v11',
        center: [-74.5, 40],
        zoom: 9
      },
      NAV_CONTROL: {
        show: true,
        position: 'top-right'
      },
      GEOLOCATE_CONTROL: {
        show: true,
        position: 'top-left'
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
}
</style>
