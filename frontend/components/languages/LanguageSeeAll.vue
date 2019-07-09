<template>
  <div class="lang-see-all">
    <span>{{ content }}</span>
    <span><img src="@/assets/images/go_icon.svg" alt="Go"/></span>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      default: '',
      type: String
    }
  }
}
</script>

<style>
.lang-see-all {
  line-height: 0;
  display: flex;
  justify-content: space-between;
  background-color: var(--color-beige);
  align-items: center;
  font-size: 0.9em;
  padding: 0.5em 0.5em;
  font-weight: bold;
  color: var(--color-gray);
  border-radius: 0.25em;
  cursor: pointer;
}
</style>
