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
  border-radius: 0.2em;
  cursor: pointer;
}
.current-location-control h5 {
  font-size: 0.75em;
  margin: 0;
  padding: 0.5em 0.75em;
  color: #7b7b7b;
  font-weight: 700;
  text-transform: uppercase;
}
</style>
