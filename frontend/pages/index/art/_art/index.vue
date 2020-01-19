<template>
  <div class="w-100">
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        {{ art.properties.art_type | titleCase }}:
        <span class="font-weight-bold">{{ art.properties.name }}</span>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>

    <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
      <div
        class="text-center d-none mobile-close"
        :class="{ 'content-mobile': mobileContent }"
        @click="$store.commit('sidebar/setMobileContent', false)"
      >
        <img class="d-inline-block" src="@/assets/images/arrow_down_icon.svg" />
      </div>

      <div>
        <ArtsDetailCard
          :arttype="art.properties.art_type"
          :name="art.properties.name"
          :server="isServer"
        ></ArtsDetailCard>
        <div
          v-if="artDetails.details"
          class="p-4 m-0 pb-0 color-gray font-08"
          v-html="artDetails.details"
        ></div>
        <div class="ml-3 mr-3 mt-3">
          <p class="font-08">
            [ Extracted from the
            <a href="https://www.fp-artsmap.ca/" target="_blank"
              >First People's Arts Map</a
            >]
          </p>
        </div>
        <LanguageSeeAll
          content="See all details"
          class="mt-0"
          @click.native="handleClick($event, artDetails.node_id)"
        ></LanguageSeeAll>
        <Filters class="mb-2 mt-2"></Filters>
      </div>
    </div>
  </div>
</template>

<script>
import { startCase } from 'lodash'
import ArtsDetailCard from '@/components/arts/ArtsDetailCard.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import { getApiUrl, encodeFPCC, makeMarker } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    ArtsDetailCard,
    LanguageSeeAll,
    Filters,
    Logo
  },
  filters: {
    titleCase(str) {
      return startCase(str)
    }
  },
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    }
  },
  watch: {
    art(newArt, oldArt) {
      if (newArt !== oldArt) {
        this.setupMap()
      }
    }
  },
  async asyncData({ params, $axios, store }) {
    const arts = (await $axios.$get(getApiUrl('arts'))).features
    const art = arts.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.art
      }
    })
    const artDetails = await $axios.$get(getApiUrl('art/' + art.id))

    const isServer = !!process.server
    return {
      art,
      isServer,
      artDetails
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.setupMap()
  },
  methods: {
    handleClick(e, data) {
      window.open(`https://fp-artsmap.ca/node/${data}`)
    },
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          zoomToPoint({ map, geom: this.art.geometry, zoom: 11 })
        }
        const icon = this.art.properties.art_type + '_icon.svg'
        makeMarker(this.art.geometry, icon, 'art-marker').addTo(map)
      })
    }
  },
  head() {
    return {
      title:
        this.art.properties.name +
        ' Indigenous ' +
        this.art.properties.art_type +
        " on First Peoples' Language Map",
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.art.properties.details
        }
      ]
    }
  }
}
</script>
<style></style>
