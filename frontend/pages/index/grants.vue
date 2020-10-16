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
        <span class="field-kinds pl-3 pr-3 pt-3">GRANT CATEGORY</span>
        <section class="badge-list-container pl-3 pr-3 pt-3">
          <BadgeFilter
            v-for="badge in grantBadges"
            :key="`badge-grant-${badge.name}`"
            class="mt-2 cursor-pointer"
            :color="badge.color"
            :child-taxonomy="getChildCategory(badge.name)"
            :is-selected="filterMode === badge.name.toLowerCase()"
            :filter-type="'grants'"
          >
            <template v-slot:badge>
              <Badge
                :content="badge.name"
                :number="getCountValues(badge.name.toLowerCase())"
                :bgcolor="badge.color"
                :mode="getBadgeStatus(filterMode, badge.name.toLowerCase())"
                @click.native.prevent="
                  badgeClick($event, badge.name.toLowerCase())
                "
              ></Badge>
            </template>
          </BadgeFilter>
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
              md="12"
              sm="12"
              class="mt-3 hover-left-move"
            >
              <GrantsCard
                :grant="grant"
                :is-selected="currentGrant && currentGrant.id === grant.id"
                @click.native="handleCardClick($event, grant)"
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
import Filters from '@/components/grants/GrantsFilter.vue'
import { zoomToPoint } from '@/mixins/map.js'
import { makeMarker } from '@/plugins/utils.js'
import Badge from '@/components/Badge.vue'
import BadgeFilter from '@/components/BadgeFilter.vue'

export default {
  components: {
    SideBar,
    Filters,
    Accordion,
    GrantsCard,
    Badge,
    BadgeFilter
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
        "The First Peoples' Council Arts Program delivers funding to emerging Aboriginal and First Nations artists, arts organizations and collectives...expand expancommunities. Grants support projects that contribute to professional and creative development in all artistic disciplines, and to the vitality of traditionally based art practices and related knowledge. There are five distinct categories: Individual Emerging ArtistS; Organizations and Collectives; Sharing Traditional Arts Across the Generations; Arts Administrator Internships; and Aboriginal Youth Engaged in the Arts. Filter by Grant category and Award year and hit Apply. Pan, zoom and click to find each grant recipient. Enjoy.",
      maximumLength: 0,
      grantBadges: [
        {
          id: 1,
          name: 'Arts',
          color: '#3185CE'
        },
        {
          id: 2,
          name: 'Heritage',
          color: '#4FA89D',
          mode: 'grants'
        },
        {
          id: 3,
          name: 'Language',
          color: '#D42433'
        }
      ]
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$emit('resetMap')
    next()
  },
  computed: {
    isMobile() {
      return this.$store.state.responsive.isMobileSideBarOpen
    },
    grants() {
      return this.$store.state.grants.grantsGeo
    },
    grantsTypeList() {
      return this.grants.filter(grant => {
        return (
          grant.properties.category &&
          this.getCategoryId(grant.properties.category).parent ===
            this.getCategoryId(this.filterMode).id
        )
      })
    },
    getGrantList() {
      //  if year filtermode is activated
      if (this.getGrantsDateFilter || this.getCategoryFilterList.length !== 0) {
        const { fromDate, toDate } = this.getGrantsDateFilter
        const finalGrants = this.grantsTypeList.filter(grant => {
          const isCategoryFound = this.getCategoryFilterList.some(
            tag => tag.toLowerCase() === grant.properties.category.toLowerCase()
          )
          return grant.properties.year <= toDate &&
            grant.properties.year >= fromDate &&
            this.getCategoryFilterList.length !== 0
            ? isCategoryFound
            : true
        })

        return finalGrants
      } else {
        return this.grantsTypeList
      }
    },
    paginatedGrants() {
      return this.getGrantList.slice(0, this.maximumLength)
    },
    getGrantsDateFilter() {
      return this.$store.state.grants.filterDate
    },
    categoryList() {
      return this.$store.state.grants.categorySearchSet
    },
    currentGrant() {
      return this.$store.state.grants.currentGrant
    },

    filterMode() {
      return this.$store.state.grants.grantFilterMode
    },
    getCategoryFilterList() {
      return this.$store.state.grants.grantCategoryList
    }
  },
  created() {
    this.$root.$emit('resetMap')
  },
  mounted() {
    console.log(this.categoryList)
    this.$eventHub.whenMap(map => {
      this.$root.$emit('mapLoaded')
    })

    this.$eventHub.whenMap(map => {
      this.$root.$emit('toggleMapLayers')
    })

    this.$store.commit('sidebar/toggleLoading', true)

    setTimeout(() => {
      this.$store.commit('sidebar/toggleLoading', false)
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
            if (this.getGrantList.length > this.maximumLength) {
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
    handleCardClick(e, grant) {
      // Unselect the current selected grant item
      if (this.currentGrant && this.currentGrant.id === grant.id) {
        this.$store.commit('grants/setCurrentGrant', null)
        this.$root.$emit('resetMap')
      } else {
        this.$store.commit('grants/setCurrentGrant', grant)
        this.setupMap(grant)
      }
    },
    loadMoreData() {
      this.$store.commit('sidebar/toggleLoading', true)
      setTimeout(() => {
        this.maximumLength += 16
        this.$store.commit('sidebar/toggleLoading', false)
      }, 250)
    },
    getCategoryId(name) {
      return this.categoryList.find(
        category => category.name.toLowerCase() === name.toLowerCase()
      )
    },
    getChildCategory(name) {
      return this.categoryList.filter(
        category => category.parent === this.getCategoryId(name).id
      )
    },

    getCountValues(type) {
      return (this.getGrantsDateFilter || this.categoryList) &&
        this.filterMode === type
        ? this.filterArray(this.getGrantList, type)
        : this.filterArray(this.grants, type)
    },
    filterArray(grantArray, type) {
      return grantArray.filter(
        category =>
          category.properties.category &&
          this.getCategoryId(category.properties.category).parent ===
            this.getCategoryId(type).id
      ).length
    },
    badgeClick($event, name) {
      this.maximumLength = 7
      this.handleBadge($event, name)
    },
    setupMap(grant) {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          if (grant.geometry)
            zoomToPoint({ map, geom: grant.geometry, zoom: 11 })
        }
        if (grant.geometry) {
          const icon = 'artist_icon.svg'
          makeMarker(grant.geometry, icon, 'grant-marker').addTo(map)
        }
      })
    }
  }
}
</script>
<style></style>
