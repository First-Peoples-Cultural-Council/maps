<template>
  <div class="current-location-container" @click="getLocation">
    <h5>Go to my location</h5>
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
    getLocation() {
      this.$root.$emit('getLocation')
    }
  }
}
</script>

<style>
.current-location-container {
  background-color: white;
  border: 1px solid #ddd5cc;
  border-radius: 3em;
  cursor: pointer;
}
.current-location-control h5 {
  font: Bold 15px/18px Proxima Nova;
  color: #151515;
  margin: 0;
  padding: 0.5em 0.75em;
  text-transform: uppercase;
}
</style>
