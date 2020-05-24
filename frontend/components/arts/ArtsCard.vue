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
            v-if="kind.toLowerCase() === 'public_art'"
            src="@/assets/images/public_art_icon.svg"
            alt="Public Art"
          />
          <img
            v-else-if="kind.toLowerCase() === 'artist'"
            src="@/assets/images/artist_icon.svg"
            alt="Artist"
          />
          <img
            v-else-if="kind.toLowerCase() === 'organization'"
            src="@/assets/images/organization_icon.svg"
            alt="Organization"
          />
          <img
            v-else-if="kind.toLowerCase() === 'event'"
            src="@/assets/images/events_icon.svg"
            alt="Event"
          />
          <img
            v-else-if="kind.toLowerCase() === 'grant'"
            src="@/assets/images/resource_icon.svg"
            alt="Event"
          />
        </div>
      </template>
      <template v-slot:body>
        <div class="arts-detail-text">
          <div>
            <h5 class="field-kinds">
              {{ kind | kinds }}
            </h5>
            <h5 class="field-names">
              {{ name }}
            </h5>
            <div class="artist-tags-container">
              <span
                v-for="tag in taxonomy"
                :key="tag.name"
                :class="taxonomyClass(tag.name)"
                @click.stop.prevent="filterTaxonomy([tag.name])"
                >{{ tag.name }}</span
              >
            </div>
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
    kinds(d) {
      if (d === 'public_art') {
        return 'Public Art'
      }
      return d
    }
  },
  props: {
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    },
    name: {
      type: String,
      default: ''
    },
    kind: {
      type: String,
      default: ''
    },
    taxonomy: {
      type: Array,
      default: () => {
        return []
      }
    },
    geometry: {
      type: Object,
      default: () => {
        return null
      }
    }
  },
  data() {
    return {
      hover: false,
      blockedTag: ['Person'] // add taxonomy to not show
    }
  },
  computed: {
    taxonomyNotEmpty() {
      return this.taxonomy
    },
    taxonomies() {
      return this.taxonomyNotEmpty
        ? this.art.taxonomy.filter(taxo => !this.blockedTag.includes(taxo.name))
        : []
    },
    taxonomyFilter() {
      return this.$store.state.arts.taxonomyFilter
    }
  },
  methods: {
    filterTaxonomy(filter) {
      // Scroll back to top when clicking taxonomy in the cards
      const desktopContainer = document.querySelector('#sidebar-container')
      const mobileContainer = document.querySelector('#side-inner-collapse')
      desktopContainer.scrollTop = 0
      mobileContainer.scrollTop = 0
      this.$store.commit('arts/setTaxonomyTag', filter)
    },
    taxonomyClass(tag) {
      return this.taxonomyFilter.some(taxonomy => {
        return taxonomy === tag
      })
        ? 'taxonomy-selected'
        : ''
    },
    handleMouseOver() {
      if (this.geometry) {
        this.hover = true
        // in some cases, we list places without full geometry, no marker shown.
        if (!this.geometry) return
        this.$eventHub.revealArea(this.geometry)
      }
    },
    handleMouseLeave() {
      if (this.geometry) {
        this.hover = false
        // in some cases, we list places without full geometry, no marker shown.
        if (!this.geometry) return
        this.$eventHub.doneReveal()
      }
    }
  }
}
</script>

<style lang="scss">
.arts-card {
  cursor: pointer;
  height: 100%;
  padding-top: 0.5em;
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

.taxonomy-selected {
  color: #fff !important;
  background-color: #545b62 !important;

  &:hover {
    background: #ddd4c6 !important;
    color: #707070 !important;
  }
}

.artist-tags-container span {
  cursor: pointer;
  flex: 0 1 auto;
  background: #ddd4c6;
  border-radius: 2rem;
  color: #707070;
  text-transform: uppercase;
  font: Bold 12px Proxima Nova;
  margin: 0.25em 0.5em 0.25em 0;
  padding: 2px 5px;
  text-align: center;

  &:hover {
    color: #fff;
    background-color: #545b62;
  }
}
</style>
