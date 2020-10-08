<template>
  <div class="filter-container">
    <b-form-input
      id="search-artist-input"
      :value="searchQuery"
      type="search"
      class="search-input"
      :placeholder="filterPlaceholder()"
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
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    },
    filterMode() {
      return this.$store.state.arts.filter
    }
  },
  methods: {
    updateQuery(value) {
      if (this.isDrawerShown) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }
      this.$store.commit('arts/setArtSearch', value)
    },
    resetValue() {
      this.$store.commit('arts/setArtSearch', '')
    },
    filterPlaceholder() {
      const mode = this.filterMode
      if (mode === 'artwork') {
        return `Filter based of name, medium, and description...`
      } else {
        return `Filter based on ${
          mode === 'public_art' ? 'public art' : mode
        }'s name...`
      }
    }
  }
}
</script>

<style>
.filter-container {
  position: relative;
  display: flex;
  width: 90%;
  margin: 1em 1em 0.25em 1em;
}

@media (max-width: 993px) {
  .filter-container {
    width: 95% !important ;
    margin: 0 0 0.25em 0 !important;
  }
}

.search-input::placeholder {
  color: #707070;
  font-size: 15px;
  opacity: 1;
}

.search-input.form-control {
  border-radius: 3em;
  padding: 1.2em;
}

.search-icon {
  width: 16px;
  height: 16px;
  position: absolute;
  right: 15px;
  top: 30%;
  margin-left: 0.5em;
}
</style>
