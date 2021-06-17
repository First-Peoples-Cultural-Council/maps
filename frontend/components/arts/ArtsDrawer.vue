<template>
  <div>
    <div v-if="getDrawerBehavior" class="h-100">
      <div v-if="mobileContent || isDrawerShown" class="arts-right-panel">
        <div v-if="isLoading" class="loading-overlay">
          <transition name="fade">
            <LoadingSpinner></LoadingSpinner>
          </transition>
        </div>
        <div class="panel-close-btn" @click="toggleArtsDrawer">
          <img src="@/assets/images/return_icon_hover.svg" />
          Collapse
        </div>

        <!-- Render List of Artist -->
        <template v-if="this.$route.name !== 'index-art-art'">
          <div v-if="placename" class="panel-artist">
            <img
              v-lazy="renderArtistImg(placename.image)"
              class="artist-img-small"
            />
            <div class="panel-details">
              <span class="item-title">{{ placename.name }}</span>
              <span class="item-subtitle">{{ placename.kind | kind }}</span>
              <div
                class="cursor-pointer pl-2 pr-2 profile-btn"
                @click="checkArtistProfile(placename.name)"
              >
                {{ artistProfile ? 'Visit your Profile' : 'Visit Profile' }}
              </div>
            </div>
          </div>
          <div v-if="listOfArtists.length !== 0" class="artist-list-container">
            <span>List of Artist:</span> <br />
            <a
              v-for="artist in listOfArtists"
              :key="artist.id"
              href="#"
              @click="checkArtistProfile(artist.name)"
              >{{ artist.name }}</a
            >
          </div>
        </template>

        <b-row v-if="listOfPublicArt" class="ml-1 mr-1 media-list-container">
          <b-col
            v-for="(artwork, index) in listOfPublicArt"
            :key="artwork.id"
            lg="12"
            xl="12"
            md="6"
            sm="12"
            @click="showMedia(artwork, index)"
          >
            <MediaCard
              class="mt-3 hover-left-move"
              :media="artwork"
              :geometry="geometry"
              :type="'public_art'"
            >
            </MediaCard>
          </b-col>
        </b-row>

        <!-- Render List of Medias -->
        <b-row class="media-list-container">
          <b-col
            v-for="media in listOfMedias"
            :key="media.id"
            lg="12"
            xl="12"
            md="6"
            sm="12"
            @click="showMedia(media)"
          >
            <MediaCard
              class="mt-3 hover-left-move"
              :media="media"
              :geometry="geometry"
              :type="'media'"
            >
            </MediaCard>
          </b-col>
        </b-row>
      </div>
      <div v-else-if="!isDrawerShown" class="panel-collapsable hide-mobile ">
        <div class="btn-collapse cursor-pointer" @click="toggleArtsDrawer">
          <img src="@/assets/images/go_icon_hover.svg" />
          <span>Expand</span>
        </div>
      </div>
    </div>
    <!-- Render Gallery with Media Info -->
    <Gallery
      v-if="showGallery"
      :artists="listOfArtists"
      :placename="artName"
      :placename-img="artImg"
      :art-thumbnail="renderArtistImg"
      :toggle-gallery="toggleGallery"
      :check-profile="checkArtistProfile"
      :related-media="listOfImageMedia"
    />
  </div>
</template>

<script>
import MediaCard from '@/components/MediaCard.vue'
import {
  encodeFPCC,
  getApiUrl,
  getMediaUrl,
  updateArtHistoryState
} from '@/plugins/utils.js'
import Gallery from '@/components/Gallery.vue'
import LoadingSpinner from '@/components/LoadingSpinner.vue'

export default {
  components: {
    MediaCard,
    Gallery,
    LoadingSpinner
  },
  filters: {
    kind(d) {
      if (d === 'public_art') {
        return 'Public Art'
      }
      return d
    }
  },
  props: {
    artistProfile: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      listOfMedias: [],
      listOfArtists: [],
      isLoading: false
    }
  },
  computed: {
    currentArt() {
      return this.$store.state.arts.currentPlacename
    },
    placename() {
      return this.isArtsDetailPage ? this.currentArt.placename : this.currentArt
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    isArtsDetailPage() {
      return this.$route.name === 'index-art'
    },
    showGallery() {
      return this.$store.state.sidebar.showGallery
    },
    getDrawerBehavior() {
      if (this.isArtsDetailPage) {
        return this.allArtworks.length > 1
      } else {
        return this.allArtworks.length !== 0
      }
    },
    listOfPublicArt() {
      return this.currentArt.public_arts || []
    },
    listOfImageMedia() {
      return [
        ...this.listOfPublicArt,
        ...this.listOfMedias.filter(media => media.file_type.includes('image'))
      ]
    },
    geometry() {
      return this.placename.geom
    },
    artName() {
      return this.placename.name
    },
    artImg() {
      return this.placename.image
    },
    artKind() {
      return this.placename.kind
    },
    allArtworks() {
      return [...this.listOfPublicArt, ...this.listOfMedias]
    }
  },
  mounted() {
    // Invoke this when Media upload is successful
    this.$root.$on('fileUploadSuccess', () => {
      this.$root.$emit('refetchArtwork')
      this.fetchMedia()
      this.$store.commit('sidebar/setDrawerContent', false)

      setTimeout(() => {
        this.$store.commit('sidebar/setDrawerContent', true)
      }, 500)
    })

    this.fetchMedia()
  },
  methods: {
    async fetchMedia() {
      // Fetch Medias for this placename
      const id = this.placename.id
      const result = await this.$axios.$get(
        `${getApiUrl('media/?placename=')}${id}`
      )

      if (result) {
        this.listOfMedias = result.sort((a, b) => b.id - a.id)
        this.$store.commit('arts/setMediaCount', result.length)
        this.getQueryMedia()
      }
    },

    getQueryMedia() {
      const foundMedia = this.allArtworks.find(media => {
        return encodeFPCC(media.name) === this.$route.query.artwork
          ? this.$route.query.artwork
          : this.currentArt.name
      })

      // check if query URL exist
      if (this.$route.query.artwork && foundMedia) {
        if (this.$route.query.upload_artwork) {
          // do nothing
        } else if (foundMedia) {
          this.setCurrentMedia(foundMedia)
          this.toggleGallery()
        } else if (this.isArtsDetailPage) {
          this.$router.push(this.$route.path)
        }
      } else {
        this.setCurrentMedia(foundMedia)

        this.$store.commit(
          'sidebar/setGallery',
          this.isArtsDetailPage ? !!this.currentArt : false
        )
      }
    },
    toggleGallery() {
      this.$store.commit('sidebar/setGallery', !this.showGallery)

      if (this.isArtsDetailPage && this.allArtworks.length <= 1) {
        this.toggleArtsDrawer()
      }
    },
    toggleArtsDrawer() {
      this.$store.commit('sidebar/setDrawerContent', !this.isDrawerShown)
    },
    showMedia(media) {
      this.setCurrentMedia(media)

      updateArtHistoryState({
        isArtsDetailPage: !this.isArtsDetailPage,
        route: this.$route.path,
        placename: this.artName,
        mediaName: media.name
      })

      this.toggleGallery()
      // Close Event Popover if open
      this.$root.$emit('closeEventPopover')
    },
    renderArtistImg(img) {
      return (
        getMediaUrl(img) || require(`@/assets/images/${this.artKind}_icon.svg`)
      )
    },
    checkArtistProfile(name) {
      this.toggleArtsDrawer()
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    setCurrentMedia(media) {
      this.$store.commit('arts/setCurrentMedia', media)
    }
  }
}
</script>

<style lang="scss">
.hide-scroll-y {
  overflow-y: hidden !important;
}

.arts-right-panel {
  display: flex;
  border: 1px solid #d7d7de;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  min-height: 100%;
  max-height: auto;
  padding: 1.25em 0.5em;
}

.arts-main-wrapper .arts-right-panel {
  padding-top: 5.5em;
}

.panel-details {
  display: flex;
  flex-direction: column;
  justify-content: center;
  box-sizing: content-box;
  margin-left: 0.5em;
  width: 240px;
}

.profile-btn {
  margin-top: 0.25em;
  background-color: #b57936;
  border-radius: 3em;
  max-width: 150px;
  color: #fff;
  padding: 0.5em;
  text-align: center;
  font-weight: 800;
  font-size: 15px;
}

.panel-artist {
  display: flex;
  justify-content: flex-start;
  padding: 0 1em;
}

.artist-list-container {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  padding: 0 1em;
  margin-top: 1em;
  font-weight: 800;
  font-size: 18px;

  a {
    margin: 0 0.25em;
    text-decoration: underline;
  }
}

.panel-close-btn {
  cursor: pointer;
  position: absolute;
  top: 25px;
  right: 0;
  height: 35px;
  background-color: #b47a2b;
  display: flex;
  align-items: center;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
  z-index: 50000;
  font-weight: 800;
  font-size: 15px;
  padding: 0 0.25em;

  & > * {
    margin: 0 0.25em;
  }
}

.artist-img-small {
  object-fit: cover;
  width: 50px;
  height: 50px;
  border-radius: 100%;
}

.item-title {
  font-weight: 800;
  font-size: 18px;
  color: #151515;
  margin: 0;
}

.item-subtitle {
  width: fit-content;
  font-weight: 800;
  font-size: 18px;
  color: #707070;
  text-transform: capitalize;
  margin: 0;
}

.panel-item-list {
  display: flex;
  flex-direction: column;
  padding: 0.5em;
}

.media-list-container {
  width: 100%;
  margin: 0 auto;
}

@media (min-width: 993px) and (max-width: 1300px) {
  .panel-details {
    width: 170px;
  }
}

@media (min-width: 993px) and (max-width: 1150px) {
  .btn-collapse {
    width: 50px !important;

    span {
      display: none !important;
    }
  }
}

@media (max-width: 992px) {
  .arts-main-wrapper .arts-right-panel {
    padding-top: 0em;
  }

  .arts-right-panel {
    box-shadow: 0;
    border: 0;
  }

  .sidefold-modal .media-list-container {
    overflow-y: auto;
  }

  .sidefold-modal .media-list-container .col-md-6 {
    flex: 0 0 100%;
    max-width: 100%;
  }

  .arts-main-wrapper .panel-close-btn {
    display: none !important;
  }
  .profile-container .panel-close-btn {
    display: none !important;
  }
}

/*** Loading Overlay CSS ***/
.loading-overlay {
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 9999999;
  right: 0;
}
</style>
