<template>
  <div class="community-detail-card">
    <Card>
      <template v-slot:header>
        <div
          class="community-detail-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/community_icon.svg" alt="community" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              community
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold comm-name">
              {{ name }}
            </h5>
          </div>
          <div v-if="audioFile" @click.prevent.stop="handlePronounce">
            <CardBadge content="Pronounce"></CardBadge>
          </div>
          <div v-if="population" class="d-inline-block">
            <span class="d-inline-block font-weight-bold font-08"
              >Population</span
            ><span class="ml-1 font-08">{{ population }}</span>
          </div>
        </div>
      </template>
      <template v-slot:footer>
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
      </template>
    </Card>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
import CardBadge from '@/components/CardBadge.vue'

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
      default: 'RGB(255, 255, 255)'
    },
    population: {
      type: Number,
      default: null
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
}
.community-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.community-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #c46156;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}

.fpcc-card-more {
  padding: 0.3em;
  font-size: 0.7em;
  color: white;
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
</style>
