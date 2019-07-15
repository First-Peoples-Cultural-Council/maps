<template>
  <div class="d-inline-block">
    <b-badge class="badge" :style="'background-color: ' + bgcolor">
      <span class="badge-icon">
        <img src="@/assets/images/language_icon_white.svg" alt="Icon" />
      </span>
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
      default: 104
    },
    bgcolor: {
      type: String,
      default: '#707070'
    },
    image: {
      type: String,
      default: 'language_icon_white.svg'
    }
  }
}
</script>

<style>
.badge {
  border-radius: 1em;
}
.badge-content {
  display: inline-block;
  margin: 0 0.25em;
  font-size: 1em;
}
.badge-number {
  display: inline-block;
  color: var(--color-red);
  background-color: white;
  height: 19px;
  width: 19px;
  text-align: center;
  border-radius: 50%;
  font-size: 0.8em;
  line-height: 19px;
}
.badge-icon {
  display: inline-block;
}
.badge-icon img {
  display: inline-block;
  width: 19px;
}
</style>
