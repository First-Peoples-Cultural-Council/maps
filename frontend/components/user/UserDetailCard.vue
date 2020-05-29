<template>
  <div class="user-detail-card">
    <div
      class="user-detail-icon-container"
      :style="'background-color:' + color"
    >
      <img src="@/assets/images/language_icon.svg" alt="Language" />
    </div>

    <div class="arts-detail-text">
      <h5 class="field-kind">
        User
      </h5>
      <h5 class="field-name">
        {{ name }}
      </h5>
      <div v-if="edit && id" class="d-inline-block">
        <CardBadge
          content="Edit"
          type="edit"
          @click.native="
            $router.push({
              path: `/profile/edit/${id}`
            })
          "
        ></CardBadge>
      </div>
      <div v-if="approval && id" class="d-inline-block">
        <CardBadge
          content="Approval"
          type="edit"
          @click.native="
            $router.push({
              path: `/profile/approvals`
            })
          "
        ></CardBadge>
      </div>
    </div>

    <div
      class="fpcc-card-more"
      @click.prevent="handleReturn"
      @mouseover.prevent="handleMouseOver"
      @mouseleave="handleMouseLeave"
    >
      <img
        v-if="hover"
        class="ml-1"
        src="@/assets/images/return_icon.svg"
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
    link: {
      type: String,
      default: ''
    },
    edit: {
      type: Boolean,
      default: null
    },
    id: {
      type: Number,
      default: null
    },
    approval: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    comingFromDetail() {
      return this.$store.state.languages.comingFromDetail
    }
  },
  methods: {
    handlePronounce() {
      this.audio = this.audio || new Audio(this.audioFile)
      if (this.audio.paused) {
        this.audio.play()
      } else {
        this.audio.pause()
      }
    },
    handleReturn() {
      this.$router.push({ path: '/languages' })
    },
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    }
  }
}
</script>

<style scoped>
.user-detail-card {
  border-bottom: 3px solid #f9f9f9;
  display: flex;
  justify-content: flex-start;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 1em 0 1em 1em;
  border-radius: 0.25em;
  position: relative;
}
.user-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 50px;
  width: 50px;
}
.user-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}

.arts-detail-text {
  margin-left: 0.5em;
  width: 65%;
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
