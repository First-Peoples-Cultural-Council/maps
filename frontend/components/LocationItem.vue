<template>
  <div class="places-main-card" @click="handleLocation($event, item)">
    <div
      class="places-card "
      :class="{ 'places-card-white': variant == 'white' }"
    >
      <div class="places-card-header">
        <div
          class="community-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/poi_icon.svg" alt="community" />
        </div>
      </div>
      <div class="places-card-body">
        <h5 class="field-kinds">
          {{ item.name }}
        </h5>
        <h5 class="field-names">
          {{ item.description }}
        </h5>
        <b-button
          class="mb-3"
          variant="dark"
          size="sm"
          @click="removeLocation($event, item)"
          >Remove Location</b-button
        >
      </div>

      <div class="places-card-footer">
        <div class="fpcc-card-more">
          <img src="@/assets/images/go_icon_hover.svg" alt="Go" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { zoomToPoint } from '@/mixins/map.js'

export default {
  props: {
    item: {
      type: Object,
      default: () => {
        return {}
      }
    },
    variant: {
      type: String,
      default: 'normal'
    },
    color: {
      type: String,
      default: 'transparent'
    }
  },
  methods: {
    handleLocation(e, sl) {
      this.$store.commit('sidebar/setMobileContent', false)
      this.$eventHub.whenMap(map => {
        zoomToPoint({
          map,
          geom: sl.point,
          zoom: sl.zoom
        })
      })
    },
    async removeLocation(e, sl) {
      const data = {
        favourite: sl
      }
      await this.$store.dispatch('user/removeSavedLocation', data)
    }
  }
}
</script>

<style></style>
