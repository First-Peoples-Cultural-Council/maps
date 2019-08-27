<template>
  <div class="place-names-dynamic-container">
    <DetailSideBar>
      <template v-slot:badges>
        <h5 class="color-gray font-08 p-0 m-0 d-none header-mobile">
          Point Of Interest:
          <span class="font-weight-bold">{{ place.properties.name }}</span>
        </h5>
      </template>
      <div>
        <PlacesDetailCard
          :id="place.id"
          :name="place.properties.name"
          :server="isServer"
          :audio-file="place.properties.audio_file"
        ></PlacesDetailCard>
        <hr class="sidebar-divider" />
        <Filters class="mb-2"></Filters>
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import PlacesDetailCard from '@/components/places/PlacesDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import { getApiUrl, encodeFPCC } from '@/plugins/utils.js'

export default {
  components: {
    PlacesDetailCard,
    Filters,
    DetailSideBar
  },
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    }
  },
  watch: {
    place(newPlace, oldPlace) {
      if (newPlace !== oldPlace) this.setupMap()
    }
  },
  async asyncData({ params, $axios, store }) {
    const places = (await $axios.$get(getApiUrl('placename-geo/'))).features
    const place = places.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.placename
      }
    })

    const isServer = !!process.server
    return {
      place,
      isServer
    }
  },
  created() {
    this.setupMap()
    // We don't always catch language routing updates, so also zoom to language on create.
  },
  mounted() {
    console.log('Mounted')
  },
  methods: {
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          zoomToPoint({ map, geom: this.place.geometry, zoom: 13 })
        }
        map.setFilter('fn-places-highlighted', [
          '==',
          'name',
          this.place.properties.name
        ])
      })
    }
  }
}
</script>
<style></style>
