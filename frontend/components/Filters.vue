<template>
  <div class="filters-container pl-2 pr-2">
    <div class="cursor-pointer ml-1" @click="showCollapse = !showCollapse">
      <div>
        <img src="@/assets/images/filter_icon.svg" alt="Filter" />
        <span class="d-inline-block font-08">Filters</span>
      </div>
      <div></div>
    </div>
    <b-collapse id="filters" v-model="showCollapse" class="mt-2 pl-2 pr-2">
      <LayerToggle
        v-for="layer in layers"
        :id="layer.id"
        :key="'layer' + layer.id"
        class="mb-1"
        :name="layer.name"
        :layers="layer.layerNames"
        :initial="layer.active"
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
  },
  computed: {
    layers() {
      return this.$store.state.layers.layers
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
