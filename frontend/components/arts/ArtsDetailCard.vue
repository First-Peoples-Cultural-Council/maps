<template>
  <div class="arts-detail-card">
    <Card>
      <template v-slot:header>
        <div
          class="arts-detail-icon-container"
          :style="'background-color:' + color"
        >
          <img
            v-if="arttype.toLowerCase() === 'art'"
            src="@/assets/images/public_art_icon.svg"
            alt="Arts"
          />
          <img
            v-else-if="arttype.toLowerCase() === 'event'"
            src="@/assets/images/event_icon.svg"
            alt="Event"
          />
          <img
            v-else-if="arttype.toLowerCase() === 'org'"
            src="@/assets/images/organization_icon.svg"
            alt="Organization"
          />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              {{ arttype }}
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold">
              {{ name }}
            </h5>
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
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
export default {
  components: {
    Card
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
    arttype: {
      type: String,
      default: 'Public Art'
    },
    server: {
      default: true,
      type: Boolean
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {
    handlePronounce() {
      console.log('Pronounce')
    },
    handleReturn() {
      if (this.isServer) {
        this.$router.push({
          path: '/art'
        })
      } else {
        this.$router.go(-1)
      }
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
  background-color: var(--color-beige);
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
  background-color: var(--color-darkgray);
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
</style>
