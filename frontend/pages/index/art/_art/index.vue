<template>
  <DetailSideBar>
    <template v-slot:badges>
      <h5 class="color-gray font-08 p-0 m-0">
        {{ art.properties.art_type | titleCase }}:
        <span class="font-weight-bold">{{ art.properties.name }}</span>
      </h5>
    </template>
    <div>
      <ArtsDetailCard
        :arttype="art.properties.art_type"
        :name="art.properties.name"
        :server="isServer"
      ></ArtsDetailCard>
      <p class="pl-4 mt-3 color-gray font-08" v-html="artDetails.details"></p>
      <LanguageSeeAll
        content="See all details"
        class="mt-3"
        @click.native="handleClick($event, artDetails.node_id)"
      >
      </LanguageSeeAll>
      <Filters class="mb-2 mt-2"></Filters>
    </div>
  </DetailSideBar>
</template>

<script>
import { startCase } from 'lodash'
import ArtsDetailCard from '@/components/arts/ArtsDetailCard.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import { getApiUrl } from '@/plugins/utils.js'

export default {
  components: {
    ArtsDetailCard,
    LanguageSeeAll,
    Filters,
    DetailSideBar
  },
  filters: {
    titleCase(str) {
      return startCase(str)
    }
  },
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    }
  },
  watch: {
    art(newArt, oldArt) {
      if (newArt !== oldArt) {
        this.setupMap()
      }
    }
  },
  async asyncData({ params, $axios, store }) {
    const arts = (await $axios.$get(getApiUrl('arts'))).features
    const art = arts.find(a => {
      if (a.properties.name) {
        return a.properties.name.toLowerCase() === params.art.toLowerCase()
      }
    })
    console.log('art', art, params.art.toLowerCase())
    const artDetails = await $axios.$get(getApiUrl('art/' + art.id))

    const isServer = !!process.server
    return {
      art,
      isServer,
      artDetails
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.setupMap()
  },
  methods: {
    handleClick(e, data) {
      window.open(`https://fp-artsmap.ca/node/${data}`)
    },
    setupMap() {
      this.$eventHub.whenMap(map => {
        const mapboxgl = require('mapbox-gl')

        this.$eventHub.whenMap(map => {
          if (this.$route.hash.length <= 1) {
            zoomToPoint({ map, geom: this.art.geometry, zoom: 11 })
          }
          const el = document.createElement('div')
          el.className = 'marker'
          el.style =
            "background-image: url('/_nuxt/assets/images/" +
            this.art.properties.art_type +
            "_icon.svg')"

          new mapboxgl.Marker(el)
            .setLngLat(this.art.geometry.coordinates)
            .addTo(map)
        })
      })
    }
  }
}
</script>
<style></style>
