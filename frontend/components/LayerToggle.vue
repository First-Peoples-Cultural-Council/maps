<template>
  <div>
    <div class="cursor-pointer" @click="toggleLayer">
      <span class="font-08 d-inline-block"> {{ layer.name }}</span>
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
      this.$eventHub.whenMap(map => {
        this.$store.commit('layers/toggleLayer', {
          layer: this.layer,
          map
        })
      })
    }
  }
}
</script>

<style></style>
