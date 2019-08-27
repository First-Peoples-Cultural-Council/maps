<template>
  <div
    class="community-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card :variant="variant">
      <template v-slot:header>
        <div
          class="community-icon-container"
          :style="'background-color:' + color"
          :class="{ 'icon-sm': icon === 'small' }"
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
              Community
            </h5>
            <h5
              class="font-09 m-0 p-0 color-gray font-weight-bold community-card-title"
            >
              {{ name }}
            </h5>
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
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    }
  }
}
</script>

<style>
.community-card {
  cursor: pointer;
}
.community-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.community-icon-container img {
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
.fpcc-card:hover .fpcc-card-more {
  background-color: #454545;
}

.community-icon-container.icon-sm {
  width: 30px;
  height: 30px;
}
</style>
