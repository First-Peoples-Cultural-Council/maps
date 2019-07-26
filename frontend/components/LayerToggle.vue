<template>
  <div>
    <div class="cursor-pointer" @click="toggleLayer">
      <span class="font-08 d-inline-block"> {{ name }}</span>
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
    name: {
      default: '',
      type: String
    },
    layerNames: {
      default: function() {
        return []
      },
      type: Array
    },
    initial: {
      type: Boolean,
      default: true
    },
    id: {
      type: Number,
      default: null
    }
  },
  computed: {
    layers() {
      return this.$store.state.layers.layers
    },
    layer() {
      return this.layers.find(l => l.id === this.id)
    },
    on() {
      return this.layer.active
    }
  },
  methods: {
    toggleLayer() {
      this.$store.commit('layers/toggleLayer', this.layer)
      console.log('Toggle layiner')
      this.$eventHub.whenMap(map => {
        if (map) {
          if (this.on) {
            this.layer.layerNames.map(l => {
              map.setLayoutProperty(l, 'visibility', 'visible')
            })
          } else {
            this.layer.layerNames.map(l => {
              map.setLayoutProperty(l, 'visibility', 'none')
            })
          }
        }
      })
    }
  }
}
</script>

<style></style>
