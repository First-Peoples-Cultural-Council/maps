<template>
  <div
    class="community-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card>
      <template v-slot:header>
        <div
          class="community-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/poi_icon.svg" alt="community" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              Point Of Interest
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold place-name">
              {{ place.properties.name }}
            </h5>
          </div>
        </div>
      </template>
      <template v-slot:footer>
        <div class="fpcc-card-more">
          <img v-if="!hover" src="@/assets/images/go_icon_hover.svg" alt="Go" />
          <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
        </div>
      </template>
    </Card>
    <div class="action-container">
      <slot name="verify"></slot>
      <slot name="reject"></slot>
    </div>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'

export default {
  components: {
    Card
  },
  props: {
    place: {
      type: Object,
      default: () => {
        return { properties: {} }
      }
    },
    color: {
      type: String,
      default: 'transparent'
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {
    handleMouseOver() {
      this.hover = true
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.place.geometry) return
      // TODO: we need a centroid in this case.
      if (this.place.geometry.coordinates.length > 2) return
      this.$eventHub.revealArea(this.place.geometry)
    },
    handleMouseLeave() {
      this.hover = false
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.place.geometry) return
      // TODO: we need a centroid in this case.
      if (this.place.geometry.coordinates.length > 2) return
      this.$eventHub.doneReveal()
    }
  }
}
</script>

<style lang="scss">
.action-container {
  display: flex;
  flex-wrap: wrap;

  & > * {
    flex: 0 0 30%;
    margin-right: 0.25em;
    font-size: 0.8em;
  }
}
</style>
