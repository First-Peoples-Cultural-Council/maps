<template>
  <b-dropdown
    id="dropdown-dropup"
    dropup
    text="Contribute"
    class="contribute-container"
    offset="-60"
  >
    <b-dropdown-item @click="handleDropDownClick($event, 'point')"
      >Add A Point marker</b-dropdown-item
    >
    <b-dropdown-item @click="handleDropDownClick($event, 'polygon')"
      >Add An Area Marker</b-dropdown-item
    >
  </b-dropdown>
</template>

<script>
export default {
  methods: {
    handleDropDownClick(e, data) {
      console.log('Data', data)
      this.$store.commit('contribute/setIsDrawMode', true)
      this.$router.push({
        path: '/contribute',
        query: {
          mode: data
        }
      })
    }
  }
}
</script>

<style>
.contribute-container button {
  background: url('../assets/images/contribute_texture_color.svg');
  border: 1px solid #ddd5cc;
  border-radius: 0.5em;
  cursor: pointer;
  font-size: 0.75em;
  margin: 0;
  padding: 0.5em 2em;
  color: white;
  font-weight: 700;
  text-transform: uppercase;
}

.contribute-container .btn-secondary:focus {
  box-shadow: none !important;
}

.contribute-container .btn-secondary:hover {
  color: white !important;
  box-shadow: none !important;
  background-color: #3c110d !important;
  border: 1px solid #ddd5cc;
}

.contribute-container.show > .btn-secondary.dropdown-toggle {
  color: white !important;
  box-shadow: none !important;
  background-color: #3c110d !important;
  border: 1px solid #ddd5cc;
}

.contribute-container button:hover {
  color: white !important;
}
</style>
