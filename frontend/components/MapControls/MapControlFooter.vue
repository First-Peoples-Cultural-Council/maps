<template>
  <div
    v-if="$route.path !== '/splashscreen' && !isEmbed"
    class="map-controls-overlay"
  >
    <div v-if="$route.path !== '/page/how-to-use'" class="help-icon">
      <nuxt-link to="/page/how-to-use">
        <img src="@/assets/images/help-icon.png" alt="Help" width="15px"
      /></nuxt-link>
    </div>
    <Zoom class="zoom-control mr-2 hide-mobile"></Zoom>
    <ResetMap class="reset-map-control mr-2 hide-mobile"></ResetMap>
    <CurrentLocation class="current-location-control mr-2"></CurrentLocation>
    <ShareEmbed class="share-embed-control mr-2 hide-mobile"></ShareEmbed>
    <SaveLocation
      v-if="isLoggedIn"
      class="share-embed-control mr-2"
    ></SaveLocation>

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

export default {
  components: {
    Zoom,
    ResetMap,
    CurrentLocation,
    ShareEmbed,
    SaveLocation,
    AddToTheMap
  },

  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    }
  }
}
</script>

<style>
.help-icon {
  background-color: #fff;
  border: 1px solid #ddd5cc;
  cursor: pointer;
  padding: 0.5em 0.75em;
  margin-right: auto;
  margin-left: 2.5em;
  display: flex;
  align-content: center;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 15px;
  text-transform: uppercase;
}
</style>
