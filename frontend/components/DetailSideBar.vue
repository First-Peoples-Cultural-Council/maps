<template>
  <div class="ds-container" :style="'width: ' + width + 'px;'">
    <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
    <slot></slot>
    <Contact></Contact>
  </div>
</template>

<script>
import Contact from '@/components/Contact.vue'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    Contact,
    Logo
  },
  props: {
    width: {
      default: 375,
      type: Number
    }
  },
  data() {
    return {
      style: 2
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
