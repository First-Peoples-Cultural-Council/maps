<template>
  <div class="cursor-pointer" @click="toggleEmbedOption">
    <span class="font-09 d-inline-block">{{ text }}</span>
    <span class="float-right">
      <img v-if="active" src="@/assets/images/on.svg" alt="On" />
      <img v-else src="@/assets/images/off.svg" alt="Off" />
    </span>
  </div>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      default: null
    },
    prop: {
      type: String,
      default: null
    },
    defaultValue: {
      type: Boolean,
      default: null
    }
  },
  data() {
    return {
      active: this.defaultValue
    }
  },
  mounted() {
    // Trigger once to set the value in parent if component is rendered
    this.$root.$emit('toggleEmbedOption', this.prop, this.active)
  },
  methods: {
    toggleEmbedOption() {
      this.active = !this.active
      this.$root.$emit('toggleEmbedOption', this.prop, this.active)
    }
  }
}
</script>

<style></style>
