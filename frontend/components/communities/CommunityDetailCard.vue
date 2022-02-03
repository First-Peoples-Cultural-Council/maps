<template>
  <div class="community-detail-card">
    <div class="community-container">
      <div
        class="community-detail-icon-container"
        :style="'background-color:' + color"
      >
        <img src="@/assets/images/community_icon.svg" alt="community" />
      </div>
      <div class="ml-2">
        <h5 class="field-kind">
          community
        </h5>
        <h5 class="field-name">
          {{ name }}
        </h5>
        <slot name="notification"></slot>
      </div>
    </div>

    <div class="arts-detail-text">
      <div v-if="audioFile" @click.prevent.stop="handlePronounce">
        <CardBadge content="Pronounce"></CardBadge>
      </div>
    </div>

    <div
      class="fpcc-card-more"
      @click.prevent="handleReturn"
      @mouseover.prevent="handleMouseOver"
      @mouseleave="handleMouseLeave"
    >
      <img
        v-if="!hover"
        class="ml-1"
        src="@/assets/images/return_icon_hover.svg"
        alt="Go"
      />
      <img
        v-else
        class="ml-1"
        src="@/assets/images/return_icon_hover.svg"
        alt="Go"
      />
      <span class="ml-1 font-weight-bold">Return</span>
    </div>
  </div>
</template>

<script>
import CardBadge from '@/components/CardBadge.vue'

export default {
  components: {
    CardBadge
  },
  props: {
    name: {
      type: String,
      default: ''
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    },

    server: {
      default: false,
      type: Boolean
    },
    audioFile: {
      default: '',
      type: String
    }
  },
  data() {
    return {
      hover: false
    }
  },
  mounted() {
    this.$root.$on('stopCommunityAudio', () => {
      this.stopAudio()
    })
  },
  methods: {
    handlePronounce() {
      if (this.audio && !this.audio.paused) {
        this.audio.pause()
        this.audio = null
        return
      }

      this.audio = new Audio(this.audioFile)

      if (this.audio.paused) {
        this.audio.play()
      } else {
        this.audio.pause()
      }
    },
    handleReturn() {
      this.$root.$emit('resetMap')
      if (this.server) {
        this.$router.push({
          path: '/first-nations'
        })
      } else {
        this.$router.go(-1)
      }
    },
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    },
    stopAudio() {
      if (this.audio) {
        this.audio.pause()
      }
    }
  }
}
</script>

<style scoped>
.community-detail-card {
  cursor: pointer;
  border-bottom: 3px solid #f9f9f9;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 1em 0 1em 1em;
  border-radius: 0.25em;
  position: relative;
}

.community-container {
  display: flex;
  align-items: center;
  margin-bottom: 1em;
}

.community-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 50px;
  width: 50px;
}
.community-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  width: 90px;
  background-color: #b47a2b;
  height: 35px;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
  z-index: 50000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1em;
  position: absolute;
  right: 0;
  top: 25%;
}

.fpcc-card-more:hover {
  color: white;
  background-color: #454545;
}

.fpcc-card-more img {
  display: inline-block;
  width: 15px;
  height: 15px;
}

.fpcc-card {
  border: 0;
  box-shadow: none;
}

.arts-detail-text {
  margin-left: 0.5em;
}

.field-kind {
  font-weight: 800;
  font-size: 15px;
  color: #707070;
  opacity: 1;
  text-transform: uppercase;
  margin: 0.1em;
  padding: 0;
}

.field-name {
  font-weight: 800;
  font-size: 16px;
  color: #151515;
  margin: 0.1em;
  padding: 0;
  letter-spacing: 0.5px;
}
</style>
