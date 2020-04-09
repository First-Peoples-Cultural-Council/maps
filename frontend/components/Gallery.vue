<template>
  <div :id="`gallery-modal-${currentMedia.id}`" class="gallery-modal">
    <div class="btn-close cursor-pointer" @click="toggleGallery" />

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
          <img class="artist-img-small" :src="renderArtistImg(placenameImg)" />
          <div class="gallery-title">
            <span class="item-title">{{ currentMedia.name }}</span>
            <span class="item-subtitle" v-html="returnArtists()" />
          </div>
          <div
            v-if="artistCount === 0 && this.$route.name !== 'index-art-art'"
            class="cursor-pointer pl-2 pr-2 ml-3 profile-btn"
            @click="handleProfileClick"
          >
            Check Profile
          </div>
          <img class="art-type" src="@/assets/images/arts/audio.png" />
        </div>
        <!-- Render Media here depending on type -->
        <img
          v-if="currentMedia.file_type === 'image'"
          class="media-img"
          :src="currentMedia.media_file || currentMedia.image"
        />
        <!-- REnder Youtube Video Here -->
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
        <!-- Render Public Art Image here -->
        <img v-else class="media-img" :src="currentMedia.image" />
      </div>
      <button
        v-if="isRelatedMedia"
        :disabled="canNavigateNext"
        @click="nextSlide"
      >
        <img src="@/assets/images/go_icon_hover.svg" />
      </button>
    </div>

    <div v-if="isRelatedMedia" class="gallery-img-pagination">
      <div
        v-for="(item, indx) in relatedMedia"
        :key="item.id"
        :class="`arts-img-item ${mediaIndex === indx ? 'is-selected' : ''}`"
        @click="selectCurrentIndex(item)"
      >
        <img v-if="item.media_file" :src="item.media_file" />
        <img v-else :src="item.image" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
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
    placename: {
      type: String,
      default: ''
    },
    placenameImg: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      index: this.mediaIndex,
      mediaData: this.media
    }
  },
  computed: {
    artistCount() {
      return this.artists ? this.artists.length : 0
    },
    currentMedia() {
      return this.mediaData
    },
    isRelatedMedia() {
      return (
        this.currentMedia.file_type !== 'video' && this.relatedMedia.length > 1
      )
    },
    canNavigatePrevious() {
      return this.mediaIndex === 0
    },
    canNavigateNext() {
      return this.mediaIndex === this.relatedMedia.length - 1
    },
    mediaIndex() {
      return this.currentMedia
        ? this.relatedMedia.findIndex(
            media => media.id === this.currentMedia.id
          )
        : 0
    }
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
    renderArtistImg(img) {
      return img || require(`@/assets/images/artist_icon.svg`)
    },
    selectCurrentIndex(item) {
      this.mediaData = item
    },
    nextSlide() {
      this.mediaData = this.relatedMedia[this.mediaIndex + 1]
    },
    previousSlide() {
      this.mediaData = this.relatedMedia[this.mediaIndex - 1]
    },
    getYoutubeEmbed(url) {
      const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
      const match = url.match(regExp)
      return match && match[7].length === 11 ? match[7] : false
    },
    handleProfileClick() {
      this.toggleGallery()
      this.checkProfile(this.placename)
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
  width: 60%;
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
  height: 600px;
  object-fit: cover;
  object-position: center center;
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

  .media-img {
    width: 90%;
    margin: 0 2em;
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

  .gallery-img-pagination {
    position: fixed;
    bottom: 0;
    display: flex;
    width: 90%;
    justify-content: center;
    overflow-x: auto;
    overflow-y: hidden;

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
</style>
