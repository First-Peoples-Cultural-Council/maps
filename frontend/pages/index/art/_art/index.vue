<template>
  <div class="w-100">
    <div v-if="!isEmptyObject(placename)" class="w-100 arts-main-wrapper">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div class="p-1">
          <img
            class="artist-img-small"
            :src="renderArtistImg(placename.image)"
          />
          {{ placename.kind | titleCase }}:
          <span class="font-weight-bold">{{ placename.name }}</span>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
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
            :arttype="placename.kind"
            :name="placename.name"
            :server="isServer"
            :arts-banner="artistBanner"
            :is-owner="isPlacenameOwner()"
            :is-contributor="isContributor()"
            :edit-placename="handlePlacenameEdit"
          ></ArtsBanner>

          <ArtsDetailCard
            v-else
            :arttype="placename.kind"
            :name="placename.name"
            :server="isServer"
            :tags="taxonomies"
            :is-owner="isPlacenameOwner()"
            :is-contributor="isContributor()"
            :edit-placename="handlePlacenameEdit"
          ></ArtsDetailCard>
          <!-- END Conditional Render Arts Header  -->

          <!-- Render Arts Detail -->
          <div
            :class="
              `artist-content-container ${
                isCollapse || !isArtist ? 'collapse-content-container' : ''
              }`
            "
          >
            <!-- Show the Placename image if Public Art and Event -->
            <div
              v-if="
                placename.image && (isPublicArt || isEvent || isOrganization)
              "
              class="placename-img-container"
            >
              <img class="placename-img" :src="getMediaUrl(placename.image)" />
            </div>

            <!-- Show list of Artist involved, if its a Public Art -->

            <div
              v-if="placename.artists.length !== 0 && isPublicArt"
              class="artist-content-field"
            >
              <h5 class="field-title">Artist:</h5>

              <a
                v-for="artist in placename.artists"
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

            <section v-if="placename.description" class="artist-content-field">
              <h5 class="field-title">
                {{
                  placename.kind.toLowerCase() !== 'public_art'
                    ? placename.kind
                    : 'Public Art'
                }}
                Description:
              </h5>
              <span class="field-content">
                <span v-html="stringSplit(placename.description)"></span>
                <a v-if="showExpandBtn()" href="#" @click="toggleDescription">{{
                  collapseDescription ? 'read less' : 'read more'
                }}</a>
              </span>
            </section>
            <section
              v-if="!placename.description && placename.kind === 'artist'"
              class="artist-content-field"
            >
              <h5 class="field-title">
                Artist Description:
              </h5>
              <span class="field-content">
                <span>
                  We do not yet have a bio/description for this artist. If you
                  are this artist and would like to claim this page to create a
                  profile please contact:
                  <a href="mailto:maps@fpcc.ca">maps@fpcc.ca</a>
                </span>
              </span>
            </section>

            <section
              v-if="
                (placename.kind === 'artist' &&
                  (placename.communities &&
                    placename.communities.length > 0)) ||
                  placename.other_community
              "
              class="artist-content-field"
            >
              <h5 class="field-title">
                Artist Communities:
              </h5>
              <span class="field-content">
                <span>
                  {{ communityNames.join(', ') }}
                </span>
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
                      <img :src="getSocMedIcon(soc.value)" />
                    </a>
                  </li>
                </ul>
              </span>
            </section>

            <section
              v-if="grantsList.length !== 0"
              class="artist-content-field"
            >
              <span class="field-title">Grants:</span>
              <b-row>
                <b-col
                  v-for="(grant, index) in grantsList"
                  :key="`grants-item-${index}`"
                  lg="12"
                  xl="12"
                  md="12"
                  sm="12"
                  class="mt-3 mr-3 hover-left-move"
                >
                  <GrantsCard
                    :grant="grant"
                    :is-selected="currentGrant && currentGrant.id === grant.id"
                  ></GrantsCard>
                </b-col>
              </b-row>
            </section>
          </div>
        </div>
      </div>
      <ArtsDrawer
        v-if="isGalleryNotEmpty"
        class="sidebar-side-panel hide-mobile"
        :class="{
          'hide-scroll-y': isGalleryShown
        }"
      />
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
  getMediaUrl,
  isEmptyObject
} from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import ArtsDrawer from '@/components/arts/ArtsDrawer.vue'
import ErrorScreen from '@/layouts/error.vue'
import GrantsCard from '@/components/grants/GrantsCard.vue'

export default {
  components: {
    ArtsBanner,
    ArtsDetailCard,
    Logo,
    ArtsDrawer,
    ErrorScreen,
    GrantsCard
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
      blockedTag: ['Person'], // add taxonomy to not show
      filterCondition: [
        'instagram',
        'fb',
        'facebook',
        'youtube',
        'twitter',
        'linkedin'
      ]
    }
  },
  computed: {
    placename() {
      return this.$store.state.arts.currentPlacename
    },
    communityNames() {
      const communityNames = this.placename.communities.map(place => place.name)

      if (this.placename.other_community)
        communityNames.push(this.placename.other_community)

      return communityNames
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
      return this.placename.kind.toLowerCase() === 'artist'
    },
    isPublicArt() {
      return this.placename.kind.toLowerCase() === 'public_art'
    },
    isEvent() {
      return this.placename.kind.toLowerCase() === 'event'
    },
    isOrganization() {
      return this.placename.kind.toLowerCase() === 'organization'
    },
    isGalleryNotEmpty() {
      return (
        this.placename.medias.filter(media => media.file_type !== 'default')
          .length !== 0 || this.placename.public_arts.length !== 0
      )
    },
    socialMedia() {
      return this.placename.related_data.filter(
        filter =>
          filter.data_type === 'website' &&
          this.filterCondition.some(condition =>
            filter.value.toLowerCase().includes(condition)
          )
      )
    },
    relatedData() {
      return this.placename.related_data.filter(element => {
        return (
          !this.socialMedia.includes(element) &&
          (!element.is_private &&
            (element.value && element.value.length !== 0)) &&
          (element.data_type !== 'event_date' &&
            element.data_type !== 'award' &&
            element.data_type !== 'website')
        )
      })
    },
    getEventDate() {
      return this.placename.related_data.find(element => {
        return element.data_type === 'event_date'
      })
    },
    getAwardList() {
      return this.placename.related_data.filter(element => {
        return (
          element.data_type === 'award' &&
          (element.value && element.value.length !== 0)
        )
      })
    },
    getWebsiteList() {
      return this.placename.related_data.filter(element => {
        return (
          !this.socialMedia.includes(element) &&
          element.data_type === 'website' &&
          (element.value && element.value.length !== 0)
        )
      })
    },
    taxonomies() {
      return this.placename.taxonomies.filter(
        taxo => !this.blockedTag.includes(taxo.name)
      )
    },
    artistBanner() {
      return require(`@/assets/images/default_banner.png`)
    },
    artistImg() {
      return this.placename.image
        ? getMediaUrl(this.placename.image)
        : require(`@/assets/images/artist_icon.svg`)
    },
    grantsList() {
      return this.placename.grants.features
    },
    currentGrant() {
      return this.$store.state.grants.currentGrant
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
        const placename = await $axios.$get(getApiUrl('placename/' + art.id))

        store.commit('arts/setCurrentPlacename', placename)
        const isServer = !!process.server
        return {
          isServer
        }
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
      this.placename &&
      (this.placename.medias.length !== 0 ||
        this.placename.public_arts.length !== 0) &&
      window.innerWidth > 992
    ) {
      this.$store.commit('sidebar/setDrawerContent', true)
    }
  },
  methods: {
    getMediaUrl,
    isEmptyObject,
    getSocMedIcon(link) {
      const str = link.toLowerCase()
      const getSoc = this.filterCondition.find(soc => {
        return str.includes(soc)
      })
      const value = getSoc === 'fb' ? 'facebook' : getSoc

      return require(`@/assets/images/arts/${value}.svg`)
    },
    isPlacenameOwner() {
      if (this.placename.creator) {
        if (this.$store.state.user.user.id === this.placename.creator.id)
          return true
      }
      return false
    },
    isContributor() {
      if (
        this.user.placename_set &&
        this.user.placename_set.length !== 0 &&
        this.placename.artists &&
        this.placename.artists.length !== 0
      ) {
        const contributorID = this.placename.artists.map(artist => artist.id)
        const isContributor = this.user.placename_set.some(placename =>
          contributorID.includes(placename.id)
        )

        return isContributor
      } else {
        return false
      }
    },
    handlePlacenameEdit() {
      const kind =
        this.placename.kind.charAt(0).toUpperCase() +
        this.placename.kind.slice(1)
      this.$router.push({
        path: '/contribute',
        query: {
          mode: 'existing',
          id: this.placename.id,
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
          if (this.placename.geom)
            zoomToPoint({ map, geom: this.placename.geom, zoom: 11 })
        }
        if (this.placename.geom) {
          const icon = this.placename.kind + '_icon.svg'
          makeMarker(this.placename.geom, icon, this).addTo(map)
        }
      })
    },
    toggleDescription() {
      this.collapseDescription = !this.collapseDescription
    },
    stringSplit(string) {
      const stringValue = this.collapseDescription
        ? `${string} `
        : string.replace(/(.{200})..+/, '$1 ...')
      return stringValue
    },
    showExpandBtn() {
      return this.placename.description.length >= 50
    },
    renderArtistImg(img) {
      const getIcon =
        this.placename && this.placename.kind
          ? require(`@/assets/images/${this.placename.kind}_icon.svg`)
          : ''
      return getMediaUrl(img) || getIcon
    },
    checkUrlValid(url) {
      const pattern = /^((http|https|ftp):\/\/)/
      const newUrl = url.toLowerCase()

      return pattern.test(newUrl) ? url : `https://${newUrl}`
    },
    checkArtistProfile(name) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    getHeaderTitle() {
      if (this.placename) {
        return (
          this.placename.name +
          ' Indigenous ' +
          this.placename.kind +
          " on First Peoples' Language Map"
        )
      } else {
        return 'Art page not found '
      }
    },
    handleCardClick(e, grant) {
      if (this.currentGrant && this.currentGrant.id === grant.id) {
        this.$store.commit('grants/setCurrentGrant', null)
        this.$root.$emit('resetMap')
      } else {
        this.$root.$emit('setupGrantPoint', grant)
      }
      this.$root.$emit('closeSideBarSlider')
    }
  },
  head() {
    return {
      title: this.getHeaderTitle(),
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.placename
            ? this.placename.description
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
.arts-grants-container {
  width: 100%;
}
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

.artist-img-small {
  width: 40px;
  height: 40px;
}

@media (max-width: 992px) {
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
