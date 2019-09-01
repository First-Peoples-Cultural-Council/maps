<template>
  <div class="place-names-dynamic-container">
    <DetailSideBar>
      <template v-slot:badges>
        <h5 class="color-gray font-08 p-0 m-0 d-none header-mobile">
          Point Of Interest:
          <span class="font-weight-bold">{{ place.name }}</span>
        </h5>
      </template>
      <div>
        <PlacesDetailCard
          :id="place.id"
          :name="place.name"
          :server="isServer"
          :audio-file="place.audio_file"
        ></PlacesDetailCard>
        <hr class="sidebar-divider" />
        <Filters class="mb-2"></Filters>
      </div>
      <p>
        {{ place.description }}
      </p>
      <p v-if="place.creator">
        uploaded by
        <nuxt-link class="color-gray" :to="'/profile/' + place.creator.id">{{
          getCreatorName()
        }}</nuxt-link>
      </p>
      <button v-if="uid === place.creator.id" class="btn" @click="edit">
        Edit
      </button>
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
    },
    uid() {
      const user = this.$store.state.user.user
      return user && user.id
    }
  },
  watch: {
    place(newPlace, oldPlace) {
      if (newPlace !== oldPlace) this.setupMap()
    }
  },
  async asyncData({ params, $axios, store }) {
    // TODO: it's better to call /placename_by_name or something (new back-end api)
    const now = new Date()
    const places = (await $axios.$get(
      getApiUrl('placename-geo/?timestamp=' + now.getTime())
    )).features
    const geo_place = places.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.placename
      }
    })

    const place = await $axios.$get(getApiUrl(`placename/${geo_place.id}/`))
    const isServer = !!process.server
    return {
      geo_place,
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
          zoomToPoint({ map, geom: this.geo_place.geometry, zoom: 13 })
        }
        map.setFilter('fn-places-highlighted', ['==', 'name', this.place.name])
      })
    },
    getCreatorName() {
      return (
        this.place.creator.first_name ||
        this.place.creator.username.split('__')[0]
      )
    },
    edit() {
      this.$router.push('/contribute?id=' + this.place.id)
    }
  },
  head() {
    return {
      title: this.place.name,
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.place.description
        }
      ]
    }
  }
}
</script>
<style></style>
