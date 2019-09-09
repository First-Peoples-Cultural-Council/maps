<template>
  <SideBar v-if="this.$route.name < 'index-place-names-placename'">
    <template v-slot:content>
      <Filters class="mb-2 mt-2"></Filters>
    </template>
    <template v-slot:badges>
      <section class="pl-3 pr-3 mt-3">
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
      <section class="pl-3 pr-3 mt-3">
        <div v-if="places.length > 0">
          <b-row>
            <b-col
              v-for="(place, index) in places"
              :key="index"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <PlacesCard
                :name="place.properties.name"
                class="mt-3"
                @click.native="
                  $router.push({
                    path: `/place-names/${encodeFPCC(place.properties.name)}`
                  })
                "
              ></PlacesCard>
            </b-col>
          </b-row>
        </div>
        <div v-else>
          <h5>No places are visible on the map</h5>
        </div>
      </section>
    </template>
  </SideBar>
  <div v-else>
    <nuxt-child />
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC } from '@/plugins/utils.js'

export default {
  components: {
    SideBar,
    PlacesCard,
    Badge,
    Filters
  },
  computed: {
    places() {
      return this.$store.state.places.placesSet
    }
  },
  mounted() {
    console.log('placename router', this.$route)
  },
  methods: {
    encodeFPCC
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
