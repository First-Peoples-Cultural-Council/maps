<template>
  <div
    v-if="$route.path !== '/splashscreen' && !isEmbed"
    class="map-controls-overlay"
  >
    <Zoom class="zoom-control mr-2 hide-mobile"></Zoom>
    <ResetMap class="reset-map-control mr-2 hide-mobile"></ResetMap>
    <CurrentLocation class="current-location-control mr-2"></CurrentLocation>
    <ShareEmbed class="share-embed-control mr-2 hide-mobile"></ShareEmbed>
    <SaveLocation
      v-if="isLoggedIn"
      class="share-embed-control mr-2"
    ></SaveLocation>
    <Overlap class="mr-2" />
    <AddToTheMap class="contribute-control mr-2"></AddToTheMap>
  </div>
</template>

<script>
import Zoom from '@/components/Zoom.vue'
import ResetMap from '@/components/ResetMap.vue'
import CurrentLocation from '@/components/CurrentLocation.vue'
import ShareEmbed from '@/components/ShareEmbed.vue'
import SaveLocation from '@/components/SaveLocation.vue'
import AddToTheMap from '@/components/AddToTheMap.vue'
import Overlap from '@/components/Overlap.vue'

export default {
  components: {
    Zoom,
    ResetMap,
    CurrentLocation,
    ShareEmbed,
    SaveLocation,
    AddToTheMap,
    Overlap
  }
}
</script>

<style></style>
