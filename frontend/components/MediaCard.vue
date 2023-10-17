<template>
  <div
    class="artist-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <!-- Render if Media -->
    <div v-if="isMedia" class="arts-card-landscape">
      <div class="arts-card-body">
        <img
          v-lazy="artImage"
          :class="`card-teaser-img ${mediaExist ? '' : 'card-teaser-null'}`"
          oncontextmenu="return false;"
        />
      </div>
      <div class="arts-card-right">
        <div class="arts-card-footer">
          <span class="artist-title"> {{ media.name }} </span>
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
    <!-- Render if Public Art -->
    <div v-else class="arts-card-landscape">
      <div class="arts-card-body">
        <img
          v-if="media.image"
          v-lazy="getMediaUrl(media.image)"
          :class="`card-teaser-img`"
        />
        <img
          v-else
          :src="require(`@/assets/images/public_art_icon.svg`)"
          class="public-art-placeholder"
        />
      </div>
      <div class="arts-card-right">
        <div class="arts-card-footer">
          <span class="artist-title"> {{ media.name }} </span>
        </div>
        <div class="arts-card-more">
          <div class="arts-card-tag">
            <img src="@/assets/images/arts/image.png" />
            Public Art
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
import { getMediaUrl } from '@/plugins/utils.js'
export default {
  props: {
    media: {
      type: Object,
      default: () => {
        return {}
      }
    },
    geometry: {
      type: Object,
      default: () => {
        return {}
      }
    },
    type: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    isMedia() {
      return this.type === 'media'
    },
    videoThumbnail() {
      return `https://img.youtube.com/vi/${this.getYoutubeVideoID(
        this.media.url
      )}/hqdefault.jpg`
    },
    artImage() {
      return this.mediaExist
        ? getMediaUrl(this.media.media_file)
        : this.returnMediaType === 'video'
        ? this.videoThumbnail
        : require('@/assets/images/artwork_icon.svg')
    },
    returnMediaType() {
      const type = this.media.file_type
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
    },
    mediaExist() {
      return this.media.media_file !== null
    }
  },
  methods: {
    getMediaUrl,
    handleMouseOver() {
      this.hover = true
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.geometry) return
      this.$eventHub.revealArea(this.geometry)
    },
    handleMouseLeave() {
      this.hover = false
      // in some cases, we list places without full geometry, no marker shown.
      if (!this.geometry) return
      this.$eventHub.doneReveal()
    },
    onImageError(event) {
      event.target.src = '@/assets/images/public_art_icon.svg'
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
.arts-card-landscape {
  background-color: #fff;
}
.public-art-placeholder {
  width: 100%;
  height: 100%;
  padding: 16px;
  object-fit: contain;
}
</style>
