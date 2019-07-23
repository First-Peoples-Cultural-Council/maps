<template>
  <div class="filters-container pl-2 pr-2">
    <div class="cursor-pointer ml-1" @click="showCollapse = !showCollapse">
      <img src="@/assets/images/filter_icon.svg" alt="Filter" />
      <span class="d-inline-block font-08">Filters</span>
    </div>
    <b-collapse id="filters" v-model="showCollapse" class="mt-2 pl-2 pr-2">
      <LayerToggle
        layer-name="Language Regions"
        layer="fn-lang-areas-highlighted"
        class="mb-1"
      ></LayerToggle>
    </b-collapse>
  </div>
</template>

<script>
import LayerToggle from '@/components/LayerToggle.vue'
export default {
  components: {
    LayerToggle
  },
  data() {
    return {
      showCollapse: false
    }
  }
}
</script>

<style>
.filters-container {
  padding-bottom: 0.5em;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.1);
  color: #737373;
}
</style>
