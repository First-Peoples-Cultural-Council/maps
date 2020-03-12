<template>
  <div class="arts-artist-banner">
    <div class="arts-artist-header">
      <slot name="header"></slot>
    </div>
    <div class="arts-artist-body"><slot name="body"></slot></div>
  </div>
</template>

<script>
export default {
  props: {
    variant: {
      default: 'normal',
      type: String
    }
  }
}
</script>

<style>
.arts-artist-header {
  position: relative;
  border-bottom: 0.8px solid rgb(0, 0, 0, 0.25);
}

.arts-artist-body {
  width: 100%;
  height: 100px;
  position: relative;
}

.arts-artist-content {
  width: 100%;
  position: absolute;
  top: -3rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-items: center;
}
</style>
