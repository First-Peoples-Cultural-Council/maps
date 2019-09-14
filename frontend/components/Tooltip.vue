<template>
  <div class="d-inline-block">
    <b-button
      v-b-tooltip
      :title="content"
      variant="dark"
      size="sm"
      class="tooltip-fplm"
      >i</b-button
    >
  </div>
</template>
<script>
export default {
  props: {
    content: {
      default: null,
      type: String
    }
  },
  data() {
    return {
      show: false
    }
  }
}
</script>
<style>
.tooltip-fplm {
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 18px;
  width: 18px;
  line-height: 0;
  font-size: 0.7rem;
  text-align: center;
  background-color: transparent;
  color: rgba(0, 0, 0, 0.7);
  border: 1px solid rgba(0, 0, 0, 0.3);
}
</style>
