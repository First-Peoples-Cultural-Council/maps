<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-heritages'" active="Heritage">
      <template v-slot:content>
        <hr class="sidebar-divider" />
        <Filters class="mb-2"></Filters>
      </template>
      <template v-slot:badges>
        <section class="pl-3 pr-3 pt-3">
          <Badge
            content="Points Of Interest"
            :number="places.length"
            class="cursor-pointer mb-1"
            bgcolor="#c46156"
            type="poi"
          ></Badge>
        </section>
      </template>
      <template v-slot:cards>
        <section class="pl-3 pr-3">
          <PlacesCard
            v-for="(place, index) in places"
            :key="index"
            :name="place.properties.name"
            class="mt-3 hover-left-move"
            @click.native="
              $router.push({
                path: `/place-names/${encodeURIComponent(
                  place.properties.name
                )}`
              })
            "
          ></PlacesCard>
        </section>
      </template>
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
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    SideBar,
    DetailSideBar,
    PlacesCard,
    Badge,
    Filters
  },
  computed: {
    places() {
      return this.$store.state.places.places
    }
  }
}
</script>
<style></style>
