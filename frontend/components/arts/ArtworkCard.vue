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
          <span
            v-if="placename.artists && placename.artists.length !== 0"
            class="artist-name"
          >
            By
            <a
              v-for="artist in placename.artists"
              :key="artist"
              @click.stop.prevent="handleCardClick(artist)"
            >
              {{ artist }}</a
            >
          </span>
          <span v-else class="artist-name">
            By
            <a @click.stop.prevent="handleCardClick(placename.name)">
              {{ placename.name }}
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
    placename() {
      return this.mediaData.placename
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
        : this.returnMediaType === 'video'
        ? this.videoThumbnail
        : require('@/assets/images/artwork_icon.svg')
    },
    returnMediaType() {
      const type = this.mediaType
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

<style lang="scss"></style>
