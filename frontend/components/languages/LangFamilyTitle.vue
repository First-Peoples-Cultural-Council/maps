<template>
  <div>
    <p class="language-family-header">
      <span class="language-family-subtitle">Language Family</span>
      <span class="language-family-title">{{ language }}</span>
    </p>
  </div>
</template>

<script>
export default {
  props: {
    language: {
      type: String,
      default: ''
    }
  }
}
</script>

<style>
.language-family-header {
  font-size: 0.8em;
}
.language-family-subtitle {
  color: var(--color-gray, #707070);
}
.language-family-title {
  font-weight: 600;
  color: var(--color-gray, #707070);
}
</style>
