<template>
  <div class="mobile-bar-container">
    <div class="m-0 p-0 font-1">
      <b-badge>{{ title }}</b-badge>
    </div>
    <div class="d-flex align-items-center cursor-pointer pr-1">
      <img src="@/assets/images/arrow_up_icon.svg" alt="Open" />
    </div>
  </div>
</template>
<script>
export default {
  props: {
    type: {
      default: null,
      type: String
    },
    title: {
      default: null,
      type: String
    }
  }
}
</script>
<style>
.mobile-bar-container {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: white;
  overflow: hidden;
  z-index: 1000;
  display: flex;
  align-items: center;
  font-size: 1em;
  line-height: 1em;
  padding: 0.25em;
  justify-content: space-between;
}
</style>
