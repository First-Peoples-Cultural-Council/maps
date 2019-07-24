<template>
  <SideBar v-if="this.$route.name < 'index-place-names-placename'">
    <section class="pl-3 pr-3">
      <div v-if="places.length > 0">
        <PlacesCard
          v-for="(place, index) in places"
          :key="index"
          :name="place.properties.name"
          class="mt-3"
          @click.native="
            $router.push({ path: `/place-names/${place.properties.name}` })
          "
        ></PlacesCard>
      </div>
      <div v-else>
        <h5>No places are visible on the map</h5>
      </div>
    </section>
  </SideBar>
  <DetailSideBar v-else>
    <nuxt-child />
  </DetailSideBar>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'

export default {
  components: {
    SideBar,
    PlacesCard,
    DetailSideBar
  },
  computed: {
    places() {
      return this.$store.state.places.placesSet
    }
  },
  mounted() {
    console.log('placename router', this.$route)
  },
  head() {
    return {
      title: `Indigenous Place Names List in British Columbia`,
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `A Full List of Indigenous Place Names used by First Nations of British Columbia, Canada.`
        }
      ]
    }
  }
}
</script>

<style></style>
