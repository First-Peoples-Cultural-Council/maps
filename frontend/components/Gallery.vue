<template>
  <div class="gallery-modal">
    <div class="btn-close cursor-pointer" @click="closeGallery" />

    <div
      :class="
        `gallery-carousel-container ${isRelatedMedia ? '' : 'gallery-center'}`
      "
    >
      <button
        v-if="isRelatedMedia"
        :disabled="canNavigatePrevious"
        @click="previousSlide"
      >
        <img src="@/assets/images/return_icon_hover.svg" />
      </button>
      <div class="carousel-gallery-container">
        <div class="artist-gallery-detail">
          <img v-lazy="artThumbnail(placenameImg)" class="artist-img-small" />
          <div class="gallery-title">
            <span class="item-title">{{ getCurrentMedia.name }}</span>
            <span class="item-subtitle">
              By
              <template v-if="artistCount !== 0">
                <a
                  v-for="artist in artists"
                  :key="artist.name"
                  href="#"
                  @click.prevent="checkProfile(artist.name)"
                >
                  {{ artist.name }}</a
                >
              </template>
              <template v-else>
                {{ placename }}
              </template>
            </span>
          </div>
          <div
            v-if="
              (artistCount === 0 && this.$route.name !== 'index-art-art') ||
                !getCurrentMedia.media_file
            "
            class="cursor-pointer pl-2 pr-2 ml-3 profile-btn"
            @click="handleProfileClick"
          >
            Visit Profile
          </div>
          <!-- <img class="art-type" src="@/assets/images/arts/audio.png" /> -->
        </div>
        <div
          ref="mediaImg"
          :class="
            `media-img-container ${isFullscreen ? 'fullscreen-mode' : ''}`
          "
        >
          <button
            v-if="
              getCurrentMedia.file_type !== 'audio' &&
                getCurrentMedia.file_type !== 'video'
            "
            class="expand-btn"
            @click="toggleFullscreen"
          >
            <img
              :src="
                require(`@/assets/images/${
                  isFullscreen ? 'contract_icon' : 'expand_icon'
                }.svg`)
              "
            />
          </button>
          <!-- Render Media here depending on type -->
          <img
            v-if="returnMediaType === 'image'"
            :class="
              `media-img example ${isFullscreen ? 'img-fullscreen-mode' : ''}`
            "
            :src="
              getMediaUrl(getCurrentMedia.media_file) ||
                getMediaUrl(getCurrentMedia.image)
            "
            oncontextmenu="return false;"
          />
          <!-- Render Youtube Video Here -->
          <iframe
            v-else-if="
              returnMediaType === 'video' &&
                getYoutubeEmbed(getCurrentMedia.url)
            "
            class="media-img video"
            :src="
              `https://www.youtube.com/embed/${getYoutubeEmbed(
                getCurrentMedia.url
              )}/?rel=0`
            "
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
          <!-- Render if audio file  -->
          <audio
            v-else-if="returnMediaType === 'audio'"
            class="media-img audio"
            controls
          >
            <source :src="getCurrentMedia.media_file" type="audio/ogg" />
            <source :src="getCurrentMedia.media_file" type="audio/mpeg" />
            <source :src="getCurrentMedia.media_file" type="audio/wav" />
            Your browser does not support the audio element.
          </audio>
          <!-- Render Public Art Image here -->
          <img
            v-else
            v-lazy="getMediaUrl(getCurrentMedia.image)"
            :class="
              `media-img public-art ${
                isFullscreen ? 'img-fullscreen-mode' : ''
              }`
            "
            oncontextmenu="return false;"
          />
          <span
            v-if="returnMediaType === 'image' || getCurrentMedia.image"
            class="media-copyright"
          >
            Copyright &copy; {{ returnCopyright(false) }}
          </span>
        </div>
      </div>
      <button
        v-if="isRelatedMedia"
        :disabled="canNavigateNext"
        @click="nextSlide"
      >
        <img src="@/assets/images/go_icon_hover.svg" />
      </button>
    </div>

    <div v-if="isRelatedMedia" class="gallery-pagination-container">
      <div class="gallery-img-pagination">
        <div
          v-for="(item, indx) in relatedMedia"
          :key="`item-${item.name}-${item.id}`"
          :class="`arts-img-item ${mediaIndex === indx ? 'is-selected' : ''}`"
          @click="selectNewMedia(item)"
        >
          <img
            v-if="item.media_file"
            v-lazy="getMediaUrl(item.media_file)"
            oncontextmenu="return false;"
          />
          <img
            v-else
            v-lazy="getMediaUrl(item.image)"
            oncontextmenu="return false;"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getMediaUrl, updateArtHistoryState } from '@/plugins/utils.js'
export default {
  props: {
    toggleGallery: {
      type: Function,
      default: () => {
        return {}
      }
    },
    artists: {
      type: Array,
      default: () => {
        return []
      }
    },
    checkProfile: {
      type: Function,
      default: () => {
        return {}
      }
    },
    relatedMedia: {
      type: Array,
      default: () => {
        return []
      }
    },
    placename: {
      type: String,
      default: ''
    },
    placenameImg: {
      type: String,
      default: ''
    },
    artThumbnail: {
      type: Function,
      default: () => {
        return {}
      }
    }
  },
  data() {
    return {
      isFullscreen: false
    }
  },
  computed: {
    getCurrentMedia() {
      return this.$store.state.arts.currentMedia
    },
    isArtsDetailPage() {
      return this.$route.name === 'index-art-art'
    },
    artistCount() {
      return this.artists ? this.artists.length : 0
    },
    isRelatedMedia() {
      return this.returnMediaType === 'image' && this.relatedMedia.length > 1
    },
    mediaIndex() {
      return this.getCurrentMedia
        ? this.relatedMedia.findIndex(
            media => media.id === this.getCurrentMedia.id
          )
        : 0
    },
    canNavigatePrevious() {
      return this.mediaIndex === 0
    },
    canNavigateNext() {
      return this.mediaIndex === this.relatedMedia.length - 1
    },
    returnMediaType() {
      const type = this.getCurrentMedia.file_type

      if (type) {
        if (type.includes('image')) {
          return 'image'
        } else if (type.includes('audio')) {
          return 'audio'
        } else if (type === 'youtube' || type.includes('video')) {
          return 'video'
        } else {
          return 'image'
        }
      } else {
        return 'image'
      }
    }
  },

  methods: {
    getMediaUrl,
    returnCopyright(copyright) {
      return copyright
        ? copyright.value
        : `${new Date().getFullYear()} ${this.placename}`
    },
    toggleFullscreen() {
      const mediaImg = this.$refs.mediaImg
      if (this.isFullscreen) {
        document.exitFullscreen()
      } else {
        mediaImg.requestFullscreen()
      }

      this.isFullscreen = !this.isFullscreen
    },
    selectNewMedia(item) {
      this.setCurrentMedia(item)
      this.updateURL()
    },
    nextSlide() {
      this.setCurrentMedia(this.relatedMedia[this.mediaIndex + 1])
      this.updateURL()
    },
    previousSlide() {
      this.setCurrentMedia(this.relatedMedia[this.mediaIndex - 1])
      this.updateURL()
    },
    updateURL() {
      updateArtHistoryState({
        isArtsDetailPage: this.isArtsDetailPage,
        route: this.$route.path,
        placename: this.placename,
        mediaName: this.getCurrentMedia.name
      })
    },
    getYoutubeEmbed(url) {
      // eslint-disable-next-line no-useless-escape
      const regExpression = /^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
      const match = url.match(regExpression)
      return match && match[2].length === 11 ? match[2] : false
    },
    handleProfileClick() {
      const getPlaceName = this.getCurrentMedia.file_type
        ? this.placename
        : this.getCurrentMedia.name
      this.closeGallery()
      this.checkProfile(getPlaceName)
    },
    closeGallery() {
      this.$router.push(this.$route.path)
      this.toggleGallery()
    },
    setCurrentMedia(media) {
      this.$store.commit('arts/setCurrentMedia', media)
    }
  }
}
</script>

<style lang="scss">
.gallery-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100vw;
  height: 100vh;
  overflow-y: hidden;
  overflow-x: hidden;
  z-index: 500000;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.gallery-carousel-container {
  display: flex;
  justify-content: space-between;
  width: 100vw;
  padding: 0 2em;
}

.gallery-center {
  justify-content: center;
}

.carousel-gallery-container {
  width: 65%;
  margin-bottom: 2em;
}

.btn-close {
  position: absolute;
  top: 2.5%;
  right: 3%;
  width: 20px;
  height: 20px;
  z-index: 99999;
  background: url('../assets/images/close_icon_white.svg');
  background-size: 100% 100%;
}

.artist-gallery-detail {
  position: relative;
  width: 100%;
  background-color: #fff;
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0.5em;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  padding: 1em;
}

.art-type {
  position: absolute;
  right: 0.5em;
  width: 30px;
  height: 30px;
  justify-self: flex-end;
}

.gallery-title {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-left: 0.5em;
}

.artist-img-small {
  width: 50px;
  height: 50px;
  border-radius: 100%;
}

.media-img {
  display: block;
  width: 100%;
  height: 60vh;
  object-fit: contain;
  background: black;
}

.media-img-container {
  position: relative;

  .expand-btn {
    position: absolute;
    top: -20px;
    right: 15px;

    img {
      width: 20px;
      height: 20px;
    }
  }

  .media-copyright {
    position: absolute;
    bottom: 10px;
    right: 15px;
    font-size: 0.8em;

    background: #fff;
    color: #000;
    padding: 0.25em 0.5em;
  }
}

.audio {
  display: flex;
  height: 100px;
}

/* Pagination CSS */

.gallery-pagination-container {
  display: flex;
  width: 80%;
  justify-content: center;
  overflow-x: auto;
  overflow-y: hidden;
}

.gallery-img-pagination {
  display: flex;
  width: auto;
  justify-content: flex-start;
  overflow-x: auto;
  overflow-y: hidden;
}

.arts-img-item {
  width: 145x;
  height: 145px;
  margin: 0.5em;
  opacity: 1;
  border: 5px solid #fff;
  transition: border 0.2s ease-in;
  background: rgba(0, 0, 0, 0.5);
}

.arts-img-item img {
  object-fit: cover;
  width: 135px;
  height: 135px;
}

.gallery-carousel-container button {
  background: rgba(0, 0, 0, 0);
  border: 0;
  margin: auto 0;
  transform: translateY(2.25em);

  img {
    width: 50px;
    height: 50px;
  }
  &:focus {
    border: 0;
  }

  &:disabled {
    opacity: 0.4;
  }
}

.is-selected {
  border: 5px solid #b57936;
}

@media (max-width: 992px) {
  .gallery-modal {
    justify-content: center;
  }
  .carousel-gallery-container {
    width: 100%;
    align-items: center;
  }
  .gallery-carousel-container {
    padding: 0;
  }

  .gallery-carousel-container button {
    display: none;
  }

  .artist-gallery-detail {
    position: fixed;
    top: 0;
    border-radius: 0;
    width: 100vw;
  }

  .btn-close {
    background: url('../assets/images/close_icon.svg');
    background-size: 100% 100%;
  }

  .gallery-pagination-container {
    width: 90%;
    position: fixed;
    bottom: 2%;
  }

  .gallery-img-pagination {
    .arts-img-item {
      width: 115px;
      height: 115px;
      margin: 0.5em;
      opacity: 1;
      border: 5px solid #fff;
      transition: border 0.2s ease-in;
    }

    .arts-img-item img {
      object-fit: cover;
      width: 105px;
      height: 105px;
    }

    .is-selected {
      border: 5px solid #b57936;
    }
  }
}

.fullscreen-mode {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 99999999999;
  overflow: hidden;
  width: 100vw;
  height: 100vh;
}

.img-fullscreen-mode {
  width: 100vw;
  height: 100vh;
}
</style>
