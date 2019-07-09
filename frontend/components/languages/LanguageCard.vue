<template>
  <div
    class="language-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card>
      <template v-slot:header>
        <div
          class="language-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/language_icon.svg" alt="Language" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              Languages
            </h5>
            <h5
              class="font-09 m-0 p-0 color-gray text-uppercase font-weight-bold"
            >
              {{ name }}
            </h5>
          </div>
          <div class="d-inline-block" @click.prevent.stop="handlePronounce">
            <CardBadge content="Pronounce"></CardBadge>
          </div>
        </div>
      </template>
      <template v-slot:footer>
        <div class="fpcc-card-more" @click.prevent="handleReturn">
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
      default: 'RGB(0, 0, 0)'
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

<style scoped>
.language-card {
  cursor: pointer;
}
.language-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.language-icon-container img {
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
