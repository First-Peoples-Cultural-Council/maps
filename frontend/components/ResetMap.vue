<template>
  <div @click="resetMap">
    <h5>Reset Map</h5>
  </div>
</template>

<script>
export default {
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    }
  },
  methods: {
    resetMap() {
      this.$eventHub.whenMap(map => {
        map.setCenter([-121, 55])
        map.setZoom(5)
      })
    }
  }
}
</script>

<style></style>
