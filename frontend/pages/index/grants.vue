<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-grants'" active="Grants">
      <template v-slot:content>
        <div class="grants-header">
          <img src="@/assets/images/graph_background_grants.svg" />
          <span class="title">Grants</span>
          <div class="grant-header-more" @click.prevent="handleReturn">
            <img class="ml-1" src="@/assets/images/return_icon_hover.svg" />
            <span class="ml-1 font-weight-bold">Return</span>
          </div>
        </div>
        <section class="pl-3 pr-3 mt-3">
          <Accordion
            class="no-scroll-accordion"
            :content="accordionContent"
          ></Accordion>
        </section>
        <hr class="sidebar-divider" />
        <GrantFilter :max-date="getMaxDate" :min-date="getMinDate" class="mb-2">
          <template v-slot:badge-filter>
            <span class="sidebar-title">FPCC Departments</span>
            <section class="badge-list-container mt-3">
              <BadgeFilter
                v-for="badge in grantBadges"
                :key="`badge-grant-${badge.name}`"
                class="mt-2 cursor-pointer"
                :color="badge.color"
                :child-taxonomy="badge.id ? getChildCategory(badge.name) : []"
                :is-selected="filterMode === badge.name.toLowerCase()"
                :filter-type="'grants'"
              >
                <template v-slot:badge>
                  <Badge
                    :content="badge.name === 'All' ? 'All Grants' : badge.name"
                    :number="
                      badge.name === 'All'
                        ? getGrantList.length
                        : getCountValues(badge.name.toLowerCase())
                    "
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
        </GrantFilter>
      </template>
      <template v-slot:badges>
        <CardFilter class="mt-3 mb-3" :mode="'grants'" />
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
                :parent-tag-object="getParentTag(grant)"
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
import GrantFilter from '@/components/grants/GrantsFilter.vue'
import { zoomToPoint } from '@/mixins/map.js'
import { makeMarker } from '@/plugins/utils.js'
import Badge from '@/components/Badge.vue'
import BadgeFilter from '@/components/BadgeFilter.vue'
import CardFilter from '@/components/CardFilter.vue'

export default {
  components: {
    SideBar,
    GrantFilter,
    Accordion,
    GrantsCard,
    Badge,
    BadgeFilter,
    CardFilter
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
          name: 'All',
          color: '#99281C'
        },
        {
          id: 1,
          name: 'Arts',
          color: '#00333A'
        },
        {
          id: 2,
          name: 'Heritage',
          color: '#9D3D22',
          mode: 'grants'
        },
        {
          id: 3,
          name: 'Language',
          color: '#B47A2B'
        }
      ]
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$emit('resetMap')
    this.resetGrantFilter()
    next()
  },
  computed: {
    grantsSearchQuery() {
      return this.$store.state.grants.grantsSearch
    },
    isGrantsSearchMode() {
      return this.grantsSearchQuery.length !== 0
    },
    isMobile() {
      return this.$store.state.responsive.isMobileSideBarOpen
    },

    grants() {
      return this.$store.state.grants.grantsSet
    },
    getMinDate() {
      let getMinimum = 0
      this.grants.forEach(grant => {
        const grantYear = grant.properties.year
        getMinimum =
          getMinimum !== 0
            ? getMinimum < grant.properties.year
              ? getMinimum
              : grantYear
            : grant.properties.year
      })
      return getMinimum
    },
    getMaxDate() {
      let getMaximum = 0
      this.grants.forEach(grant => {
        const grantYear = grant.properties.year
        getMaximum =
          getMaximum !== 0
            ? getMaximum > grantYear
              ? getMaximum
              : grantYear
            : grantYear
      })
      return getMaximum
    },
    grantsTypeList() {
      if (this.filterMode === 'all') {
        return this.grants
      } else {
        return this.grants.filter(grant => {
          return (
            grant.properties.category &&
            this.getCategoryId(grant.properties.category).parent ===
              this.getCategoryId(this.filterMode).id
          )
        })
      }
    },
    getGrantList() {
      //  if year filtermode is activated
      if (
        this.getGrantsDateFilter ||
        this.getCategoryFilterList.length !== 0 ||
        this.isGrantsSearchMode
      ) {
        let finalGrants = []
        const { fromDate, toDate } = this.getGrantsDateFilter
        const filteredYear = this.grantsTypeList.filter(grant => {
          return (
            grant.properties.year <= toDate && grant.properties.year >= fromDate
          )
        })

        // Filter by categories
        if (this.getCategoryFilterList.length !== 0) {
          finalGrants = filteredYear.filter(grant => {
            const isCategoryFound = this.getCategoryFilterList.some(
              tag =>
                tag.toLowerCase() === grant.properties.category.toLowerCase()
            )
            return isCategoryFound
          })
        } else {
          finalGrants = filteredYear
        }

        // Filter by Search Query
        if (this.isGrantsSearchMode) {
          return finalGrants.filter(grant => {
            return (
              grant.properties.grant
                .toLowerCase()
                .includes(this.grantsSearchQuery.toLowerCase()) ||
              grant.properties.recipient
                .toLowerCase()
                .includes(this.grantsSearchQuery.toLowerCase())
            )
          })
        } else {
          return finalGrants
        }
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
      if (this.currentGrant && this.currentGrant.id === grant.id) {
        this.$store.commit('grants/setCurrentGrant', null)
        this.$root.$emit('resetMap')
      } else {
        this.$root.$emit('showGrantModal', grant)
        this.setupMap(grant)
      }
    },
    handleReturn() {
      this.$router.push({
        path: '/'
      })
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
    getParentTag(grant) {
      return grant.properties.category
        ? this.getParentName(
            this.getCategoryId(grant.properties.category).parent
          )
        : ''
    },
    getParentName(childCateg) {
      return this.grantBadges.find(
        badge =>
          this.categoryList.find(category => category.id === childCateg)
            .name === badge.name
      )
    },
    getChildCategory(name) {
      return this.categoryList
        .filter(category => category.parent === this.getCategoryId(name).id)
        .sort((a, b) => {
          return a.order - b.order
        })
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
      this.resetGrantFilter()
    },
    resetGrantFilter() {
      const resetList = this.categoryList.map(category => {
        category.isChecked = false
        return category
      })
      this.$store.commit('grants/setGrantCategorySearchSet', resetList)
      this.$store.commit('grants/setCategoryTag', [])
      // Reset text filter
      this.$store.commit('grants/setGrantsSearch', '')
      this.$root.$emit('clearInput')
    },
    setupMap(grant) {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          if (grant.geometry) {
            zoomToPoint({ map, geom: grant.geometry, zoom: 11 })
            map.once('moveend', () => {
              this.$root.$emit('showGrantModal')
            })
          }
        }
        if (grant.geometry) {
          const icon = 'grant_icon.png'
          makeMarker(grant.geometry, icon, this).addTo(map)
        }
      })
    }
  }
}
</script>
<style></style>
