<template>
  <b-dropdown
    id="dropdown-dropup"
    dropup
    text="Contribute"
    class="contribute-container"
  >
    <b-dropdown-item href="#">Add A Point marker</b-dropdown-item>
    <b-dropdown-item href="#">Add An Area Marker</b-dropdown-item>
  </b-dropdown>
</template>

<script>
export default {}
</script>

<style>
.contribute-container button {
  background-color: #5d1a14;
  border: 1px solid #ddd5cc;
  border-radius: 0.2em;
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
}

.contribute-container.show > .btn-secondary.dropdown-toggle {
  color: white !important;
  box-shadow: none !important;
  background-color: #3c110d !important;
}

.contribute-container button:hover {
  color: white !important;
}
</style>
