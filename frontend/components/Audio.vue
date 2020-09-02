<template>
  <audio class="audio-player" controls :src="audioUrl">
    Your browser does not support the
    <code>audio</code> element.
  </audio>
</template>

<script>
export default {
  props: {
    audioObject: {
      default: null,
      type: Element
    },
    audioUrl: {
      default: null,
      type: String
    }
  }
}
</script>

<style>
.audio-player {
  width: 100%;
  height: 35px;
  outline: none;
  filter: sepia(20%) saturate(50%) grayscale(0) contrast(99%) invert(70%);
}
</style>
