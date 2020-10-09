<template>
  <div class="community-card">
    <Card :variant="variant">
      <template v-slot:header>
        <div
          class="community-icon-container"
          :style="'background-color:' + color"
          :class="{ 'icon-sm': icon === 'small' }"
        >
          <img src="@/assets/images/grant_icon.svg" alt="community" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <h5 class="field-kinds">
            Grants
          </h5>
          <h5 class="field-names">
            {{ grant.properties.name }}
          </h5>
        </div>
      </template>
      <template v-slot:footer>
        <div v-if="go" class="fpcc-card-more">
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
    grant: {
      type: Object,
      default: () => {
        return {}
      }
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
  methods: {}
}
</script>

<style>
.community-card {
  cursor: pointer;
}
.community-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 30px;
  width: 30px;
}
.community-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #b47a2b;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: #00333a;
}

.community-icon-container.icon-sm {
  width: 30px;
  height: 30px;
}
</style>
