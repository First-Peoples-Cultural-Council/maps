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
        <ArtistFilter class="m-3 " />
        <section class="pl-3 pr-3 pt-2">
          <Badge
            content="Artwork"
            :number="artworks.length"
            class="cursor-pointer mb-1"
            bgcolor="#5A8467"
            type="event"
            :mode="getBadgeStatus(mode, 'artwork')"
            @click.native.prevent="badgeClick($event, 'artwork')"
          ></Badge>
          <Badge
            content="Artists"
            :number="artists.length"
            class="cursor-pointer mb-1"
            bgcolor="#B45339"
            type="artist"
            :mode="getBadgeStatus(mode, 'artist')"
            @click.native.prevent="badgeClick($event, 'artist')"
          ></Badge>
          <Badge
            content="Events"
            :number="events.length"
            class="cursor-pointer mb-1"
            bgcolor="#DA531E"
            type="event"
            :mode="getBadgeStatus(mode, 'event')"
            @click.native.prevent="badgeClick($event, 'event')"
          ></Badge>
          <Badge
            content="Organization"
            :number="orgs.length"
            class="cursor-pointer mb-2"
            bgcolor="#a48116"
            type="org"
            :mode="getBadgeStatus(mode, 'organization')"
            @click.native.prevent="badgeClick($event, 'organization')"
          ></Badge>
          <Badge
            content="Public Arts"
            :number="publicArts.length"
            class="cursor-pointer mb-2"
            bgcolor="#848159"
            type="part"
            :mode="getBadgeStatus(mode, 'public_art')"
            @click.native.prevent="badgeClick($event, 'public_art')"
          ></Badge>

          <!-- <Badge
            content="Resources"
            :number="artists.length"
            class="cursor-pointer mb-1"
            bgcolor="#008CA9"
            type="resource"
            :mode="getBadgeStatus(mode, 'resource')"
            @click.native.prevent="handleBadge($event, 'resource')"
          ></Badge> -->
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
              <ArtistCard
                v-if="mode === 'artwork'"
                :media="art"
                :layout="'landscape'"
                :is-selected="artDetails.art === art.art && showDrawer"
                class="mt-3 hover-left-move"
                @click.native="selectMedia(art.art, art)"
              ></ArtistCard>

              <ArtsCard
                v-else
                :art="art"
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
import ArtistCard from '@/components/arts/ArtistCard.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC } from '@/plugins/utils.js'
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
    ArtistCard,
    ArtistFilter,
    ArtsDrawer
  },
  data() {
    return {
      mode: 'artwork',
      accordionContent: 'View artwork from indigenous artists in your area.',
      artDetails: {},
      maximumLength: 0
    }
  },
  computed: {
    showDrawer() {
      return this.$store.state.sidebar.isArtsMode
    },
    arts() {
      return this.$store.state.arts.arts
    },
    publicArts() {
      return this.arts.filter(art => art.properties.kind === 'public_art')
    },
    orgs() {
      return this.arts.filter(art => art.properties.kind === 'organization')
    },
    artists() {
      return this.arts.filter(art => art.properties.kind === 'artist')
    },
    grants() {
      return this.arts.filter(art => art.properties.kind === 'grant')
    },
    events() {
      return this.arts.filter(art => art.properties.kind === 'event')
    },
    artworks() {
      const artworks = []
      this.arts.forEach(art => {
        const medias = art.properties.medias
        if (medias) {
          medias.forEach(media => {
            if (media.file_type !== 'default' || media.url !== null) {
              artworks.push({
                id: media.id,
                name: media.name,
                media_file: media.media_file,
                file_type: media.file_type,
                url: media.url,
                art: {
                  name: art.properties.name,
                  type: art.properties.kind,
                  image: art.properties.image,
                  artists: art.properties.artists,
                  medias: art.properties.medias,
                  geometry: art.geometry
                }
              })
            }
          })
        }
      })
      artworks.sort((a, b) => (a.id > b.id ? -1 : 1))
      return artworks
    },
    selectedArt() {
      let artsArray = []
      switch (this.mode) {
        case 'artwork':
          artsArray = this.artworks
          break
        case 'event':
          artsArray = this.events
          break
        case 'artist':
          artsArray = this.artists
          break
        case 'public_art':
          artsArray = this.publicArts
          break
        case 'organization':
          artsArray = this.orgs
          break
      }
      return artsArray
    },
    paginatedArts() {
      return this.selectedArt.slice(0, this.maximumLength)
    }
  },
  mounted() {
    // Trigger addeventlistener only if there's Sidebar, used for Pagination
    if (this.$route.name === 'index-art') {
      const listElm = document.querySelector('#sidebar-container')
      listElm.addEventListener('scroll', e => {
        if (
          listElm.scrollTop + listElm.clientHeight >= listElm.scrollHeight &&
          listElm.scrollTop !== 0
        ) {
          if (this.selectedArt.length > this.maximumLength) {
            this.loadMoreData()
          }
        }
      })
      this.loadMoreData()
    }
  },
  methods: {
    badgeClick($event, name) {
      this.maximumLength = 0
      console.log(this.maximumLength)
      this.handleBadge($event, name)
      this.loadMoreData()
    },
    loadMoreData() {
      this.$store.commit('sidebar/toggleLoading', true)
      setTimeout(() => {
        this.maximumLength += 8
        this.$store.commit('sidebar/toggleLoading', false)
      }, 500)
    },
    handleCardClick($event, name, type) {
      if (this.showDrawer) {
        this.toggleSidePanel()
      }
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    selectMedia(art, currentMedia) {
      if (art === this.artDetails.art && this.showDrawer) {
        this.artDetails = {}
        this.$store.commit('sidebar/setDrawerContent', false)
      } else if (art !== this.artDetails.art || !this.showDrawer) {
        this.artDetails = {
          art,
          currentMedia
        }

        this.$store.commit('sidebar/setDrawerContent', true)
      }
    },
    toggleSidePanel() {
      this.$store.commit('sidebar/setDrawerContent', !this.showDrawer)
    }
  }
}
</script>
<style></style>
