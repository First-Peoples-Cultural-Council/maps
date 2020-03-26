<template>
  <div class="filter-container">
    <b-form-input
      id="search-input"
      type="search"
      class="search-input"
      placeholder="Search for a person, artwork, event..."
      autocomplete="off"
    >
    </b-form-input>
    <img
      class="search-icon"
      src="@/assets/images/search_icon.svg"
      alt="Search"
    />
  </div>
</template>

<script>
export default {}
</script>

<style>
.filter-container {
  display: flex;
  width: 90%;
  position: relative;
}

.search-input::placeholder {
  color: #707070;
  font-size: 16px;
  opacity: 0.5;
}

.search-input.form-control {
  border-radius: 3em;
  padding: 1.2em;
}

.search-icon {
  width: 18px;
  height: 18px;
  position: absolute;
  right: 20px;
  top: 30%;
  margin-left: 0.5em;
}
</style>
