<template>
  <div>
    <PlacesDetailCard :name="place.properties.name"></PlacesDetailCard>
  </div>
</template>

<script>
import PlacesDetailCard from '@/components/places/PlacesDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'

export default {
  components: {
    PlacesDetailCard
  },
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    }
  },
  watch: {
    place(newPlace, oldPlace) {
      if (newPlace !== oldPlace)
        this.$eventHub.whenMap(map => {
          zoomToPoint({ map: map, geom: this.place.geometry })
        })
    }
  },
  async asyncData({ params, $axios, store }) {
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const places = (await $axios.$get(getApiUrl('placename-geo/'))).features
    const place = places.find(a => {
      if (a.properties.name) {
        return (
          a.properties.name.toLowerCase() === params.placename.toLowerCase()
        )
      }
    })
    return {
      place
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      zoomToPoint({ map: map, geom: this.place.geometry })
    })
  },
  mounted() {
    console.log('Mounted')
  }
}
</script>
<style></style>
