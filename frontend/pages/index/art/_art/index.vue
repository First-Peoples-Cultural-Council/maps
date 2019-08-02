<template>
  <div>
    <ArtsDetailCard
      :arttype="art.properties.art_type"
      :name="art.properties.name"
      :server="isServer"
    ></ArtsDetailCard>
    <LanguageSeeAll
      content="See all details"
      class="mt-3"
      @click.native="handleClick($event, art.properties.node_id)"
    >
    </LanguageSeeAll>
    <Filters class="mb-4 mt-2"></Filters>
  </div>
</template>

<script>
import ArtsDetailCard from '@/components/arts/ArtsDetailCard.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    ArtsDetailCard,
    LanguageSeeAll,
    Filters
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
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const arts = (await $axios.$get(getApiUrl('arts'))).features
    const art = arts.find(a => {
      if (a.properties.name) {
        return a.properties.name.toLowerCase() === params.art.toLowerCase()
      }
    })

    const isServer = !!process.server
    return {
      art,
      isServer
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
        zoomToPoint({ map, geom: this.art.geometry, zoom: 17 })
        console.log(this.art, 'is the art')
        map.setLayoutProperty('fn-arts-clusters', 'visibility', 'none')
        map.setFilter('fn-arts-highlighted', [
          '==',
          'name',
          this.art.properties.name
        ])
      })
    }
  }
}
</script>
<style></style>
