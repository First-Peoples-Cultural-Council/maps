<template>
  <div>
    <SideBar
      v-if="this.$route.name === 'index-art'"
      active="Arts"
      :show-side-panel="showDrawer"
    >
      <template v-slot:content>
        <section class="pl-3 pr-3 mt-3">
          <Accordion
            class="no-scroll-accordion"
            :content="accordionContent"
          ></Accordion>
        </section>
        <hr class="sidebar-divider" />
        <Filters class="mb-2 mt-2"></Filters>
      </template>
      <template v-slot:badges>
        <ArtistFilter class="ml-3 mr-3 mt-3 mb-1 " />
        <section :class="`badge-list-container pl-3 pr-3 pt-2`">
          <!-- Art Work Badge Filter  -->
          <BadgeFilter
            :is-selected="filterMode === 'artwork'"
            :child-taxonomy="artworkTaxonomy()"
            :color="'#5A8467'"
          >
            <template v-slot:badge>
              <Badge
                content="Art"
                :number="artworksCount"
                class="cursor-pointer"
                bgcolor="#5A8467"
                type="event"
                :mode="getBadgeStatus(filterMode, 'artwork')"
                @click.native.prevent="badgeClick($event, 'artwork')"
              ></Badge>
            </template>
          </BadgeFilter>
          <!-- Artist Badge Filter -->
          <BadgeFilter
            :is-selected="filterMode === 'artist'"
            :child-taxonomy="getChildTaxonomy('Person')"
            :color="'#B45339'"
          >
            <template v-slot:badge>
              <Badge
                content="Artist"
                :number="artistsCount"
                class="cursor-pointer"
                bgcolor="#B45339"
                type="artist"
                :mode="getBadgeStatus(filterMode, 'artist')"
                @click.native.prevent="badgeClick($event, 'artist')"
              ></Badge>
            </template>
          </BadgeFilter>

          <!-- Organization Badge Filter -->
          <BadgeFilter
            :is-selected="filterMode === 'organization'"
            :child-taxonomy="getChildTaxonomy('Organization')"
            :color="'#a48116'"
          >
            <template v-slot:badge>
              <Badge
                content="Organization"
                :number="orgsCount"
                class="cursor-pointer"
                bgcolor="#a48116"
                type="org"
                :mode="getBadgeStatus(filterMode, 'organization')"
                @click.native.prevent="badgeClick($event, 'organization')"
              ></Badge>
            </template>
          </BadgeFilter>

          <!-- Public Art Badge Filter -->
          <BadgeFilter
            :is-selected="filterMode === 'public_art'"
            :child-taxonomy="getChildTaxonomy('Public Art')"
            :color="'#848159'"
          >
            <template v-slot:badge>
              <Badge
                content="Public Art"
                :number="publicArtsCount"
                class="cursor-pointer"
                bgcolor="#848159"
                type="part"
                :mode="getBadgeStatus(filterMode, 'public_art')"
                @click.native.prevent="badgeClick($event, 'public_art')"
              ></Badge>
            </template>
          </BadgeFilter>

          <!-- Event Badge Filter -->
          <BadgeFilter
            :is-selected="filterMode === 'event'"
            :child-taxonomy="getChildTaxonomy('Event')"
            :color="'#DA531E'"
          >
            <template v-slot:badge>
              <Badge
                content="Events"
                :number="eventsCount"
                class="cursor-pointer"
                bgcolor="#DA531E"
                type="event"
                :mode="getBadgeStatus(filterMode, 'event')"
                @click.native.prevent="badgeClick($event, 'event')"
              ></Badge>
            </template>
          </BadgeFilter>

          <!-- Grant Badge Filter -->
          <!-- <BadgeFilter :childTaxonomy="getChildTaxonomy('Grant')" :color="'#008CA9'">
            <template v-slot:badge>
              <Badge
                content="Grants"
                :number="grantsCount"
                class="cursor-pointer"
                bgcolor="#008CA9"
                type="org"
                :mode="getBadgeStatus(filterMode, 'grant')"
                @click.native.prevent="badgeClick($event, 'grant')"
              ></Badge>
            </template>
          </BadgeFilter> -->
        </section>
      </template>
      <template v-slot:cards>
        <section id="card-item-list" class="pl-3 pr-3">
          <b-row>
            <b-col
              v-for="(art, index) in paginatedArts"
              :key="'arts' + index"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <ArtworkCard
                v-if="art.properties.kind === 'artwork'"
                :media="art"
                :layout="'landscape'"
                :is-selected="artDetails === art.properties && showDrawer"
                class="mt-3 hover-left-move"
                @click.native="selectMedia(art.properties)"
              ></ArtworkCard>

              <ArtsCard
                v-else
                :name="art.properties.name"
                :kind="art.properties.kind"
                :taxonomy="art.properties.taxonomies"
                :geometry="art.geometry"
                class="mt-3 hover-left-move"
                @click.native="
                  handleCardClick($event, art.properties.name, 'art')
                "
              ></ArtsCard>
            </b-col>
          </b-row>
        </section>
      </template>
      <template v-if="showDrawer" v-slot:side-panel>
        <ArtsDrawer :art="artDetails" :toggle-panel="toggleSidePanel" />
      </template>
    </SideBar>
    <div v-else-if="this.$route.name === 'index-art-art'">
      <div>
        <nuxt-child />
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import ArtworkCard from '@/components/arts/ArtworkCard.vue'
import BadgeFilter from '@/components/BadgeFilter.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC, getApiUrl } from '@/plugins/utils.js'
import Accordion from '@/components/Accordion.vue'
import ArtistFilter from '@/components/arts/ArtistFilter.vue'
import ArtsDrawer from '@/components/arts/ArtsDrawer.vue'

export default {
  components: {
    SideBar,
    ArtsCard,
    Badge,
    Filters,
    Accordion,
    ArtworkCard,
    ArtistFilter,
    ArtsDrawer,
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
      accordionContent:
        'Zoom in on the map to view Indigenous Artwork in your area. You can also view Organization, Event, Public Art and Grant information.',
      artDetails: {},
      maximumLength: 0
    }
  },
  computed: {
    isTaxonomyFilterMode() {
      return this.taxonomyFilter.length !== 0
    },
    taxonomyFilter() {
      return this.$store.state.arts.taxonomyFilter
    },
    filterMode() {
      return this.$store.state.arts.filter
    },
    taxonomies() {
      return this.$store.state.arts.taxonomySearchSet
    },
    searchQuery() {
      return this.$store.state.arts.artSearch
    },
    isSearchMode() {
      return this.searchQuery.length !== 0
    },
    showDrawer() {
      return this.$store.state.sidebar.isArtsMode
    },
    arts() {
      return this.$store.state.arts.arts
    },
    artsGeo() {
      return this.$store.state.arts.artsGeo
    },
    artsGeoSet() {
      return this.$store.state.arts.artsGeoSet
    },
    artworkSet() {
      return this.$store.state.arts.artworkSet
    },
    isMobile() {
      return this.$store.state.responsive.isMobileSideBarOpen
    },
    publicArtsCount() {
      return this.getCountValues('public_art')
    },
    orgsCount() {
      return this.getCountValues('organization')
    },
    artistsCount() {
      return this.getCountValues('artist')
    },
    grantsCount() {
      return this.getCountValues('grant')
    },
    eventsCount() {
      return this.getCountValues('event')
    },
    artworksCount() {
      return this.isSearchMode
        ? this.filterArray(this.selectedArt, 'artwork')
        : this.artworks.length
    },
    artworks() {
      return this.$store.state.arts.artworks
    },
    previewArtworkOnly() {
      return this.artworks
        .reduce((unique, item) => {
          return unique.some(
            items => items.properties.placename === item.properties.placename
          )
            ? unique
            : [
                ...unique,
                this.artworks
                  .filter(
                    items =>
                      items.properties.placename === item.properties.placename
                  )
                  .sort((a, b) => b.id - a.id)[0] // Get the Latest Artwork
              ]
        }, [])
        .sort((a, b) => {
          return b.id - a.id
        })
    },
    selectedArtwork() {
      return this.isSearchMode ? this.artworks : this.previewArtworkOnly
    },
    allArts() {
      return [...this.selectedArtwork, ...this.arts]
    },
    selectedArt() {
      let artsArray = []

      console.log(this.allArts)
      // Filter by SearchQuery and by Artist/Public Art owned by the Placename
      if (this.isSearchMode) {
        const query = this.searchQuery.toLowerCase()
        artsArray = this.allArts
          .filter(art => {
            if (art.properties.kind === 'artwork') {
              // find list of Artist if exist
              const artistList = art.properties.placename.artists
                ? art.properties.placename.artists.map(artist => artist.name)
                : []

              // if list of string contains the query, return true
              const isArtistFound = artistList.find(pub =>
                pub.toLowerCase().includes(query)
              )

              return (
                art.properties.name.toLowerCase().includes(query) ||
                art.properties.placename.name.toLowerCase().includes(query) ||
                isArtistFound
              )
            } else {
              // find list of Artist if exist
              const artistList = art.properties.artists
                ? art.properties.artists.map(artist => artist.name)
                : []
              // find list of Public art of exist
              const publicArtList = art.properties.public_arts
                ? art.properties.public_arts.map(pub => pub.name)
                : []

              // if list of string contains the query, return true
              const isPublicArtFound = publicArtList.find(pub =>
                pub.toLowerCase().includes(query)
              )

              // if list of string contains the query, return true
              const isArtistFound = artistList.find(pub =>
                pub.toLowerCase().includes(query)
              )

              return (
                art.properties.name.toLowerCase().includes(query) ||
                isPublicArtFound ||
                isArtistFound
              )
            }
          })
          .filter(art => {
            return art.properties.kind === this.filterMode
          })
      } else {
        artsArray = this.allArts.filter(art => {
          return art.properties.kind === this.filterMode
        })
      }

      // Filtering by Taxonomy tags
      if (this.isTaxonomyFilterMode) {
        // if filterMode is on Artwork
        if (this.filterMode === 'artwork') {
          return artsArray.filter(art => {
            return (
              this.artMediaType(art.properties.file_type) ===
              this.taxonomyFilter[0]
            )
          })
        } else {
          return artsArray.filter(art => {
            return art.properties.taxonomies.some(
              taxonomy =>
                taxonomy.name ===
                this.taxonomyFilter[this.taxonomyFilter.length - 1] // only gets last taxonomy
            )
          })
        }
      } else {
        return artsArray
      }
    },
    paginatedArts() {
      return this.selectedArt.slice(0, this.maximumLength)
    }
  },
  async mounted() {
    // Fetches the artworks data, for this case, it renders the page, then rerender if data is collected
    this.$store.commit('sidebar/toggleLoading', true)
    const currentArtworks = this.$store.state.arts.artworkSet

    if (currentArtworks.length === 0 && this.filterMode === 'artwork') {
      let artworks = await this.$axios.$get(
        getApiUrl('arts/artwork?format=json')
      )
      artworks = artworks.map(artwork => {
        const artGeo = this.artsGeoSet.features.find(
          artGeo => artGeo.id === artwork.properties.placename
        )
        artwork.geometry = artGeo.geometry

        return artwork
      })
      if (artworks) {
        this.$store.commit('arts/setArtworksStore', artworks) // All data
        this.$store.commit('arts/setArtworks', artworks) // All data
        this.$store.commit('sidebar/toggleLoading', false)
      } else {
        this.$store.commit('sidebar/toggleLoading', true)
      }
    } else {
      this.loadKindData()
    }

    // If you're in Arts Page, and trigger sorting by taxonomy, this will load the data
    this.$root.$on('triggerLoadKindData', e => {
      this.loadKindData()
    })

    this.$root.$on('refetchArtwork', () => {
      this.refetchArtwork()
    })

    // Trigger addeventlistener only if there's Sidebar, used for Pagination
    if (this.$route.name === 'index-art') {
      const mobileContainer = document.querySelector('#side-inner-collapse')
      const desktopContainer = document.querySelector('#sidebar-container')

      const containerArray = [mobileContainer, desktopContainer]

      containerArray.forEach(elem => {
        elem.addEventListener('scroll', e => {
          if (
            elem.scrollTop + elem.clientHeight >= elem.scrollHeight &&
            elem.scrollTop !== 0
          ) {
            if (this.selectedArt.length > this.maximumLength) {
              this.loadMoreData()
            }
          }
        })
      })

      this.loadMoreData()
    }
  },
  methods: {
    badgeClick($event, name) {
      if (this.showDrawer) {
        this.toggleSidePanel()
      }
      this.resetFilter()
      this.maximumLength = 0
      this.handleBadge($event, name)
      this.loadKindData()

      // // update URL, but no functionality
      // this.$router.push({
      //   query: {
      //     type: name
      //   }
      // })
    },
    resetFilter() {
      this.$store.commit('arts/setTaxonomyTag', [])
      this.$store.commit('arts/setArtSearch', '')
    },
    loadMoreData() {
      this.$store.commit('sidebar/toggleLoading', true)
      setTimeout(() => {
        this.maximumLength += 16
        this.$store.commit('sidebar/toggleLoading', false)
      }, 250)
    },
    async loadKindData() {
      const kind = this.filterMode
      this.$store.commit('sidebar/toggleLoading', true) // Start loading
      const url = `${getApiUrl('arts')}/${kind.replace('_', '-')}?format=json`

      const loaded = await this.$store.dispatch('arts/isKindLoaded', kind)
      const artsIds = await this.$store.dispatch('arts/getArtsGeoIds')

      if (!loaded && kind !== 'artwork') {
        // Fetch Arts
        const data = await this.$axios.$get(url)

        if (data) {
          // Set data with name for clarity
          const artsSet = data.features
          const arts = artsSet.filter(datum => artsIds.includes(datum.id)) // Filtered based on map bounds

          // Set language stores
          this.$store.commit('arts/setStore', [...this.arts, ...artsSet]) // All data
          this.$store.commit('arts/set', [...this.arts, ...arts]) // Updating data based on map
          this.loadMoreData()
        }
      } else {
        this.loadMoreData()
      }
    },
    async refetchArtwork() {
      let artworks = await this.$axios.$get(
        getApiUrl('arts/artwork?format=json')
      )

      artworks = artworks.map(artwork => {
        const artGeo = this.artsGeoSet.features.find(
          artGeo => artGeo.id === artwork.properties.placename
        )
        artwork.geometry = artGeo.geometry

        return artwork
      })

      if (artworks) {
        this.$store.commit('arts/setArtworksStore', artworks) // All data
        this.$store.commit('arts/setArtworks', artworks) // All data
      }
    },
    handleCardClick($event, name, type) {
      if (this.showDrawer) {
        this.toggleSidePanel()
      }
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    selectMedia(currentArt) {
      // If Same Artwork is clicked, close the drawer
      if (currentArt === this.artDetails && this.showDrawer) {
        this.artDetails = {}
        this.closeDrawer()
      }
      // If another artwork is selected when there's open, close it to recalibrate data, then open
      else if (currentArt !== this.artDetails && this.showDrawer) {
        this.artDetails = currentArt
        // Important to open it after closing the drawer
        this.closeDrawer()
        setTimeout(() => {
          this.openDrawer()
        }, 100)
      }
      // If no artwork is selected, it opens the drawer
      else if (currentArt !== this.artDetails || !this.showDrawer) {
        this.artDetails = currentArt
        this.openDrawer()
      }
      // Close Event Popover if open
      this.$root.$emit('closeEventPopover')
    },
    toggleSidePanel() {
      this.$store.commit('sidebar/setDrawerContent', !this.showDrawer)
    },
    openDrawer() {
      this.$store.commit('sidebar/setDrawerContent', true)
    },
    closeDrawer() {
      this.$store.commit('sidebar/setDrawerContent', false)
    },
    getCountValues(type) {
      return (this.isSearchMode || this.isTaxonomyFilterMode) &&
        this.filterMode === type
        ? this.filterArray(this.selectedArt, type)
        : this.filterArray(this.artsGeo, type)
    },
    filterArray(artsArray, type) {
      return artsArray.filter(art => art.properties.kind === type).length
    },
    getTaxonomyID(taxName) {
      return this.taxonomies.find(taxonomy => taxonomy.name === taxName)
    },
    getChildTaxonomy(taxName) {
      return this.taxonomies.filter(
        taxonomy => taxonomy.parent === this.getTaxonomyID(taxName).id
      )
    },
    artworkTaxonomy() {
      return Array.from(['image', 'video', 'audio']).map(type => {
        return {
          id: type,
          name: type
        }
      })
    },
    artMediaType(type) {
      if (type) {
        if (type.includes('image')) {
          return 'image'
        } else if (type.includes('audio')) {
          return 'audio'
        } else if (type === 'youtube' || type.includes('video')) {
          return 'video'
        } else {
          return 'image'
        }
      } else {
        return 'image'
      }
    }
  }
}
</script>
<style>
.badge-list-container {
  display: flex;
  flex-wrap: wrap;
}
</style>
