<template>
  <div>
    <SideBar
      v-if="this.$route.name === 'index-art'"
      active="Arts"
      :show-side-panel="showPanel"
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
        <ArtistFilter class="m-3" />
        <section class="pl-3 pr-3 pt-2">
          <Badge
            content="Public Arts"
            :number="publicArts.length"
            class="cursor-pointer mb-2"
            bgcolor="#848159"
            type="part"
            :mode="getBadgeStatus(mode, 'public_art')"
            @click.native.prevent="handleBadge($event, 'public_art')"
          ></Badge>
          <Badge
            content="Organization"
            :number="orgs.length"
            class="cursor-pointer mb-2"
            bgcolor="#a48116"
            type="org"
            :mode="getBadgeStatus(mode, 'organization')"
            @click.native.prevent="handleBadge($event, 'organization')"
          ></Badge>
          <Badge
            content="Artists"
            :number="artists.length"
            class="cursor-pointer mb-1"
            bgcolor="#db531f"
            type="event"
            :mode="getBadgeStatus(mode, 'artist')"
            @click.native.prevent="handleBadge($event, 'artist')"
          ></Badge>
          <Badge
            content="Events"
            :number="artists.length"
            class="cursor-pointer mb-1"
            bgcolor="#DA531E"
            type="event"
            :mode="getBadgeStatus(mode, 'event')"
            @click.native.prevent="handleBadge($event, 'event')"
          ></Badge>
          <Badge
            content="Resources"
            :number="artists.length"
            class="cursor-pointer mb-1"
            bgcolor="#008CA9"
            type="event"
            :mode="getBadgeStatus(mode, 'resource')"
            @click.native.prevent="handleBadge($event, 'resource')"
          ></Badge>
        </section>
      </template>
      <template v-slot:cards>
        <section class="pl-3 pr-3">
          <b-row v-if="mode !== 'organization' && mode !== 'public_art'">
            <b-col
              v-for="(art, index) in artists"
              :key="'artists ' + index"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <ArtsCard
                :art="art"
                class="mt-3 hover-left-move"
                @click.native="
                  handleCardClick($event, art.properties.name, 'art')
                "
              ></ArtsCard>
            </b-col>
          </b-row>
          <b-row v-if="mode !== 'organization' && mode !== 'artist'">
            <b-col
              v-for="(art, index) in publicArts"
              :key="'parts' + index"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <ArtistCard
                :art="art"
                :layout="'landscape'"
                class="mt-3 hover-left-move"
                @click.native="selectPublicArt(art)"
              ></ArtistCard>
            </b-col>
          </b-row>
          <b-row v-if="mode !== 'artist' && mode !== 'public_art'">
            <b-col
              v-for="(art, index) in orgs"
              :key="'orgs' + index"
              lg="12"
              xl="12"
              md="6"
              sm="6"
            >
              <ArtsCard
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
      <template v-if="showPanel" v-slot:side-panel>
        <ArtsSidePanelSmall class="artist-side-panel" :art="artDetails" />
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
import ArtsSidePanelSmall from '@/components/arts/ArtsSidePanelSmall.vue'

export default {
  components: {
    SideBar,
    ArtsCard,
    Badge,
    Filters,
    Accordion,
    ArtistCard,
    ArtistFilter,
    ArtsSidePanelSmall
  },
  data() {
    return {
      mode: 'All',
      accordionContent: 'View artwork from indigenous artists in your area.',
      showPanel: false,
      artDetails: {}
    }
  },
  computed: {
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
    }
  },
  mounted() {
    // alert(this.$route.name)
    console.log('ARTS DATA IS HERE', [
      ...new Set(
        this.arts.map(art => {
          return art.properties.kind
        })
      )
    ])
    console.log(
      'ARTIST DATA IS HERE',
      this.arts.filter(art => {
        return art.properties.kind === 'artist'
      })
    )
    console.log(
      'PUBLIC ART DATA IS HERE',
      this.arts.filter(art => {
        return art.properties.kind === 'public_art'
      })
    )
  },
  methods: {
    handleCardClick($event, name, type) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    selectPublicArt(art) {
      this.artDetails = art
      this.toggleSidePanel()
    },
    toggleSidePanel() {
      this.showPanel = !this.showPanel
      this.$root.$emit('toggleSidePanel', this.showPanel)
    }
  }
}
</script>
<style></style>
