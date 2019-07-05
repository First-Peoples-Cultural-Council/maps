<template>
  <div class="card-badge">
    <span class="font-07">{{ content }}</span>
    <img src="@/assets/images/pronounce_icon.svg" alt="Pronounce" />
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
.card-badge {
  line-height: 0;
  background-color: var(--color-gray);
  display: inline-block;
  color: white;
  border-radius: 1em;
  padding: 0.2em 0.45em;
}
.card-badge span {
  text-transform: uppercase;
  font-weight: Bold;
}
.card-badge span,
.card-badge img {
  display: inline-block;
  vertical-align: middle;
}
</style>
