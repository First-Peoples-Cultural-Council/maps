<template>
  <div
    class="artist-card"
    :class="{ 'card-selected': isSelected }"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <!-- Tile View Mode -->
    <div v-if="isLayoutTile" class="arts-card-container">
      <div class="arts-card-tag">
        <img src="@/assets/images/arts/audio.png" /> Audio
      </div>
      <div class="arts-card-body">
        <img class="card-teaser-img" src="@/assets/images/sample.jpg" />
      </div>
      <div class="arts-card-footer">
        <span class="artist-title">
          I want to break free
        </span>
        <span class="artist-name">
          By The Queen
        </span>
      </div>
    </div>
    <!-- Landscape View Mode -->
    <div v-else class="arts-card-landscape">
      <div class="arts-card-body">
        <img
          v-lazy="artImage"
          :class="`card-teaser-img ${mediaExist ? '' : 'card-teaser-null'}`"
        />
      </div>
      <div class="arts-card-right">
        <div class="arts-card-footer">
          <span class="artist-title"> {{ mediaData.name }} </span>
          <span v-if="artists.length !== 0" class="artist-name">
            By
            <a
              v-for="artist in artists"
              :key="artist.name"
              @click.stop.prevent="handleCardClick(mediaData.placename.name)"
            >
              {{ artist.name }}</a
            >
          </span>
          <span v-else class="artist-name">
            By
            <a @click.stop.prevent="handleCardClick(mediaData.placename.name)">
              {{ mediaData.placename.name }}
            </a>
          </span>
        </div>
        <div class="arts-card-more">
          <div class="arts-card-tag">
            <img
              :src="require(`@/assets/images/arts/${returnMediaType}.png`)"
            />
            {{ returnMediaType }}
          </div>
          <div class="fpcc-card-more">
            <img
              v-if="!hover"
              src="@/assets/images/go_icon_hover.svg"
              alt="Go"
            />
            <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { encodeFPCC, getMediaUrl } from '@/plugins/utils.js'

export default {
  props: {
    media: {
      type: Object,
      default: () => {
        return {}
      }
    },
    layout: {
      type: String,
      default: 'tile'
    },
    isSelected: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    mediaData() {
      return this.media.properties
    },
    artists() {
      return this.mediaData.placename.artists
    },
    mediaType() {
      return this.mediaData.file_type
    },
    videoThumbnail() {
      return `https://img.youtube.com/vi/${this.getYoutubeVideoID(
        this.mediaData.url
      )}/hqdefault.jpg`
    },
    isLayoutTile() {
      return this.layout !== 'landscape'
    },
    mediaExist() {
      return this.mediaData.media_file !== null
    },
    artImage() {
      return this.mediaExist
        ? getMediaUrl(this.mediaData.media_file)
        : this.mediaType === 'video'
        ? this.videoThumbnail
        : require('@/assets/images/artwork_icon.svg')
    },
    returnArtists() {
      const listOfArtist =
        this.artists.length !== 0
          ? this.artists.map((artist, index) => {
              return `<a href="art/${encodeFPCC(artist.name)}"> ${
                artist.name
              }</a>`
            })
          : `<a href="art/${encodeFPCC(this.mediaData.placename.name)}"> ${
              this.mediaData.placename.name
            }</a>`
      return `By ${listOfArtist}`
    },
    returnMediaType() {
      let mediaType = ''
      switch (this.mediaType) {
        case this.mediaType.includes('image'):
          mediaType = 'image'
          return true
        case this.mediaType.includes('audio'):
          mediaType = 'audio'
          return true
        case 'youtube' || 'video':
          mediaType = 'video'
          return true
        case 'default' || 'text':
          mediaType = 'image'
          return true
        default:
          mediaType = 'image'
      }
      return mediaType
    }
  },
  methods: {
    handleCardClick(name) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    handleMouseOver() {
      this.hover = true
      if (!this.media.geometry) return
      this.$eventHub.revealArea(this.media.geometry)
    },
    handleMouseLeave() {
      this.hover = false
      if (!this.media.geometry) return
      this.$eventHub.doneReveal()
    },
    getYoutubeVideoID(url) {
      const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
      const match = url.match(regExp)
      return match && match[7].length === 11 ? match[7] : false
    }
  }
}
</script>

<style lang="scss">
.artist-card {
  cursor: pointer;
  display: flex;
  position: relative;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
}

.arts-card-container {
  width: 100%;
  height: 200px;
  flex-direction: column;
  margin: 0 0.25em;
  overflow: hidden;
}

/* Bookmark ribbon */
.arts-card-tag {
  position: absolute;
  right: 0;
  top: 5px;
  border-top-left-radius: 20px;
  border-bottom-left-radius: 20px;
  border: 1px solid rgba(0, 0, 0, 0.5);
  border-right: 0;
  background: #b57936;
  width: 40%;
  padding: 2px;
  color: #fff;
  font-size: 13px;
  font-weight: bold;
  text-align: center;
  text-transform: capitalize;
}
.arts-card-tag img {
  width: 17px;
  height: 15px;
}

.arts-card-body {
  width: 100%;
  height: 150px;
  overflow: hidden;
}

.card-teaser-img {
  object-fit: fill;
  width: 100%;
  height: 100%;
}

.arts-card-footer {
  font-family: 'Lato', sans-serif;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  padding: 0.25em;
  height: auto;
}

.artist-name a {
  font-weight: normal;
  color: #007bff !important;

  &:hover {
    text-decoration: underline !important;
  }
}

/* Landscape Layout */
.arts-card-landscape {
  display: flex;
  width: 100%;
  height: 150px;
  padding: 0;
  border-radius: 0.25em;

  .arts-card-body {
    flex-basis: 45%;
    overflow: hidden;

    .card-teaser-img {
      object-fit: cover;
      width: 100%;
    }
    .card-teaser-null {
      object-fit: none;
      background-color: rgba(255, 255, 255, 0.8);
    }
  }

  .arts-card-right {
    flex-basis: 55%;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    box-sizing: border-box;
    padding-left: 0.5em;
    color: #151515;

    .arts-card-footer {
      .artist-title {
        width: 100%;
        max-height: 60px;
        overflow-wrap: break-word;
        word-wrap: break-word;
        overflow: hidden;

        font: Bold 16px/20px Proxima Nova;
        color: #151515;
        margin: 0.1em;
        padding: 0;
      }
      .artist-name {
        font-size: 0.7em;
        font-weight: 800;
        color: #707070;
      }
    }

    .arts-card-more {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .arts-card-tag {
        border-radius: 20px;
        position: initial;
        padding: 3px 8px;
        color: #fff;
        font-size: 0.8em;
        font-weight: 800;
        border: 0;
        width: auto;
      }

      .fpcc-card-more {
        width: 55px;
        background-color: #b57936;
        display: flex;
        align-items: center;
        height: 35px;
        justify-content: center;
        border-top-left-radius: 1em;
        border-bottom-left-radius: 1em;
      }
    }
  }

  &:hover {
    border: 1px solid #b57936;

    .fpcc-card-more {
      background-color: #3d3d3d !important;
    }
  }
}

.card-selected {
  border: 1px solid #b57936;
  transform: translateX(10px);

  .fpcc-card-more {
    background-color: #3d3d3d !important;
  }
}
</style>
