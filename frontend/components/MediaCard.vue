<template>
  <div
    class="artist-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <!-- Landscape View Mode -->
    <div class="arts-card-landscape">
      <div class="arts-card-body">
        <img
          :class="`card-teaser-img ${mediaExist ? '' : 'card-teaser-null'}`"
          :src="artImage"
        />
      </div>
      <div class="arts-card-right">
        <div class="arts-card-footer">
          <span class="artist-title"> {{ media.name }} </span>
        </div>
        <div class="arts-card-more">
          <div class="arts-card-tag">
            <img :src="returnMediaType" />
            {{ media.file_type }}
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
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    artImage() {
      return this.mediaExist
        ? this.media.media_file
        : require('@/assets/images/public_art_icon.svg')
    },
    returnMediaType() {
      const type = this.media.file_type ? this.media.file_type : 'audio'
      return require(`@/assets/images/arts/${type}.png`)
    },
    mediaExist() {
      return this.media.media_file !== null
    }
  },
  methods: {
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
    }
  }
}
</script>

<style lang="scss"></style>
