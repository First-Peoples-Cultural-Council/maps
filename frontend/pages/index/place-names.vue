<template>
  <SideBar active="Language">
    <section class="ml-2 mr-2">
      <div v-if="places.length > 0">
        <PlacesCard
          v-for="(place, index) in places"
          :key="index"
          :name="place.properties.title"
          class="mt-2"
        ></PlacesCard>
      </div>
      <div v-else>
        <h5>No places are visible on the map</h5>
      </div>
    </section>
  </SideBar>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
export default {
  components: {
    SideBar,
    PlacesCard
  },
  computed: {
    places() {
      return this.$store.state.places.places
    }
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
