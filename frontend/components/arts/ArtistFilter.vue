<template>
  <div class="filter-container">
    <b-form-input
      id="search-artist-input"
      :value="searchQuery"
      type="search"
      class="search-input"
      placeholder="Search for a person, artwork, event..."
      autocomplete="off"
      @input="updateQuery"
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
export default {
  computed: {
    searchQuery() {
      return this.$store.state.arts.artSearch
    }
  },
  methods: {
    updateQuery(value) {
      this.$store.commit('arts/setArtSearch', value)
    },
    resetValue() {
      this.$store.commit('arts/setArtSearch', '')
    }
  }
}
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
  opacity: 1;
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
