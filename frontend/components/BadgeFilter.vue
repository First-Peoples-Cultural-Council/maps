<template>
  <div class="badge-filter-container">
    <slot name="badge"></slot>
    <div class="badge-filters">
      <p>choose sub-category</p>
    </div>
  </div>
</template>

<script>
export default {}
</script>

<style lang="scss">
.badge-filter-container {
  display: flex;
  position: relative;
  align-items: center;
  width: fit-content;
  border: 2px solid #5a8467;
  border-radius: 1em;
  background-color: #ededed;
  margin: 0.5em 0;
  height: fit-content;
}

.badge-filters {
  font-size: 12px;
  margin: 0 0.5em;
}

.badge-filters > p {
  margin: 0;
  font-weight: 500;
}
</style>
