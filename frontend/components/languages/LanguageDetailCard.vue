<template>
  <div class="language-detail-card">
    <div
      class="language-detail-icon-container"
      :style="'background-color:' + color"
    >
      <img src="@/assets/images/language_icon.svg" alt="Language" />
    </div>

    <div class="arts-detail-text">
      <div>
        <h5 class="field-kind">
          Language
        </h5>
        <h5 class="field-name">
          {{ name }}
        </h5>
      </div>
      <div v-if="audioFile" @click.prevent.stop="handlePronounce">
        <CardBadge content="Pronounce"></CardBadge>
      </div>
      <CardBadge
        v-if="link"
        type="learn"
        content="Learn Language"
        :link="link"
      ></CardBadge>
      <div
        v-if="audioFile"
        class="d-inline-block"
        @click.prevent.stop="handlePronounce(audioFile, 'pr')"
      >
        <CardBadge content="Pronounce"></CardBadge>
      </div>
      <div
        v-if="greetingFile"
        class="d-inline-block"
        @click.prevent.stop="handlePronounce(greetingFile, 'gr')"
      >
        <CardBadge content="Greeting"></CardBadge>
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
import { encodeFPCC } from '@/plugins/utils.js'

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
      default: 'RGB(0, 0, 0)'
    },
    detail: {
      type: Boolean,
      default: false
    },
    server: {
      type: Boolean,
      default: false
    },
    audioFile: {
      type: String,
      default: null
    },
    greetingFile: {
      type: String,
      default: null
    },
    link: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      hover: false,
      audio: null,
      audioType: null
    }
  },
  computed: {
    comingFromDetail() {
      return this.$store.state.languages.comingFromDetail
    }
  },
  mounted() {
    this.$root.$on('stopLanguageAudio', () => {
      this.stopAudio()
    })
  },
  methods: {
    handlePronounce(af, at) {
      const audioFile = af
      const audio = new Audio(audioFile)
      if (this.audioType === at && this.audio && !this.audio.paused) {
        this.audio.pause()
        return
      }
      this.stopAudio()

      this.audio = audio
      this.audioType = at

      if (this.audio.paused) {
        this.audio.play()
      } else {
        this.audio.pause()
      }
    },
    handleReturn() {
      if (!this.detail) {
        if (this.server) {
          this.$router.push({ path: '/languages' })
        } else if (this.comingFromDetail) {
          this.$router.push({ path: '/languages' })
          this.$store.commit('languages/setComingFromDetail', false)
        } else {
          this.$router.go(-1)
        }
      } else {
        this.$store.commit('languages/setComingFromDetail', true)
        this.$router.push({
          path: `/languages/${encodeFPCC(this.$route.params.lang)}`
        })
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
    },
    isAudioPlaying() {
      if (this.audio) {
        return (
          this.audio.paused && this.audio.currentTime > 0 && !this.audio.ended
        )
      }
      return false
    }
  }
}
</script>

<style scoped>
.language-detail-card {
  cursor: pointer;
  border-bottom: 3px solid #f9f9f9;
  display: flex;
  justify-content: flex-start;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 1em 0 1em 1em;
  border-radius: 0.25em;
  position: relative;
}
.language-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 50px;
  width: 50px;
}
.language-detail-icon-container img {
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
  width: 65%;
}

.field-kind {
  font: Bold 15px/18px Proxima Nova;
  color: #707070;
  opacity: 1;
  text-transform: uppercase;
  margin: 0.1em;
  padding: 0;
}

.field-name {
  font: Bold 16px/20px Proxima Nova;
  color: #151515;
  margin: 0.1em;
  padding: 0;
  letter-spacing: 0.5px;
}
</style>
