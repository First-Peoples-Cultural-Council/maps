<template>
  <div>
    <EmbedOptionToggle
      v-if="routeName === 'index-languages-lang'"
      text="Show Other Languages"
      prop="sol"
      :default-value="true"
    >
    </EmbedOptionToggle>
    <EmbedOptionToggle text="Show Communities" prop="sc" :default-value="true">
    </EmbedOptionToggle>
    <EmbedOptionToggle
      v-if="routeName === 'index-languages-lang' && sc"
      text="Show Communities Outside Language"
      prop="scol"
      :default-value="true"
    >
    </EmbedOptionToggle>
    <EmbedOptionToggle
      text="Show Arts Map Points"
      prop="sap"
      :default-value="true"
    >
    </EmbedOptionToggle>
    <EmbedOptionToggle
      text="Show Heritage Points"
      prop="shp"
      :default-value="true"
    >
    </EmbedOptionToggle>
    <EmbedOptionToggle
      text="Lock Area Based on Current View"
      prop="lb"
      :default-value="false"
    >
    </EmbedOptionToggle>
  </div>
</template>

<script>
import EmbedOptionToggle from '@/components/EmbedOptionToggle.vue'

export default {
  components: {
    EmbedOptionToggle
  },
  props: {
    sc: {
      type: Boolean,
      default: null
    }
  }
}
</script>

<style></style>
