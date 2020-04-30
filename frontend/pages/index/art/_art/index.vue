<template>
  <div class="w-100 arts-main-wrapper">
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 ml-2 mr-2 d-none content-mobile-title"
    >
      <div class="p-1">
        <img
          class="artist-img-small"
          :src="renderArtistImg(artDetails.image)"
        />
        {{ artDetails.kind | titleCase }}:
        <span class="font-weight-bold">{{ artDetails.name }}</span>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>

    <div
      class="hide-mobile arts-main-container"
      :class="{
        'content-mobile': mobileContent,
        'mobile-content': mobileContent && isArtist,
        'hide-scroll-y': showGallery
      }"
    >
      <div class="artist-detail-container">
        <Logo v-if="!mobileContent" class="cursor-pointer" :logo-alt="1"></Logo>
        <div
          class="text-center d-none mobile-close"
          :class="{ 'content-mobile': mobileContent }"
          @click="$store.commit('sidebar/setMobileContent', false)"
        >
          <img
            v-if="!isArtist"
            class="d-inline-block"
            src="@/assets/images/arrow_down_icon.svg"
          />
        </div>
        <!-- START Conditional Render Arts Header -->
        <ArtsBanner
          v-if="isArtist"
          :art-image="artDetails.image"
          :tags="taxonomies"
          :arttype="artDetails.kind"
          :name="artDetails.name"
          :server="isServer"
          :media="[...artDetails.public_arts, ...artDetails.medias][0]"
        ></ArtsBanner>

        <ArtsDetailCard
          v-else
          :arttype="artDetails.kind"
          :name="artDetails.name"
          :server="isServer"
          :tags="taxonomies"
        ></ArtsDetailCard>
        <!-- END Conditional Render Arts Header  -->

        <div v-if="isLoggedIn && isArtist" class="arts-btn-container">
          <Notification type="language" title="Claim Profile"></Notification>
          <Notification type="language" title="Edit Profile"></Notification>
        </div>

        <!-- Render Arts Detail -->
        <div
          v-if="isArtist"
          :class="
            `artist-content-container ${
              isCollapse ? 'collapse-content-container' : ''
            }`
          "
        >
          <section v-if="artDetails.description" class="artist-content-field">
            <span class="field-title"> Artist Biography</span>
            <span class="field-content">
              <p v-html="stringSplit(artDetails.description)"></p>
              <a href="#" @click="toggleDescription">{{
                collapseDescription ? 'read less' : 'read more'
              }}</a>
            </span>
          </section>

          <!-- Render List of Related Data -->
          <template v-if="relatedData">
            <section
              v-for="data in relatedData"
              :key="data.id"
              class="artist-content-field"
            >
              <h5 class="field-title">{{ data.label }}:</h5>
              <a
                v-if="data.data_type === 'website'"
                :href="checkUrlValid(data.value)"
                target="_blank"
              >
                {{ checkUrlValid(data.value) }}</a
              >
              <span v-else class="field-content">{{ data.value }}</span>
            </section>
          </template>

          <!-- Render LIst of Social Media -->
          <section v-if="socialMedia.length !== 0" class="artist-content-field">
            <span class="field-title">Social Media</span>
            <span class="field-content">
              <ul class="artist-social-icons">
                <li v-for="soc in socialMedia" :key="soc.id">
                  <a :href="soc.value" target="_blank">
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
        <div
          v-else
          class="p-4 m-0 pb-0 field-content"
          v-html="artDetails.description"
        ></div>
      </div>
    </div>
    <ArtsDrawer
      v-if="(mobileContent || showDrawer) && isGalleryNotEmpty"
      :art="artDetails"
      :show-panel="showDrawer"
      :toggle-panel="toggleSidePanel"
      class="sidebar-side-panel hide-mobile"
      :class="{
        'hide-scroll-y': showGallery
      }"
    />
    <div
      v-if="isGalleryNotEmpty && !showDrawer"
      class="hide-mobile panel-collapsable"
    >
      <div class="btn-collapse cursor-pointer" @click="toggleSidePanel">
        <img src="@/assets/images/go_icon_hover.svg" />
        Expand
      </div>
    </div>
  </div>
</template>

<script>
import startCase from 'lodash/startCase'
import ArtsDetailCard from '@/components/arts/ArtsDetailCard.vue'
import ArtsBanner from '@/components/arts/ArtsBanner.vue'
import { zoomToPoint } from '@/mixins/map.js'
import {
  getApiUrl,
  encodeFPCC,
  decodeFPCC,
  makeMarker,
  getMediaUrl
} from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import ArtsDrawer from '@/components/arts/ArtsDrawer.vue'
import Notification from '@/components/Notification.vue'

export default {
  components: {
    ArtsBanner,
    ArtsDetailCard,
    Logo,
    ArtsDrawer,
    Notification
  },
  filters: {
    titleCase(str) {
      return startCase(str)
    }
  },

  data() {
    return {
      collapseDescription: false,
      blockedTag: ['Person'] // add taxonomy to not show
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    showGallery() {
      return this.$store.state.sidebar.showGallery
    },
    isCollapse() {
      return this.$store.state.sidebar.collapseDetail
    },
    showDrawer() {
      return this.$store.state.sidebar.isArtsMode
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    },
    isArtist() {
      return this.artDetails.kind.toLowerCase() === 'artist'
    },
    isGalleryNotEmpty() {
      return (
        this.artDetails.medias.filter(media => media.file_type !== 'default')
          .length !== 0 || this.artDetails.public_arts.length !== 0
      )
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
        element =>
          !this.socialMedia.includes(element) &&
          element.data_type !== 'email' &&
          !element.value.startsWith(',')
      )
    },
    taxonomies() {
      return this.artDetails.taxonomies.filter(
        taxo => !this.blockedTag.includes(taxo.name)
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
    const artParam = decodeFPCC(params.art)
    const arts = await $axios.$get(getApiUrl(`placename/?search=${artParam}`))
    const art = arts.find(a => {
      if (a.name) {
        return encodeFPCC(a.name) === params.art
      }
    })
    const artDetails = await $axios.$get(getApiUrl('placename/' + art.id))

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
  destroyed() {
    window.removeEventListener('resize', this.widthChecker)
  },
  mounted() {
    window.addEventListener('resize', this.widthChecker)
    if (this.isServer && this.artDetails) {
      this.updateMediaUrl()
    }

    if (
      this.artDetails.kind === 'artist' &&
      (this.artDetails.medias.length !== 0 ||
        this.artDetails.public_arts.length !== 0) &&
      window.innerWidth > 992
    ) {
      this.$store.commit('sidebar/setDrawerContent', true)
    }
  },
  methods: {
    widthChecker(e) {
      if (this.mobileContent) {
        if (e.srcElement.innerWidth > 992) {
          this.$store.commit('sidebar/setMobileContent', false)
          this.$store.commit('sidebar/toggleCollapse')
        }
      } else if (this.showDrawer) {
        if (e.srcElement.innerWidth <= 992) {
          this.$store.commit('sidebar/setDrawerContent', false)
        }
      }
    },
    handleClick(e, data) {
      window.open(`https://fp-artsmap.ca/node/${data}`)
    },
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          zoomToPoint({ map, geom: this.artDetails.geom, zoom: 11 })
        }
        const icon = this.artDetails.kind + '_icon.svg'
        makeMarker(this.artDetails.geom, icon, 'art-marker').addTo(map)
      })
    },
    toggleDescription() {
      this.collapseDescription = !this.collapseDescription
    },
    toggleSidePanel() {
      this.$store.commit('sidebar/setDrawerContent', !this.showDrawer)
    },
    stringSplit(string) {
      const stringValue = this.collapseDescription
        ? `${string} `
        : string.replace(/(.{200})..+/, '$1 ...')
      return stringValue
    },
    updateMediaUrl() {
      const artDetails = this.artDetails

      if (this.artDetails.medias) {
        artDetails.medias = this.artDetails.medias.map(media => {
          media.media_file.replace('http://nginx/api/', '')
          return media
        })
        this.artDetails = artDetails
      }
    },
    renderArtistImg(img) {
      return (
        getMediaUrl(img) ||
        require(`@/assets/images/${this.artDetails.kind}_icon.svg`)
      )
    },
    checkUrlValid(url) {
      const pattern = /^((http|https|ftp):\/\/)/
      const newUrl = url.toLowerCase()

      return pattern.test(newUrl) ? url : `http://${newUrl}`
    }
  },
  head() {
    return {
      title:
        this.artDetails.name +
        ' Indigenous ' +
        this.artDetails.kind +
        " on First Peoples' Language Map",
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.artDetails.description
        }
      ]
    }
  }
}
</script>
<style lang="scss">
.arts-main-container {
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
  height: auto;
  overflow-y: auto;
}

.artist-detail-container {
  width: 100%;
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
  font-family: 'Proxima Nova', sans-serif;
}

.artist-content-field {
  display: flex;
  width: 100%;
  flex-direction: column;
  margin: 0.3em 0 1em 0;
}

.field-title {
  color: #707070;
  font: Bold 15px/18px Proxima Nova;
  text-transform: capitalize;
}

.field-content {
  display: flex;
  font: normal 16px/25px Proxima Nova;
  flex-direction: column;
  color: #151515;
}

.field-content a {
  text-decoration: underline;
  color: #c46257;
}

.field-content h1,
.field-content h2,
.field-content h3,
.field-content h4,
.field-content h5 {
  font-size: 1rem;
  font-weight: bold;
  color: #151515;
}

.field-content p {
  font: normal 16px/25px Proxima Nova;
  color: #151515 !important;
  background: none !important;
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

.panel-collapsable {
  width: 15px;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 425px;
  background: #f9f9f9 0% 0% no-repeat padding-box;
  box-shadow: 0px 3px 6px #00000029;
  border: 1px solid #d7d7de;
}

.btn-collapse {
  padding: 1em;
  margin: 2.5em;
  margin-left: 0.8em;
  width: 100px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-top-right-radius: 1em;
  border-bottom-right-radius: 1em;
  color: #fff;
  background-color: #b47a2b;
}

.btn-collapse img {
  margin-right: 0.5em;
}

.artist-img-small {
  width: 40px;
  height: 40px;
}

.sidebar-side-panel {
  position: fixed;
  top: 0;
  left: 425px;
  width: 425px;
  height: 100vh;
  overflow-x: hidden;
  z-index: 999999;
}

@media (max-width: 1300px) {
  .arts-container .sidebar-container {
    width: 350px;
  }
  .arts-container .sidebar-side-panel {
    width: 350px;
    left: 350px;
  }
}

@media (max-width: 992px) {
  .sidebar-side-panel {
    display: block !important;
    position: initial;
    width: 100%;
    height: 100vh;
    left: 0;
    overflow-x: hidden;
    overflow-y: hidden;
    z-index: 999999;
  }
  .arts-main-container {
    background: #f9f9f9 0% 0% no-repeat padding-box;
  }

  .artist-content-container {
    height: 1px;
    overflow-y: hidden;
  }

  .collapse-content-container {
    height: auto;
    overflow-y: initial;
  }
}

/* Arts Mobile UI Layout */
.mobile-content {
  padding: 1em;
}

.arts-btn-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  padding: 0.25em;

  & > * {
    flex: 0 0 48%;
    margin-right: 0.25em;
  }
}
</style>
