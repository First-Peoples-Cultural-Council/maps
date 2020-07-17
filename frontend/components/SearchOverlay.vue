<template>
  <div v-if="show">
    <div class="searchbar-overlay-container">
      <SearchBar class="mt-3" :mobile="true"></SearchBar>
    </div>
  </div>
</template>
<script>
import SearchBar from '@/components/SearchBar.vue'
export default {
  components: {
    SearchBar
  },
  props: {
    show: {
      default: false,
      type: Boolean
    }
  },
  data() {
    return {
      showOverlay: this.show
    }
  }
}
</script>
<style>
.searchbar-overlay-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  z-index: 5000;
  background-color: white;
}
</style>
