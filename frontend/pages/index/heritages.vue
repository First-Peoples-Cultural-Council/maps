<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-heritages'" active="Heritages">
      <section class="pl-3 pr-3 pt-2">
        <PlacesCard
          v-for="(place, index) in places"
          :key="index"
          :name="place.properties.name"
          class="mt-3"
          @click.native="
            $router.push({
              path: `/place-names/${encodeURIComponent(place.properties.name)}`
            })
          "
        ></PlacesCard>
      </section>
    </SideBar>
    <DetailSideBar
      v-else-if="this.$route.name === 'index-heritages-heritage'"
      :width="detailOneWidth"
    >
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'

export default {
  components: {
    SideBar,
    DetailSideBar,
    PlacesCard
  },
  computed: {
    places() {
      return this.$store.state.places.places
    }
  }
}
</script>
<style></style>
