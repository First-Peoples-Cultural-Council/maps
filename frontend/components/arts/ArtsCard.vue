<template>
  <div
    class="arts-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card>
      <template v-slot:header>
        <div class="arts-icon-container" :style="'background-color:' + color">
          <img src="@/assets/images/public_art_icon.svg" alt="Arts" />
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
            <h5
              class="font-09 m-0 p-0 color-gray text-uppercase font-weight-bold"
            >
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
    arttype: {
      type: String,
      default: 'Public Art'
    },
    name: {
      type: String,
      default: ''
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {
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
.arts-card {
  cursor: pointer;
}
.arts-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.arts-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: var(--color-beige);
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: var(--color-darkgray);
}
</style>
