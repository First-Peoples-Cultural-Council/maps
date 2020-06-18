<template>
  <div
    class="places-main-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <div
      class="places-card"
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
          Point Of Interest
        </h5>
        <h5 class="field-names">
          {{ place.properties.name }}
        </h5>
      </div>
    </div>

    <div class="action-container">
      <slot name="verify"></slot>
      <slot name="reject"></slot>
    </div>

    <div class="places-card-footer">
      <div class="fpcc-card-more">
        <img v-if="!hover" src="@/assets/images/go_icon_hover.svg" alt="Go" />
        <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
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
    },
    variant: {
      type: String,
      default: 'normal'
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
.places-main-card {
  position: relative;
  border: 1px solid #ebe6dc;
  padding: 0.5em 0em 0 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);

  &:hover {
    border: 1px solid #b57936;

    .fpcc-card-more {
      background-color: #00333a;
    }
  }
}
.places-card {
  display: flex;
  align-items: center;
  width: 100%;
  display: table;
}
.places-card-header {
  display: table-cell;
  vertical-align: middle;
  width: 10%;
}
.places-card-body {
  display: table-cell;

  vertical-align: middle;
  width: 70%;
}
.places-card-footer {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  right: 0;
  top: 0;
  height: 100%;
  width: 15%;

  & > * {
    width: 100%;
  }
}

.fpcc-card-more:hover {
  color: white;
  background-color: #454545;
}

.places-card-white {
  background-color: White;
}
.action-container {
  display: flex;
  flex-wrap: wrap;
  margin-top: 0.5em;

  & > * {
    flex: 0 0 30%;
    margin-right: 0.25em;
    font-size: 0.8em;
  }
}
</style>
