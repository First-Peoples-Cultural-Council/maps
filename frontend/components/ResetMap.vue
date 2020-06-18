<template>
  <div class="reset-map-container " @click="resetMap">
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
      this.$root.$emit('resetMap')
    }
  }
}
</script>

<style>
.reset-map-container {
  background-color: white;
  border: 1px solid #ddd5cc;
  border-radius: 3em;
  cursor: pointer;
}
.reset-map-control h5 {
  font: Bold 15px/18px Proxima Nova;
  color: #151515;
  margin: 0;
  padding: 0.5em 0.75em;
  text-transform: uppercase;
}
</style>
