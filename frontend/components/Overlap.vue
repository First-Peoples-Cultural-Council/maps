<template>
  <div
    class="overlap-map-container"
    @click="$bvToast.show('show-territory-overlap')"
  >
    <h5>ABOUT TERRITORY OVERLAP</h5>
    <b-toast id="show-territory-overlap" variant="warning" solid>
      <template #toast-title>
        <div class="d-flex flex-grow-1 align-items-baseline">
          <strong class="mr-auto">Notice!</strong>
        </div>
      </template>
      Boundaries in this map do not represent the overlap of language speakers,
      and not necessarily territory overlap.
    </b-toast>
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

      // if on grants page, reset current grants
      if (this.$route.name === 'index-grants') {
        this.$store.commit('grants/setCurrentGrant', null)
      }
    }
  }
}
</script>

<style>
.overlap-map-container {
  background-color: #0f2782;
  border: 1px solid #ddd5cc;
  cursor: pointer;
}
.overlap-map-container h5 {
  font-weight: 800;
  font-size: 15px;
  color: #fff;
  margin: 0;
  padding: 0.5em 0.75em;
  text-transform: uppercase;
}
</style>
