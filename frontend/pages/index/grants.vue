<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-grants'" active="Grants">
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
        <GrantFilter />
        <section class="pl-3 pr-3 pt-3">
          <Badge
            :content="'Grant Type #1'"
            :number="10"
            class="cursor-pointer"
            type="resource"
            bgcolor="#6c4264"
            :mode="getBadgeStatus(mode, 'lang')"
          ></Badge>
          <Badge
            :content="'Grant Type #2'"
            :number="10"
            class="cursor-pointer"
            type="resource"
            bgcolor="#6c4264"
            :mode="getBadgeStatus(mode, 'lang')"
          ></Badge>
        </section>
      </template>
      <template v-slot:cards>
        <section class="pl-3 pr-3">
          <b-row>
            <b-col
              v-for="(grant, index) in paginatedGrants"
              :key="`grants-item-${index}`"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <GrantsCard
                :grant="grant"
                class="mt-2 hover-left-move"
                @click.native="handleCardClick($event, grant.name)"
              ></GrantsCard>
            </b-col>
          </b-row>
        </section>
      </template>
    </SideBar>

    <div v-else-if="this.$route.name === 'index-grants-grants'">
      <div>
        <nuxt-child />
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import GrantsCard from '@/components/grants/GrantsCard.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC } from '@/plugins/utils.js'
import Badge from '@/components/Badge.vue'
import GrantFilter from '@/components/CardFilter.vue'

export default {
  components: {
    SideBar,
    Filters,
    Accordion,
    GrantsCard,
    Badge,
    GrantFilter
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
      mode: 'All',
      accordionContent:
        'Grants description goes here, Lorem ipsum dolor sit amet consectetur adipisicing elit. Excepturi fugit unde a cupiditate repellat aut quidem consequatur, quisquam labore, ut temporibus libero.',
      maximumLength: 0
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('places/setFilterCategories', [])
    this.$root.$emit('updatePlacesCategory', [])
    next()
  },
  computed: {
    isMobile() {
      return this.$store.state.responsive.isMobileSideBarOpen
    },
    grantsData() {
      return Array(50)
        .fill('')
        .map((data, index) => {
          return {
            name: `Sample Grants-${index}`
          }
        })
    },
    paginatedGrants() {
      return this.grantsData.slice(0, this.maximumLength)
    }
  },
  mounted() {
    this.$eventHub.whenMap(map => {
      this.$root.$emit('mapLoaded')
    })

    this.$eventHub.whenMap(map => {
      this.$root.$emit('toggleMapLayers')
    })

    // Fetches the heritage data, for this case, it renders the page, then rerender if data is collected
    this.$store.commit('sidebar/toggleLoading', true)

    //  Simulate fake fetch API
    setTimeout(() => {
      this.$store.commit('sidebar/toggleLoading', true)
    }, 3000)

    if (this.$route.name === 'index-grants') {
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
    }
  },
  methods: {
    toggleLayer() {
      this.$eventHub.whenMap(map => {
        this.$root.$emit('toggleMapLayers')
      })
    },
    handleCardClick(e, name) {
      this.$router.push({
        path: `/grants/${encodeFPCC(name)}`
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
