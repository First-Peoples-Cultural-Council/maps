<template>
  <div>
    <b-badge class="badge">
      <span class="badge-content">{{ content }}</span>
      <span class="badge-number">{{ number }}</span>
    </b-badge>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: String,
      default: ''
    },
    number: {
      type: Number,
      default: 0
    }
  }
}
</script>

<style>
.badge {
}
</style>
