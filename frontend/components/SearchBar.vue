<template>
  <div class="searchbar-container">
    <div class="searchbar-input-container">
      <b-form-input
        id="search-input"
        v-model="searchQuery"
        type="search"
        class="search-input"
        placeholder="Search for a language..."
        @update="handleSearchUpdate"
        @blur="handleSearchLeave"
      ></b-form-input>
      <b-popover
        target="search-input"
        placement="bottom"
        :show.sync="show"
        triggers=""
      >
        <template slot="title"
          >Content via Slots</template
        >
        Embedding content <span class="text-danger">using slots</span> affords
        you <em>greater <strong>control.</strong></em> and basic HTML support.
      </b-popover>
      <span class="searchbar-icon"></span>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      show: false,
      searchQuery: ''
    }
  },
  methods: {
    handleSearchUpdate() {
      console.log('Form Changed')
      if (this.searchQuery === '') {
        this.show = false
      } else {
        this.show = true
      }
    },
    handleSearchLeave() {
      this.show = false
    }
  }
}
</script>

<style>
.searchbar-container {
  position: fixed;
  top: 10px;
  left: calc(50% - 250px);
  width: 500px;
}
.searchbar-input-container {
  display: flex;
}
.searchbar-input {
  flex: 10 1 0;
  padding: 0.5em 1em;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-right: 0;
  outline: none;
}
.searchbar-icon {
  flex: 1 1 0;
  background-color: white;
  border-top-right-radius: 0.5em;
  border-bottom-right-radius: 0.5em;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-left: 0;
}
</style>
