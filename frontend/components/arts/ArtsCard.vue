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
            v-if="art.properties.kind.toLowerCase() === 'public_art'"
            src="@/assets/images/public_art_icon.svg"
            alt="Public Art"
          />
          <img
            v-else-if="art.properties.kind.toLowerCase() === 'artist'"
            src="@/assets/images/artist_icon.svg"
            alt="Artist"
          />
          <img
            v-else-if="art.properties.kind.toLowerCase() === 'organization'"
            src="@/assets/images/organization_icon.svg"
            alt="Organization"
          />
          <img
            v-else-if="art.properties.kind.toLowerCase() === 'event'"
            src="@/assets/images/event_icon.svg"
            alt="Event"
          />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              {{ art.properties.kind | kind }}
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold art-name">
              {{ art.properties.name }}
            </h5>
          </div>
          <div class="artist-tags-container">
            <span v-for="tag in art.properties.taxonomies" :key="tag.name">{{
              tag.name
            }}</span>
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
    kind(d) {
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
  mounted() {
    // console.log('CARD DATA', this.art)
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
  height: 30px;
  width: 30px;
}
.arts-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #b47a2b;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: #00333a;
}
.arts-card-text {
  position: relative;
  right: 10px;
}
.artist-tags-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
  align-items: center;
}

.artist-tags-container span {
  flex: 0 1 auto;
  background: #ddd4c6;
  border-radius: 2rem;
  color: #707070;
  text-transform: uppercase;
  font-weight: 800;
  font-size: 0.6em;
  margin: 0.25em 0.5em 0.25em 0;
  padding: 2px 5px;
  text-align: center;
}
</style>
