<template>
  <div v-show="showGallery" id="gallery-modal" class="gallery-modal">
    <img
      class="btn-close cursor-pointer"
      src="@/assets/images/close_icon_white.svg"
      alt="Close"
      @click="toggleGallery"
    />

    <div class="gallery-carousel-container">
      <button :disabled="canNavigatePrevious" @click="previousSlide">
        <img src="@/assets/images/return_icon_hover.svg" />
      </button>
      <div class="carousel-gallery-container">
        <div class="artist-gallery-detail">
          <img class="artist-img-small" :src="placenameImg" />
          <div class="gallery-title">
            <span class="item-title">{{ currentMedia.name }}</span>
            <span class="item-subtitle" v-html="returnArtists()" />
          </div>
          <div
            v-if="artistCount === 1"
            class="cursor-pointer pl-2 pr-2 ml-3 profile-btn"
            @click="checkProfile"
          >
            Check Profile
          </div>
          <img class="art-type" src="@/assets/images/arts/audio.png" />
        </div>
        <!-- Render Media here depending on type -->
        <img
          v-if="currentMedia.file_type === 'image'"
          class="media-img"
          :src="currentMedia.media_file"
        />
        <iframe
          v-else-if="
            currentMedia.file_type === 'video' &&
              getYoutubeEmbed(currentMedia.url)
          "
          class="media-img"
          :src="
            `https://www.youtube.com/embed/${getYoutubeEmbed(
              currentMedia.url
            )}/?rel=0`
          "
          frameborder="0"
          allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
        ></iframe>
      </div>
      <button :disabled="canNavigateNext" @click="nextSlide">
        <img src="@/assets/images/go_icon_hover.svg" />
      </button>
    </div>

    <div v-if="isRelatedMedia" class="gallery-img-pagination">
      <div
        v-for="(item, index) in relatedMedia"
        :key="item.id"
        :class="`arts-img-item ${currentIndex === index ? 'is-selected' : ''}`"
        @click="selectCurrentIndex(index, item)"
      >
        <img :src="item.media_file" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    showGallery: {
      type: Boolean,
      default: false
    },
    toggleGallery: {
      type: Function,
      default: () => {
        return {}
      }
    },
    media: {
      type: Object,
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
    currIndex: {
      type: Number,
      default: 0
    },
    placename: {
      type: String,
      default: ''
    },
    placenameImg: {
      type: String,
      default: ''
    }
  },
  computed: {
    artistCount() {
      return this.artists ? this.artists.length : 0
    },
    currentIndex() {
      return this.currIndex
    },
    currentMedia() {
      return this.media
    },
    isRelatedMedia() {
      return (
        this.currentMedia.file_type === 'image' && this.relatedMedia.length > 1
      )
    },
    canNavigatePrevious() {
      return this.currIndex === 0
    },
    canNavigateNext() {
      return this.currIndex === this.relatedMedia.length - 1
    }
  },
  mounted() {
    const mapContainer = document.getElementById('map-container')
    const modalContainer = document.getElementById('gallery-modal')
    mapContainer.after(modalContainer)
  },
  methods: {
    returnArtists() {
      const listOfArtist =
        this.artistCount !== 0
          ? this.artists.map((artist, index) => {
              return `<a href="#" @click.prevent="checkProfile()"> ${artist.name}</a>`
            })
          : this.placename
      return `By ${listOfArtist}`
    },
    selectCurrentIndex(index, item) {
      this.currIndex = index
      this.media = item
    },
    nextSlide() {
      this.currIndex += 1
      this.media = this.relatedMedia[this.currIndex]
    },
    previousSlide() {
      this.currIndex -= 1
      this.media = this.relatedMedia[this.currIndex]
    },
    getYoutubeEmbed(url) {
      const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
      const match = url.match(regExp)
      return match && match[7].length === 11 ? match[7] : false
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

.carousel-gallery-container {
  width: 60%;
  margin-bottom: 2em;
}

.btn-close {
  position: absolute;
  top: 2%;
  right: 1%;
  width: 20px;
  height: 20px;
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
  width: 100%;
  height: 600px;
  object-fit: cover;
}

/* Pagination CSS */
.gallery-img-pagination {
  display: flex;
  width: 80%;
  justify-content: center;
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
}

.arts-img-item img {
  width: 135px;
  height: 135px;
}

.is-selected {
  border: 5px solid #b57936;
}

.gallery-carousel-container button {
  background: rgba(0, 0, 0, 0);
  border: 0;

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
</style>
