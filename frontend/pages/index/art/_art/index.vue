<template>
  <div class="w-100">
    <div v-if="artDetails" class="w-100 arts-main-wrapper">
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
          'hide-scroll-y': isGalleryShown
        }"
      >
        <div class="artist-detail-container">
          <Logo
            v-if="!mobileContent"
            class="cursor-pointer"
            :logo-alt="1"
          ></Logo>
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
            :art-image="artistImg"
            :tags="taxonomies"
            :arttype="artDetails.kind"
            :name="artDetails.name"
            :server="isServer"
            :arts-banner="artistBanner"
            :is-owner="isPlacenameOwner()"
            :is-contributer="isContributer()"
            :edit-placename="handlePlacenameEdit"
          ></ArtsBanner>

          <ArtsDetailCard
            v-else
            :arttype="artDetails.kind"
            :name="artDetails.name"
            :server="isServer"
            :tags="taxonomies"
            :is-owner="isPlacenameOwner()"
            :is-contributer="isContributer()"
            :edit-placename="handlePlacenameEdit"
          ></ArtsDetailCard>
          <!-- END Conditional Render Arts Header  -->

          <!-- Render Arts Detail -->
          <div
            :class="
              `artist-content-container ${
                isCollapse ? 'collapse-content-container' : ''
              }`
            "
          >
            <!-- Show the Placename image if Public Art and Event -->
            <div
              v-if="artDetails.image && (isPublicArt || isEvent)"
              class="placename-img-container"
            >
              <img class="placename-img" :src="getMediaUrl(artDetails.image)" />
            </div>

            <!-- Show list of Artist involved, if its a Public Art -->

            <div
              v-if="artDetails.artists.length !== 0 && isPublicArt"
              class="artist-content-field"
            >
              <h5 class="field-title">Artist:</h5>

              <a
                v-for="artist in artDetails.artists"
                :key="artist.id"
                href="#"
                @click="checkArtistProfile(artist.name)"
                >{{ artist.name }}</a
              >
            </div>

            <section
              v-if="getAwardList.length !== 0 && isArtist"
              class="artist-content-field"
            >
              <h5 class="field-title">
                Artist Awards
              </h5>
              <ul class="field-content-list">
                <li v-for="award in getAwardList" :key="award.id">
                  <img src="@/assets/images/arts/award_icon.svg" />
                  {{ award.value }}
                </li>
              </ul>
            </section>

            <section v-if="getEventDate" class="artist-content-field">
              <h5 class="field-title">
                Event Date
              </h5>
              <span class="field-content"> {{ getDateValue() }} </span>
            </section>

            <section v-if="artDetails.description" class="artist-content-field">
              <h5 class="field-title">
                {{
                  artDetails.kind.toLowerCase() !== 'public_art'
                    ? artDetails.kind
                    : 'Public Art'
                }}
                Description:
              </h5>
              <span class="field-content">
                <span v-html="stringSplit(artDetails.description)"></span>
                <a v-if="showExpandBtn()" href="#" @click="toggleDescription">{{
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

            <!-- Render List of Websites -->
            <section
              v-for="(web, index) in getWebsiteList"
              :key="web.id"
              class="artist-content-field"
            >
              <h5 class="field-title">{{ `Website #${index + 1}` }}:</h5>
              <a :href="checkUrlValid(web.value)" target="_blank">
                {{ checkUrlValid(web.value) }}</a
              >
            </section>

            <!-- Render LIst of Social Media -->
            <section
              v-if="socialMedia.length !== 0"
              class="artist-content-field"
            >
              <span class="field-title">Social Media:</span>
              <span class="field-content">
                <ul class="artist-social-icons">
                  <li v-for="soc in socialMedia" :key="soc.id">
                    <a :href="checkUrlValid(soc.value)" target="_blank">
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
        </div>
      </div>
      <ArtsDrawer
        v-if="(mobileContent || isDrawerShown) && isGalleryNotEmpty"
        :art="artDetails"
        :show-panel="isDrawerShown"
        :toggle-panel="toggleArtsDrawer"
        class="sidebar-side-panel hide-mobile"
        :class="{
          'hide-scroll-y': isGalleryShown
        }"
      />
      <div
        v-if="isGalleryNotEmpty && !isDrawerShown"
        class="panel-collapsable hide-mobile "
      >
        <div class="btn-collapse cursor-pointer" @click="toggleArtsDrawer">
          <img src="@/assets/images/go_icon_hover.svg" />
          <span>Expand</span>
        </div>
      </div>
    </div>
    <ErrorScreen v-else></ErrorScreen>
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
  makeMarker,
  getMediaUrl
} from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import ArtsDrawer from '@/components/arts/ArtsDrawer.vue'
import ErrorScreen from '@/layouts/error.vue'

export default {
  components: {
    ArtsBanner,
    ArtsDetailCard,
    Logo,
    ArtsDrawer,
    ErrorScreen
  },
  filters: {
    titleCase(str) {
      return startCase(str)
    }
  },

  data() {
    return {
      collapseDescription: false,
      modalShow: false,
      blockedTag: ['Person'] // add taxonomy to not show
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    userDetail() {
      return this.$store.state.user.user
    },
    isGalleryShown() {
      return this.$store.state.sidebar.showGallery
    },
    isCollapse() {
      return this.$store.state.sidebar.collapseDetail
    },
    isDrawerShown() {
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
    isPublicArt() {
      return this.artDetails.kind.toLowerCase() === 'public_art'
    },
    isEvent() {
      return this.artDetails.kind.toLowerCase() === 'event'
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
      return this.artDetails.related_data.filter(element => {
        return (
          !this.socialMedia.includes(element) &&
          (!element.is_private &&
            (element.value && element.value.length !== 0)) &&
          (element.data_type !== 'Event Date' &&
            element.data_type !== 'award' &&
            element.data_type !== 'website')
        )
      })
    },
    getEventDate() {
      return this.artDetails.related_data.find(element => {
        return element.data_type === 'Event Date'
      })
    },
    getAwardList() {
      return this.artDetails.related_data.filter(element => {
        return (
          element.data_type === 'award' &&
          (element.value && element.value.length !== 0)
        )
      })
    },
    getWebsiteList() {
      return this.artDetails.related_data.filter(element => {
        return (
          !this.socialMedia.includes(element) &&
          element.data_type === 'website' &&
          (element.value && element.value.length !== 0)
        )
      })
    },
    taxonomies() {
      return this.artDetails.taxonomies.filter(
        taxo => !this.blockedTag.includes(taxo.name)
      )
    },
    artistBanner() {
      return require(`@/assets/images/default_banner.png`)
    },
    artistImg() {
      return this.artDetails.image
        ? getMediaUrl(this.artDetails.image)
        : require(`@/assets/images/artist_icon.svg`)
    }
  },
  watch: {
    art(newArt, oldArt) {
      if (newArt !== oldArt) {
        this.setupMap()
      }
    }
  },
  async asyncData({ params, $axios, store, $router }) {
    const arts = await $axios.$get(getApiUrl(`art-search?format=json`))
    if (arts) {
      const art = arts.find(a => {
        if (a.name) {
          return encodeFPCC(a.name) === params.art
        }
      })

      if (art) {
        const artDetails = await $axios.$get(getApiUrl('placename/' + art.id))

        const isServer = !!process.server
        return {
          isServer,
          artDetails
        }
      } else {
      }
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
    if (
      this.artDetails &&
      (this.artDetails.medias.length !== 0 ||
        this.artDetails.public_arts.length !== 0) &&
      window.innerWidth > 992
    ) {
      this.$store.commit('sidebar/setDrawerContent', true)
    }

    // Invoke this when Media upload is successful
    this.$root.$on('fileUploadSuccess', () => {
      this.$root.$emit('refetchArtwork')
      this.$store.commit('sidebar/setDrawerContent', false)

      setTimeout(() => {
        this.$store.commit('sidebar/setDrawerContent', true)
      }, 500)
    })
  },
  methods: {
    getMediaUrl,
    isPlacenameOwner() {
      if (this.artDetails.creator) {
        if (this.$store.state.user.user.id === this.artDetails.creator.id)
          return true
      }
      return false
    },
    isContributer() {
      if (
        this.userDetail.placename_set &&
        this.userDetail.placename_set.length !== 0 &&
        this.artDetails.artists &&
        this.artDetails.artists.length !== 0
      ) {
        const contributerID = this.artDetails.artists.map(artist => artist.id)
        const isContributer = this.userDetail.placename_set.some(placename =>
          contributerID.includes(placename.id)
        )

        return isContributer
      } else {
        return false
      }
    },
    handlePlacenameEdit() {
      const kind =
        this.artDetails.kind.charAt(0).toUpperCase() +
        this.artDetails.kind.slice(1)
      this.$router.push({
        path: '/contribute',
        query: {
          mode: 'existing',
          id: this.artDetails.id,
          type: kind === 'Public_art' ? 'Public Art' : kind
        }
      })
    },
    getDateValue() {
      const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }
      let dateDescription = ''
      const eventDate = new Date(this.getEventDate.value)
      const dateString = eventDate.toLocaleDateString('en-US', options)

      if (eventDate > Date.now()) {
        const resultDate = eventDate - Date.now()
        const differenceInHours = Math.ceil(Math.abs(resultDate) / 36e5)
        const differenceInDays = Math.ceil(resultDate / (1000 * 60 * 60 * 24))
        const differenceInMins = Math.floor(resultDate / 1000 / 60)

        if (differenceInMins < 60) {
          dateDescription = `(Happening in ${differenceInMins}) minute${
            differenceInMins <= 1 ? '' : 's'
          })`
        } else if (differenceInHours > 24) {
          dateDescription = `(Happening in ${differenceInDays} day${
            differenceInDays === 1 ? '' : 's'
          })`
        } else {
          dateDescription = `(Happening in ${differenceInHours} hour${
            differenceInHours === 1 ? '' : 's'
          })`
        }
      } else {
        dateDescription = '(Event finished)'
      }
      return `${dateString} ${dateDescription}`
    },
    widthChecker(e) {
      if (this.mobileContent) {
        if (e.srcElement.innerWidth > 992) {
          this.$store.commit('sidebar/setMobileContent', false)
          this.$store.commit('sidebar/toggleCollapse')
        }
      } else if (this.isDrawerShown) {
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
          if (this.artDetails.geom)
            zoomToPoint({ map, geom: this.artDetails.geom, zoom: 11 })
        }
        if (this.artDetails.geom) {
          const icon = this.artDetails.kind + '_icon.svg'
          makeMarker(this.artDetails.geom, icon, 'art-marker').addTo(map)
        }
      })
    },
    toggleDescription() {
      this.collapseDescription = !this.collapseDescription
    },
    toggleArtsDrawer() {
      this.$store.commit('sidebar/setDrawerContent', !this.isDrawerShown)
    },
    stringSplit(string) {
      const stringValue = this.collapseDescription
        ? `${string} `
        : string.replace(/(.{200})..+/, '$1 ...')
      return stringValue
    },
    showExpandBtn() {
      return this.artDetails.description.length >= 50
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
    },
    checkArtistProfile(name) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    getHeaderTitle() {
      if (this.artDetails) {
        return (
          this.artDetails.name +
          ' Indigenous ' +
          this.artDetails.kind +
          " on First Peoples' Language Map"
        )
      } else {
        return 'Art page not found '
      }
    }
  },
  head() {
    return {
      title: this.getHeaderTitle(),
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.artDetails
            ? this.artDetails.description
            : 'Art page not found.'
        }
      ]
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('sidebar/setDrawerContent', false)
    next()
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
  margin: 1em 0 0.4em 0;
  overflow: hidden;

  a {
    text-decoration: underline;
  }
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

.field-content font {
  font: normal 16px/25px Proxima Nova !important;
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
  font-weight: 600;
  color: #151515;
}

.field-content p,
.field-content span,
.field-content pre,
.field-content label,
.field-content legend {
  font: normal 16px/25px Proxima Nova !important;
  color: #151515 !important;
  background: none !important;
  overflow-x: hidden;
}

.artist-content-field > .field-content-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.field-content-list li {
  display: flex;
  align-items: center;
  & > * {
    margin-right: 0.4em;
  }
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

.placename-img-container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  margin: 1em 0;
}

.placename-img {
  width: 275px;
  height: 275px;
  object-fit: cover;
  background-color: rgba(0, 0, 0, 1);
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
  margin-top: 1.5em;
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

@media (min-width: 993px) and (max-width: 1150px) {
  .btn-collapse {
    width: 50px;

    span {
      display: none;
    }
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
