<template>
  <div class="arts-detail-card">
    <Card>
      <template v-slot:header>
        <div
          class="arts-detail-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/poi_icon.svg" alt="Places" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
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
                This content has not been verified by a community member or
                FPCC. Please use "Report" it if it needs to be corrected or
                removed
              </b-tooltip>
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold place-name">
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
      </template>
      <template v-slot:footer>
        <div class="fpcc-card-more-art" @click.prevent="handleReturn">
          <img
            v-if="!hover"
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
      </template>
    </Card>
    <b-modal v-model="modalShow" hide-header @ok="handleDelete"
      >Are you sure you want to delete this place?</b-modal
    >
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
import CardBadge from '@/components/CardBadge.vue'
import { getApiUrl, getCookie } from '@/plugins/utils.js'

export default {
  components: {
    Card,
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
    }
  }
}
</script>

<style scoped>
.arts-detail-card {
  cursor: pointer;
}
.arts-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.arts-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more-art {
  background-color: var(--color-beige, #f4eee9);
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}

.fpcc-card-more-art {
  padding: 0.3em;
  font-size: 0.7em;
}

.fpcc-card-more-art:hover {
  color: white;
  background-color: #454545;
}

.fpcc-card-more-art img {
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
</style>
