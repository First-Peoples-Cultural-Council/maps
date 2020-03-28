<template>
  <div
    class="artist-card"
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
          :class="`card-teaser-img ${mediaExist ? '' : 'card-teaser-null'}`"
          :src="artImage"
        />
      </div>
      <div class="arts-card-right">
        <div class="arts-card-footer">
          <span class="artist-title"> {{ mediaData.name }} </span>
          <span class="artist-name" v-html="returnArtists" />
        </div>
        <div class="arts-card-more">
          <div class="arts-card-tag">
            <img :src="returnMediaType" />
            {{ mediaType }}
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
import { encodeFPCC } from '@/plugins/utils.js'

export default {
  props: {
    art: {
      type: Object,
      default: () => {
        return {}
      }
    },
    layout: {
      type: String,
      default: 'tile'
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    mediaData() {
      return this.art.medias[0]
    },
    artist() {
      return this.art.artists
    },
    mediaType() {
      return this.mediaData.file_type
    },
    isLayoutTile() {
      return this.layout !== 'landscape'
    },
    mediaExist() {
      return this.mediaData.media_file !== null
    },
    artImage() {
      return this.mediaExist
        ? this.mediaData.media_file
        : require('@/assets/images/public_art_icon.svg')
    },
    returnArtists() {
      const listOfArtist =
        this.artist.length !== 0
          ? this.artist.map((artist, index) => {
              return `<a href="art/${encodeFPCC(artist.name)}"> ${
                artist.name
              }</a>`
            })
          : 'Unknown'
      return `By ${listOfArtist}`
    },
    returnMediaType() {
      let mediaType = ''
      switch (this.mediaType) {
        case 'youtube':
          mediaType = 'video'
          return true
        case 'default' || 'text':
          mediaType = 'image'
          return true
        default:
          mediaType = this.mediaType
      }
      return require(`@/assets/images/arts/${mediaType}.png`)
    }
  },
  methods: {
    handleCardClick($event, name, type) {
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    handleMouseOver() {
      this.hover = true
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.art.geometry) return
      this.$eventHub.revealArea(this.art.geometry)
    },
    handleMouseLeave() {
      this.hover = false
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.art.geometry) return
      this.$eventHub.doneReveal()
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
  width: 12.5px;
  height: 12.5px;
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

.artist-title {
  font-size: 14px;
  font-weight: bold;
  color: #707070;
  margin: 0;
}

.artist-name {
  font-size: 13px;
  font-weight: normal;
  color: #c3bfbc;
  margin: 0;
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
      object-fit: fill;
      object-position: 50% 50%;
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

    .arts-card-footer {
      .artist-title {
        width: 150px;
        overflow-wrap: break-word;
        word-wrap: break-word;

        font-size: 0.8em;
        font-weight: 800;
      }
      .artist-name {
        font-size: 0.7em;
        font-weight: 800;
      }
    }

    .arts-card-more {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .arts-card-tag {
        border-radius: 20px;
        position: initial;
        padding: 2px;
        color: #fff;
        font-size: 0.6em;
        font-weight: 800;
        text-align: center;
        border: 0;
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

      .artist-card:hover .fpcc-card-more {
        background-color: #454545;
      }
    }
  }

  &:hover {
    border: 1px solid #b57936;
  }
}
</style>
