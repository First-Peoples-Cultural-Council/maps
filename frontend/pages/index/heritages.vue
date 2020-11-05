<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-heritages'" active="Heritage">
      <template v-slot:content>
        <section class="pl-3 pr-3 mt-3">
          <Accordion
            class="no-scroll-accordion"
            :content="accordionContent"
          ></Accordion>
          <button
            id="btn-heritage-grants"
            class="btn-grant-redirect"
            @click="goToGrants('heritage')"
          >
            Heritage Grants Recipients
          </button>
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
                class="mt-2 hover-left-move"
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
  head() {
    return {
      meta: [
        {
          name: 'google-site-verification',
          content: 'wWf4WAoDmF6R3jjEYapgr3-ymFwS6o-qfLob4WOErRA'
        }
      ]
    }
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
  async mounted() {
    // Fetches the heritage data, for this case, it renders the page, then rerender if data is collected
    this.$store.commit('sidebar/toggleLoading', true)
    const currentPlaces = this.$store.state.places.places

    if (currentPlaces.length === 0) {
      const heritage = await this.$axios.$get(
        getApiUrl(`placename-geo?timestamp=${new Date().getTime()}/`)
      )
      if (heritage) {
        // Set Heritage stores
        this.$store.commit('places/set', heritage.features)
        this.$store.commit('places/setStore', heritage.features)
        this.$store.commit('sidebar/toggleLoading', false)
      } else {
        this.$store.commit('sidebar/toggleLoading', true)
      }
    }

    // Trigger addeventlistener only if there's Sidebar, used for Pagination
    const mobileContainer = document.querySelector('#side-inner-collapse')
    const desktopContainer = document.querySelector('#sidebar-container')

    const containerArray = [mobileContainer, desktopContainer]

    containerArray.forEach(elem => {
      elem.addEventListener('scroll', e => {
        if (
          elem.scrollTop + elem.clientHeight >= elem.scrollHeight &&
          elem.scrollTop !== 0
        ) {
          if (this.places.length > this.maximumLength) {
            this.loadMoreData()
          }
        }
      })
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
<style>
#btn-heritage-grants {
  background-color: #6d4264;
}
</style>
