<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-art'" active="Arts">
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
        <section class="pl-3 pr-3 pt-3">
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
              <ArtsCard
                :art="art"
                class="mt-3 hover-left-move"
                @click.native="
                  handleCardClick($event, art.properties.name, 'art')
                "
              ></ArtsCard>
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
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC } from '@/plugins/utils.js'
import Accordion from '@/components/Accordion.vue'

export default {
  components: {
    SideBar,
    ArtsCard,
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
      mode: 'All',
      accordionContent:
        'Indigenous languages in B.C. all have corresponding unique cultures and artistic practices. This rich cultural environment is alive with countless Indigenous artists and artistic groups who create work across all artistic disciplines – visual, music, dance, performance, story and new media. The map provides an online environment for artists and groups to share information about their artistic practice as well as upcoming events, including festivals, exhibitions, performances and cultural events.'
    }
  },
  computed: {
    arts() {
      return this.$store.state.arts.arts
    },
    publicArts() {
      return this.arts.filter(art => art.properties.art_type === 'public_art')
    },
    orgs() {
      return this.arts.filter(art => art.properties.art_type === 'organization')
    },
    artists() {
      return this.arts.filter(art => art.properties.art_type === 'artist')
    }
  },
  methods: {
    handleCardClick($event, name, type) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    }
  }
}
</script>
<style></style>
