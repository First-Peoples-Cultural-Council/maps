<template>
  <div
    :class="
      `sidebar-side-panel arts-right-panel ${
        showGallery ? 'hide-scroll-y' : ''
      }`
    "
  >
    <div class="panel-header">
      <div class="panel-close-btn cursor-pointer" @click="togglePanel">
        <span class="mr-2 font-weight-bold"> X </span>
        Close
      </div>
    </div>

    <!-- Render List of Artist -->
    <div v-if="this.$route.name !== 'index-art-art'">
      <div v-if="listOfArtists.length === 0" class="panel-artist">
        <img
          class="artist-img-small"
          :src="renderArtistImg(artDetails.image)"
        />
        <div class="panel-details">
          <span class="item-title">{{ artDetails.name }}</span>
          <div
            class="cursor-pointer pl-2 pr-2 profile-btn"
            @click="checkArtistProfile(artDetails.name)"
          >
            Check Profile
          </div>
        </div>
      </div>
      <div
        v-for="artist in listOfArtists"
        v-else
        :key="artist.id"
        class="panel-artist"
      >
        <img class="artist-img-small" :src="renderArtistImg(artist.image)" />
        <div class="panel-details">
          <span class="item-title">{{ artist.name }}</span>
          <div
            class="cursor-pointer pl-2 pr-2 profile-btn"
            @click="checkArtistProfile(artist.name)"
          >
            Check Profile
          </div>
        </div>
      </div>
    </div>

    <b-row v-if="listOfPublicArt" class="ml-1 mr-1 media-list-container">
      <b-col
        v-for="(artwork, index) in listOfPublicArt"
        :key="artwork.id"
        lg="12"
        xl="12"
        md="6"
        sm="6"
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
    <b-row class="ml-1 mr-1 media-list-container">
      <b-col
        v-for="(media, index) in listOfMedias"
        :key="media.id"
        lg="12"
        xl="12"
        md="6"
        sm="6"
        @click="showMedia(media, index)"
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

    <!-- Render Gallery with Media Info -->
    <Gallery
      v-if="showGallery"
      :curr-index="mediaIndex"
      :media="currentMedia"
      :artists="listOfArtists"
      :placename="artDetails.name"
      :placename-img="artDetails.image"
      :show-gallery="showGallery"
      :toggle-gallery="toggleGallery"
      :check-profile="checkArtistProfile"
      :related-media="listOfImageMedia"
    />
  </div>
</template>

<script>
import MediaCard from '@/components/MediaCard.vue'
import { encodeFPCC } from '@/plugins/utils.js'
import Gallery from '@/components/Gallery.vue'

export default {
  components: {
    MediaCard,
    Gallery
  },
  props: {
    art: {
      type: Object,
      default: () => {
        return {}
      }
    },
    togglePanel: {
      type: Function,
      default: () => {
        return {}
      }
    }
  },
  data() {
    return {
      showGallery: false,
      currentMedia: this.art.currentMedia,
      currentIndex: 0
    }
  },
  computed: {
    artDetails() {
      return this.art.art
    },
    listOfPublicArt() {
      return this.artDetails.public_arts || []
    },
    listOfArtists() {
      return this.artDetails.artists
    },
    listOfMedias() {
      return this.artDetails.medias
    },
    listOfImageMedia() {
      return [
        ...this.listOfPublicArt,
        ...this.listOfMedias.filter(media => media.file_type === 'image')
      ]
    },
    geometry() {
      return this.artDetails.geometry || this.artDetails.geom
    },
    mediaIndex() {
      return this.currentMedia
        ? this.listOfImageMedia.findIndex(
            media => media.id === this.currentMedia.id
          )
        : 0
    }
  },
  methods: {
    toggleGallery() {
      this.showGallery = !this.showGallery
    },
    showMedia(media, index) {
      this.toggleGallery()
      this.currentMedia = media
      this.currentIndex = index
    },
    renderArtistImg(img) {
      return img || require(`@/assets/images/artist_icon.svg`)
    },
    checkArtistProfile(name) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    }
  }
}
</script>

<style lang="scss">
.sidebar-side-panel {
  position: fixed;
  top: 0;
  left: 425px;
  width: 425px;
  height: 100vh;
  overflow-x: hidden;
  z-index: 999999;
}

.hide-scroll-y {
  overflow-y: hidden;
}

.arts-right-panel {
  display: flex;
  background: #f9f9f9 0% 0% no-repeat padding-box;
  box-shadow: 0px 3px 6px #00000029;
  border: 1px solid #d7d7de;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  height: 100%;
  padding-bottom: 1em;
}

.panel-header {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  padding: 1em;
  margin-bottom: 1em;
  position: relative;
}

.panel-details {
  display: flex;
  flex-direction: column;
  justify-content: center;
  box-sizing: content-box;
  margin-left: 0.5em;
}

.profile-btn {
  background-color: #b57936;
  border-radius: 3em;
  max-width: 150px;
  color: #fff;
  padding: 0.2em;
  text-align: center;
}

.panel-artist {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  padding: 1em;
}

.panel-close-btn {
  position: absolute;
  right: 0;
  width: 100px;
  background-color: #953920;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
  z-index: 50000;
}

.artist-img-small {
  object-fit: cover;
  width: 50px;
  height: 50px;
  border-radius: 100%;
}

.item-title {
  font: Bold 16px Proxima Nova;
  color: #707070;
}

.item-subtitle {
  font: Bold 15px/18px Lato;
  color: #c3bfbc;
}

.panel-item-list {
  display: flex;
  flex-direction: column;
  padding: 0.5em;
}

.media-list-container {
  width: 100%;
}
</style>
