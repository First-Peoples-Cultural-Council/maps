<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-heritages'" active="Heritage">
      <template v-slot:content>
        <section class="pl-3 pr-3 mt-3">
          <Accordion :content="accordionContent"></Accordion>
        </section>
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
                class="mt-3 hover-left-move"
                @click.native="
                  $router.push({
                    path: `/place-names/${encodeURIComponent(
                      place.properties.name
                    )}`
                  })
                "
              ></PlacesCard>
            </b-col>
          </b-row>
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
import Accordion from '@/components/Accordion.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    SideBar,
    DetailSideBar,
    PlacesCard,
    Badge,
    Filters,
    Accordion
  },
  data() {
    return {
      accordionContent:
        'Indigenous Peoples within B.C. live in exceptionally diverse territories that are intrinsically linked to their cultural heritage, which can include ideas, experiences, worldviews, objects, forms of expression, practices, knowledge, spirituality, kinship ties and places. To learn more about Indigenous cultural heritage places, you can access the indexes through the top navigation of all pages of this website.'
    }
  },
  computed: {
    places() {
      return this.$store.state.places.places
    }
  }
}
</script>
<style></style>
