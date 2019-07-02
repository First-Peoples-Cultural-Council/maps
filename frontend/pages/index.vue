<template>
  <div class="map-container" @click="handleClick">
    <Mapbox
      :access-token="MAPBOX_ACCESS_TOKEN"
      :map-options="MAP_OPTIONS"
      :nav-control="NAV_CONTROL"
      :geolocate-control="GEOLOCATE_CONTROL"
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
import Languages from './index/languages.vue'

console.log('Mapbox', Mapbox)
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
        style: 'mapbox://styles/mapbox/streets-v11',
        center: [-74.5, 40],
        zoom: 9
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
  mounted() {
    console.log('Index Mounted')
    console.log('Check Router', this.$route)
  },
  methods: {
    handleClick(e) {
      console.log('Router', this.$router)
      this.$router.push({
        path: 'languages'
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
}
</style>
