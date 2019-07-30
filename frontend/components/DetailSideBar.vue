<template>
  <div class="ds-container" :style="'width: ' + width + 'px;'">
    <slot></slot>
    <Contact></Contact>
  </div>
</template>

<script>
import Contact from '@/components/Contact.vue'
export default {
  components: {
    Contact
  },
  props: {
    width: {
      default: 375,
      type: Number
    }
  }
}
</script>

<style>
.ds-container {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: var(--sidebar-width, 350px);
  display: flex;
  flex-direction: column;
  background-color: white;
  overflow-y: auto;
  padding-bottom: 1em;
}
</style>
