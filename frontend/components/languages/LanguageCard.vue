<template>
  <div
    class="language-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card :variant="variant">
      <template v-slot:header>
        <div
          class="language-icon-container"
          :style="'background-color:' + color"
          :class="{ 'icon-sm': icon === 'small' }"
        >
          <img src="@/assets/images/language_icon.svg" alt="Language" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-bold"
            >
              Language
            </h5>
            <h5
              class="font-09 m-0 p-0 color-gray font-weight-bold language-card-title"
            >
              {{ name }}
            </h5>
            <CardBadge
              v-if="pronounce"
              content="Pronounce"
              @click.native.prevent="
                handlePronounce(getAudio(pronounce.audio_file), 'pr')
              "
            ></CardBadge>
          </div>
        </div>
      </template>
      <template v-slot:footer>
        <div v-if="go">
          <div class="fpcc-card-more">
            <img
              v-if="!hover"
              src="@/assets/images/go_icon_hover.svg"
              alt="Go"
            />
            <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
          </div>
        </div>
      </template>
    </Card>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
import CardBadge from '@/components/CardBadge.vue'
import { getMediaUrl } from '@/plugins/utils.js'

export default {
  components: {
    Card,
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
    go: {
      type: Boolean,
      default: true
    },
    variant: {
      type: String,
      default: 'normal'
    },
    icon: {
      default: 'large',
      type: String
    },
    pronounce: {
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
  methods: {
    getAudio(file) {
      return getMediaUrl(file, !!process.server)
    },
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    },
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
    stopAudio() {
      if (this.audio) {
        this.audio.pause()
      }
    }
  }
}
</script>

<style scoped>
.language-card {
  cursor: pointer;
  background-color: white;
}
.language-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 52px;
  width: 52px;
}
.language-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #b47a2b;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: #00333a;
}

.language-icon-container.icon-sm {
  width: 30px;
  height: 30px;
}
</style>
