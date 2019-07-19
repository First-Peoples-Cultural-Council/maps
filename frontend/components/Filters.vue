<template>
  <div>
    <div class="pl-2 pr-2 cursor-pointer" @click="showCollapse = !showCollapse">
      <img src="@/assets/images/filter_icon.svg" alt="Filter" />
      <span>Filters</span>
    </div>
    <b-collapse id="filters" v-model="showCollapse" class="mt-2 pl-2 pr-2">
      <LayerToggle layer-name="Language Regions"></LayerToggle>
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

<style></style>
