<template>
  <div>
    <ArtsDetailCard
      :arttype="art.properties.type"
      :name="art.properties.title"
    ></ArtsDetailCard>
    <LanguageSeeAll
      content="See all details"
      class="mt-3"
      @click.native="handleClick($event, art.properties.node_id)"
    >
    </LanguageSeeAll>
  </div>
</template>

<script>
import ArtsDetailCard from '@/components/arts/ArtsDetailCard.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { zoomToPoint } from '@/mixins/map.js'

export default {
  components: {
    ArtsDetailCard,
    LanguageSeeAll
  },
  async asyncData({ params, $axios, store }) {
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const arts = (await $axios.$get(getApiUrl('arts'))).features
    const art = arts.find(a => {
      if (a.properties.title) {
        return a.properties.title.toLowerCase() === params.art.toLowerCase()
      }
    })
    return {
      art
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      zoomToPoint({ map: map, geom: this.art.geometry })
    })
  },
  methods: {
    handleClick(e, data) {
      window.open(`https://fp-artsmap.ca/node/${data}`)
    }
  }
}
</script>
<style></style>
