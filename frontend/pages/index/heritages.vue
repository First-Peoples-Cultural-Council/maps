<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-heritages'" active="Heritage">
      <template v-slot:content>
        <section class="pl-3 pr-3 mt-3">
          <Accordion
            class="no-scroll-accordion"
            :content="accordionContent"
          ></Accordion>
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
              v-for="(place, index) in paginatedPlaces"
              :key="index"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <PlacesCard
                :place="place"
                class="mt-3 hover-left-move"
                @click.native="handleCardClick($event, place.properties.name)"
              ></PlacesCard>
            </b-col>
          </b-row>
        </section>
      </template>
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC, getApiUrl } from '@/plugins/utils.js'

export default {
  components: {
    SideBar,
    PlacesCard,
    Badge,
    Filters,
    Accordion
  },
  data() {
    return {
      selected: [],
      accordionContent:
        'Indigenous Peoples within B.C. live in exceptionally diverse territories that are intrinsically linked to their cultural heritage, which can include ideas, experiences, worldviews, objects, forms of expression, practices, knowledge, spirituality, kinship ties and places. To learn more about Indigenous cultural heritage places, you can access the indexes through the top navigation of all pages of this website.',
      maximumLength: 0
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('places/setFilterCategories', [])
    this.$root.$emit('updatePlacesCategory', [])
    next()
  },
  computed: {
    places() {
      return this.$store.state.places.places
    },
    paginatedPlaces() {
      return this.places.slice(0, this.maximumLength)
    },
    isMobile() {
      return this.$store.state.responsive.isMobileSideBarOpen
    }
  },
  async fetch({ $axios, store }) {
    const currentPlaces = store.state.places.places

    if (currentPlaces.length === 0) {
      // Fetch languages and communites data
      const heritage = await $axios.$get(
        getApiUrl(`placename-geo?timestamp=${new Date().getTime()}/`)
      )

      // Set Heritage stores
      store.commit('places/set', heritage.features)
      store.commit('places/setStore', heritage.features)
    }
  },
  mounted() {
    const listElm = this.isMobile
      ? document.querySelector('#side-inner-collapse')
      : document.querySelector('#sidebar-container')
    listElm.addEventListener('scroll', e => {
      if (listElm.scrollTop + listElm.clientHeight >= listElm.scrollHeight) {
        if (this.places.length > this.maximumLength) {
          this.loadMoreData()
        }
      }
    })
    this.loadMoreData()
  },
  methods: {
    handleCardClick(e, name) {
      this.$router.push({
        path: `/place-names/${encodeFPCC(name)}`
      })
    },
    loadMoreData() {
      this.$store.commit('sidebar/toggleLoading', true)
      setTimeout(() => {
        this.maximumLength += 16
        this.$store.commit('sidebar/toggleLoading', false)
      }, 250)
    }
  }
}
</script>
<style></style>
