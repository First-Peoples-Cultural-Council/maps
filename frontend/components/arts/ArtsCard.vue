<template>
  <div
    class="arts-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card>
      <template v-slot:header>
        <div class="arts-icon-container" :style="'background-color:' + color">
          <img
            v-if="arttype.toLowerCase() === 'public_art'"
            src="@/assets/images/public_art_icon.svg"
            alt="Public Art"
          />
          <img
            v-else-if="arttype.toLowerCase() === 'artist'"
            src="@/assets/images/artist_icon.svg"
            alt="Artist"
          />
          <img
            v-else-if="arttype.toLowerCase() === 'organization'"
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
        <div class="fpcc-card-more">
          <img v-if="!hover" src="@/assets/images/go_icon_hover.svg" alt="Go" />
          <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
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
</style>
