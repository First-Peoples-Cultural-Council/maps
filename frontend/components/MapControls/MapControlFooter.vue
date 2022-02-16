<template>
  <div v-if="$route.path !== '/splashscreen'" class="map-controls-overlay">
    <Zoom class="zoom-control mr-2" :class="{ 'hide-mobile': !isEmbed }"></Zoom>
    <ResetMap
      class="reset-map-control mr-2"
      :class="{ 'hide-mobile': !isEmbed }"
    ></ResetMap>
    <CurrentLocation
      class="current-location-control mr-2"
      :class="{ 'hide-mobile': !isEmbed }"
    ></CurrentLocation>
    <ShareEmbed
      v-if="!isEmbed"
      class="share-embed-control hide-mobile mr-2"
    ></ShareEmbed>
    <SaveLocation
      v-if="isLoggedIn && !isEmbed"
      class="share-embed-control mr-2"
    ></SaveLocation>
    <Contribute class="contribute-control mr-2"></Contribute>
  </div>
</template>

<script>
import Zoom from '@/components/Zoom.vue'
import ResetMap from '@/components/ResetMap.vue'
import CurrentLocation from '@/components/CurrentLocation.vue'
import ShareEmbed from '@/components/ShareEmbed.vue'
import SaveLocation from '@/components/SaveLocation.vue'
import Contribute from '@/components/Contribute.vue'

export default {
  components: {
    Zoom,
    ResetMap,
    CurrentLocation,
    ShareEmbed,
    SaveLocation,
    Contribute
  },

  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    }
  }
}
</script>

<style></style>
