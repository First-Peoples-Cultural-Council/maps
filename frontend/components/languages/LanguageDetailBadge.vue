<template>
  <div class="d-inline-block">
    <b-badge class="detail-badge">
      <span class="detail-badge-content">{{ content }}</span>
    </b-badge>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: String,
      default: ''
    }
  }
}
</script>

<style>
.detail-badge {
  background-color: var(--color-beige, #efeae2);
  color: var(--color-gray);
  border-radius: 0 !important;
  border: 0;
  padding: 0.3em;
}
</style>
