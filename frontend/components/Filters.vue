<template>
  <div class="filters-container pl-3 pr-3">
    <div class="cursor-pointer ml-1" @click="showCollapse = !showCollapse">
      <div>
        <img src="@/assets/images/filter_icon.svg" alt="Filter" />
        <span class="d-inline-block font-08">Filter Layers</span>
        <div class="float-right" style="line-height: 20px;">
          <img
            v-if="!showCollapse"
            src="@/assets/images/arrow_down_icon.svg"
            alt="Open"
          />
          <img v-else src="@/assets/images/arrow_up_icon.svg" alt="Close" />
        </div>
      </div>
    </div>
    <b-collapse id="filters" v-model="showCollapse" class="mt-2 pl-2 pr-2">
      <LayerToggle
        v-for="layer in layers"
        :id="layer.id"
        :key="'layer' + layer.id"
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
  padding: 0.25em 0 0.75em 0;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.1);
  color: #737373;
}
</style>
