<template>
  <div class="language-card">
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
              Language
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
          <div class="d-inline-block">
            <CardBadge content="Share & Embed"></CardBadge>
          </div>
        </div>
      </template>
      <template v-slot:footer>
        <div class="fpcc-card-more">
          <img v-if="!hover" src="@/assets/images/return_icon.svg" alt="Go" />
          <img v-else src="@/assets/images/return_icon_hover.svg" alt="Go" />
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
      default: 'RGB(0, 0, 0)'
    }
  },
  methods: {
    handlePronounce() {
      console.log('Pronounce')
    }
  }
}
</script>

<style scoped>
.language-card {
  cursor: pointer;
}
.language-icon-container {
  background-color: red;
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
  padding: 0.3em;
  font-size: 0.7em;
}

.language-card:hover .fpcc-card-more {
  color: white;
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
