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
      this.$eventHub.whenMap(map => {
        map.flyTo({
          center: [-121, 55],
          zoom: 5
        })
      })
    }
  }
}
</script>

<style>
.reset-map-container {
  background-color: white;
  border: 1px solid #ddd5cc;
  border-radius: 0.2em;
  cursor: pointer;
}
.reset-map-control h5 {
  font-size: 0.75em;
  margin: 0;
  padding: 0.5em 0.75em;
  color: #7b7b7b;
  font-weight: 700;
  text-transform: uppercase;
}
</style>
