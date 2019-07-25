<template>
  <div>
    <div class="cursor-pointer" @click="toggleLayer">
      <span class="font-08 d-inline-block"> {{ layerName }}</span>
      <span class="float-right">
        <img v-if="on" src="@/assets/images/on.svg" alt="On" />
        <img v-else src="@/assets/images/off.svg" alt="Off" />
      </span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    layerName: {
      default: '',
      type: String
    },
    layers: {
      default: function() {
        return []
      },
      type: Array
    },
    initial: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      on: this.initial
    }
  },
  methods: {
    toggleLayer() {
      this.on = !this.on
      this.$eventHub.whenMap(map => {
        if (map) {
          if (this.on) {
            this.layers.map(l => {
              map.setLayoutProperty(l, 'visibility', 'visible')
            })
          } else {
            this.layers.map(l => map.setLayoutProperty(l, 'visibility', 'none'))
          }
        }
      })
    }
  }
}
</script>

<style></style>
