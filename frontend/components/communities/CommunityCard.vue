<template>
  <div class="community-card">
    <Card>
      <template v-slot:header>
        <div
          class="community-icon-container"
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
              Community
            </h5>
            <h5
              class="font-09 m-0 p-0 color-gray text-uppercase font-weight-bold"
            >
              {{ name }}
            </h5>
          </div>
          <div class="d-inline-block" @click.prevent="handlePronounce">
            <CardBadge content="Pronounce"></CardBadge>
          </div>
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
    }
  },
  methods: {
    handlePronounce() {
      console.log('Pronounce')
    }
  }
}
</script>

<style>
.community-card {
  cursor: pointer;
}
.community-icon-container {
  background-color: red;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.community-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
</style>
