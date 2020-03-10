<template>
  <div class="filter-container">
    <b-badge class="badge filter-selected">
      <span class="badge-content">Artworks Only</span>
    </b-badge>
    <b-badge class="badge ">
      <span class="badge-content ">Show All</span>
    </b-badge>
  </div>
</template>

<script>
export default {}
</script>

<style>
.filter-container {
  display: flex;
  width: 100%;
  background-color: #eee;
  margin: 0.5em 0;
  border-radius: 1em;
}

.filter-container > .badge {
  flex: 1 1;
  padding: 0.5em;
  margin: 1px;
  background-color: #eee;
  color: #000;
  font-weight: bold;
  transition: 0.5s ease-in;
}

.badge.filter-selected {
  background-color: #b57936;
  color: #fff;
}
</style>
