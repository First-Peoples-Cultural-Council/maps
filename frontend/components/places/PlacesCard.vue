<template>
  <div
    class="community-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card>
      <template v-slot:header>
        <div
          class="community-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/poi_icon.svg" alt="community" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              Point Of Interest
            </h5>
            <h5 class="font-09 m-0 p-0 color-gray font-weight-bold">
              {{ name }}
            </h5>
          </div>
          <div class="d-inline-block">
            <CardBadge content="Pronounce"></CardBadge>
          </div>
        </div>
      </template>
      <template v-slot:footer>
        <div class="fpcc-card-more">
          <img v-if="!hover" src="@/assets/images/go_icon.svg" alt="Go" />
          <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
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
      default: 'transparent'
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

<style></style>
