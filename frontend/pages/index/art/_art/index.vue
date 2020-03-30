<template>
  <div class="w-100">
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        {{ art.properties.kind | titleCase }}:
        <span class="font-weight-bold">{{ art.properties.name }}</span>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>

    <div
      class="hide-mobile arts-main-container"
      :class="{ 'content-mobile': mobileContent }"
    >
      <div class="artist-detail-container">
        <Logo v-if="!mobileContent" class="cursor-pointer" :logo-alt="1"></Logo>
        <div
          class="text-center d-none mobile-close"
          :class="{ 'content-mobile': mobileContent }"
          @click="$store.commit('sidebar/setMobileContent', false)"
        >
          <img
            class="d-inline-block"
            src="@/assets/images/arrow_down_icon.svg"
          />
        </div>
        <!-- START Conditional Render Arts Header -->
        <ArtistDetailCard
          v-if="isArtist"
          :art-image="art.properties.image"
          :tags="art.properties.taxonomies"
          :media="art.properties.medias[0]"
          :arttype="art.properties.kind"
          :name="art.properties.name"
          :server="isServer"
        ></ArtistDetailCard>

        <ArtsDetailCard
          v-else
          :arttype="art.properties.kind"
          :name="art.properties.name"
          :server="isServer"
        ></ArtsDetailCard>
        <!-- END Conditional Render Arts Header  -->

        <!-- START Conditional Render Arts Detail -->
        <!-- <div
          v-if="artDetails.description"
          class="p-4 m-0 pb-0 color-gray font-08"
          v-html="stringSplit(artDetails.description)"
        ></div> -->
        <div v-if="artDetails.description" class="artist-content-container">
          <section class="artist-content-field">
            <span class="field-title">Artist Biography</span>
            <span class="field-content ">
              <p v-html="stringSplit(artDetails.description)"></p>
              <a href="#" @click="toggleDescription">{{
                collapseDescription ? 'less reading' : 'keep reading'
              }}</a>
            </span>
          </section>

          <!-- Render List of Related Data -->
          <template v-if="relatedData">
            <section
              v-for="art in relatedData"
              :key="art.id"
              class="artist-content-field"
            >
              <h5 class="field-title">
                {{ art.data_type }}
              </h5>
              <span class="field-content">{{ art.value }}</span>
            </section>
          </template>

          <!-- Render LIst of Social Media -->
          <section v-if="socialMedia.length !== 0" class="artist-content-field">
            <span class="field-title">Social Media</span>
            <span class="field-content">
              <ul class="artist-social-icons">
                <li v-for="soc in socialMedia" :key="soc.id">
                  <a :href="soc.value">
                    <img
                      v-if="soc.value.includes('facebook')"
                      src="@/assets/images/arts/facebook.svg"
                    />
                    <img
                      v-else-if="soc.value.includes('twitter')"
                      src="@/assets/images/arts/twitter.svg"
                    />
                    <img
                      v-else-if="soc.value.includes('linkedin')"
                      src="@/assets/images/arts/linkedin.svg"
                    />
                    <img
                      v-else-if="soc.value.includes('instagram')"
                      src="@/assets/images/arts/instagram.svg"
                    />
                    <img
                      v-else-if="soc.value.includes('youtube')"
                      src="@/assets/images/arts/youtube.svg"
                    />
                  </a>
                </li>
              </ul>
            </span>
          </section>
        </div>
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
    <ArtsSidePanelSmall
      v-show="showPanel"
      :art="artDetails"
      :toggle-panel="toggleSidePanel"
      class="sidebar-side-panel"
    />
  </div>
</template>

<script>
import startCase from 'lodash/startCase'
import ArtsDetailCard from '@/components/arts/ArtsDetailCard.vue'
import ArtistDetailCard from '@/components/arts/ArtistDetailCard.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import { getApiUrl, encodeFPCC, makeMarker } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import ArtsSidePanelSmall from '@/components/arts/ArtsSidePanelSmall.vue'

export default {
  components: {
    ArtsDetailCard,
    ArtistDetailCard,
    LanguageSeeAll,
    Filters,
    Logo,
    ArtsSidePanelSmall
  },
  filters: {
    titleCase(str) {
      return startCase(str)
    }
  },
  data() {
    return {
      showPanel: false,
      collapseDescription: false
    }
  },
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    },
    isArtist() {
      return this.art.properties.kind.toLowerCase() === 'artist'
    },
    socialMedia() {
      const filterCondition = [
        'instagram',
        'facebook',
        'youtube',
        'twitter',
        'linkedin'
      ]
      return this.artDetails.related_data.filter(
        filter =>
          filter.data_type === 'website' &&
          filterCondition.some(condition => filter.value.includes(condition))
      )
    },
    relatedData() {
      return this.artDetails.related_data.filter(
        element => !this.socialMedia.includes(element)
      )
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
    const arts = (await $axios.$get(getApiUrl('art-geo'))).features
    const art = arts.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.art
      }
    })
    const artDetails = await $axios.$get(getApiUrl('placename/' + art.id))

    console.log('ARTIST DATA IS', artDetails)

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
  mounted() {
    console.log('SOCIAL MEDIAS', this.socialMedia)
    if (
      this.art.properties.kind === 'artist' &&
      (this.artDetails.medias.length !== 0 ||
        this.artDetails.public_arts.length !== 0)
    ) {
      this.toggleSidePanel()
    }
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
        const icon = this.art.properties.kind + '_icon.svg'
        makeMarker(this.art.geometry, icon, 'art-marker').addTo(map)
      })
    },
    toggleDescription() {
      this.collapseDescription = !this.collapseDescription
    },
    toggleSidePanel() {
      this.showPanel = !this.showPanel
      this.$root.$emit('toggleSidePanel', this.showPanel)
    },
    stringSplit(string) {
      const stringValue = this.collapseDescription
        ? `${string} `
        : string.replace(/(.{200})..+/, '$1 ...')
      return stringValue
    }
  },
  head() {
    return {
      title:
        this.art.properties.name +
        ' Indigenous ' +
        this.art.properties.kind +
        " on First Peoples' Language Map",
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.art.properties.description
        }
      ]
    }
  }
}
</script>
<style>
.arts-main-container {
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
  height: 100vh;
}

.artist-detail-container {
  width: 425px;
}
.artist-side-panel {
  flex: 1 1 700px;
}

.artist-main-container {
  display: flex;
  flex-direction: column;
}

.artist-content-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin: 0em 1em 0.25em 1em;
  /* border: 1px solid red; */
  font-family: 'Proxima Nova', sans-serif;
}

.artist-content-field {
  display: flex;
  width: 100%;
  flex-direction: column;
  margin: 0.3em 0;
}

.field-title {
  color: #707070;
  font-weight: bold;
  font-size: 13px;
  opacity: 0.6;
  text-transform: capitalize;
}

.field-content {
  display: flex;
  font-size: 18px;
  flex-direction: column;
  color: #707070;
  font-size: 0.9em;
}

.field-content a {
  text-decoration: underline;
  color: #c46257;
}

.artist-content-field > .field-content-list {
  list-style: none;
  padding: 0;
}

.field-content-list li {
  display: flex;
  align-items: center;
}
.artist-social-icons {
  display: flex;
  padding: 0;
  justify-content: flex-start;
  width: 100%;
  list-style: none;
  text-align: center;
}

.artist-social-icons li {
  width: 25px;
  height: 25px;
  margin: 0.25em 0.5em 0.5em 0;
}

.artist-social-icons img {
  width: 25px;
  height: 25px;
}

.sidebar-side-panel {
  width: 425px;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 425px;
  overflow-y: auto;
  overflow-x: hidden;
}
</style>
