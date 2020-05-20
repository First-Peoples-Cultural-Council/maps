<template>
  <div class="arts-detail-card">
    <div
      class="arts-detail-icon-container"
      :style="'background-color:' + color"
    >
      <img src="@/assets/images/poi_icon.svg" alt="Places" />
    </div>

    <div class="arts-detail-text">
      <div>
        <h5 class="field-kind">
          {{ type }}
          <b-badge
            v-if="status"
            id="tooltip-target-1"
            class="place-status-badge d-inline-block ml-1"
            :variant="getVariant(status)"
            >{{ status | filterStatus }}</b-badge
          >
          <b-tooltip
            v-if="status === 'UN'"
            target="tooltip-target-1"
            triggers="hover"
          >
            This content has not been verified by a community member or FPCC.
            Please use "Report" it if it needs to be corrected or removed
          </b-tooltip>
        </h5>
        <h5 class="field-name">
          {{ name }}
        </h5>
      </div>
      <div
        v-if="audioFile"
        class="d-inline-block"
        @click.prevent.stop="handlePronounce"
      >
        <CardBadge
          content="Pronounce"
          :class="{ 'md-size-badge': variant === 'md' }"
        ></CardBadge>
      </div>
      <div v-if="allowEdit" class="d-inline-block">
        <CardBadge
          content="Edit"
          type="edit"
          :class="{ 'md-size-badge': variant === 'md' }"
          @click.native="handleEdit"
        ></CardBadge>
      </div>
      <div v-if="deletePlace" class="d-inline-block">
        <CardBadge
          content="Delete"
          type="delete"
          :class="{ 'md-size-badge': variant === 'md' }"
          @click.native="modalShow = true"
        ></CardBadge>
      </div>
    </div>

    <div class="fpcc-card-more" @click.prevent="handleReturn">
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
    <b-modal v-model="modalShow" hide-header @ok="handleDelete"
      >Are you sure you want to delete this place?</b-modal
    >
  </div>
</template>

<script>
import CardBadge from '@/components/CardBadge.vue'
import { getApiUrl, getCookie } from '@/plugins/utils.js'

export default {
  components: {
    CardBadge
  },
  filters: {
    filterStatus(d) {
      return {
        UN: 'Unverified',
        RE: 'Rejected',
        VE: 'Verified',
        FL: 'Flagged'
      }[d]
    }
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
    type: {
      type: String,
      default: 'Point Of Interest'
    },
    server: {
      type: Boolean,
      default: false
    },
    audioFile: {
      type: String,
      default: null
    },
    id: {
      type: Number,
      default: null
    },
    allowEdit: {
      type: Boolean,
      default: false
    },
    variant: {
      type: String,
      default: 'sm'
    },
    deletePlace: {
      type: Boolean,
      default: false
    },
    status: {
      default: '',
      type: String
    }
  },
  data() {
    return {
      hover: false,
      modalShow: false,
      audio: null
    }
  },
  mounted() {
    this.$root.$on('stopPlaceAudio', () => {
      this.stopAudio()
    })
  },
  methods: {
    getVariant(status) {
      return {
        UN: 'info',
        RE: 'danger',
        VE: 'primary',
        FL: 'warning'
      }[status]
    },
    handlePronounce() {
      if (this.audio && !this.audio.paused) {
        this.audio.pause()
        this.audio = null
        return
      }

      this.audio = this.audio || new Audio(this.audioFile)

      if (this.audio.paused) {
        this.audio.play()
      } else {
        this.audio.pause()
      }
    },
    handleReturn() {
      if (this.server) {
        this.$router.push({
          path: '/heritages'
        })
      } else {
        this.$router.go(-1)
      }
    },
    handleEdit() {
      this.$router.push({
        path: '/contribute',
        query: {
          mode: 'existing',
          id: this.id
        }
      })
    },
    async handleDelete(e) {
      e.preventDefault()
      await this.$axios.$delete(`${getApiUrl(`placename/${this.id}`)}`, {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      })
      this.modalShow = false
      this.$router.push({
        path: `/heritages`
      })
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
.arts-detail-card {
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
.arts-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 50px;
  width: 50px;
}
.arts-detail-icon-container img {
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

.md-size-badge {
  margin-top: 0.25em;
  font-size: 1em;
  padding: 0.5em;
}

.place-status-badge {
  border-radius: 0.2em;
  font-size: 1.1em;
  text-transform: none;
}

.place-status-badge.badge-info {
  background-color: #cccccc;
  color: #707070;
}

.place-status-badge.badge-danger {
  background-color: #c46257;
  color: white;
}

.place-status-badge.badge-warning {
  background-color: #e6a000;
  color: white;
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
