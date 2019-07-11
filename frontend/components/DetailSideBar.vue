<template>
  <div class="ds-container" :style="'width: ' + width + 'px;'">
    <slot></slot>
  </div>
</template>

<script>
export default {
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
}
</style>
