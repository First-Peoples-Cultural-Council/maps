<template>
  <div
    class="arts-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card>
      <template v-slot:header>
        <div class="arts-icon-container" :style="'background-color:' + color">
          <img
            v-if="art.properties.art_type.toLowerCase() === 'public_art'"
            src="@/assets/images/public_art_icon.svg"
            alt="Public Art"
          />
          <img
            v-else-if="art.properties.art_type.toLowerCase() === 'artist'"
            src="@/assets/images/artist_icon.svg"
            alt="Artist"
          />
          <img
            v-else-if="art.properties.art_type.toLowerCase() === 'organization'"
            src="@/assets/images/organization_icon.svg"
            alt="Organization"
          />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              {{ art.properties.art_type | art_type }}
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold">
              {{ art.properties.name }}
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
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
export default {
  components: {
    Card
  },
  filters: {
    art_type(d) {
      if (d === 'public_art') {
        return 'Public Art'
      }
      return d
    }
  },
  props: {
    art: {
      type: Object,
      default: () => {
        return {}
      }
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
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
      if (!this.art.geometry) return
      this.$eventHub.revealArea(this.art.geometry)
    },
    handleMouseLeave() {
      this.hover = false
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.art.geometry) return
      this.$eventHub.doneReveal()
    }
  }
}
</script>

<style>
.arts-card {
  cursor: pointer;
}
.arts-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.arts-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #c46156;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: #454545;
}
</style>
