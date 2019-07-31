<template>
  <div class="lang-see-all">
    <span class="lang-see-all-content">{{ content }}</span>
    <span class="lang-see-all-redirect"
      ><img src="@/assets/images/go_icon_hover.svg" alt="Go"
    /></span>
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
  background-color: #c46156;
  font-size: 0.9em;
  padding: 0.5em 0.5em;
  font-weight: bold;
  border-radius: 0.25em;
  cursor: pointer;
  color: white;
  display: table;
  width: 100%;
}

.lang-see-all span {
  display: table-cell;
  vertical-align: middle;
  line-height: 1.1em;
}

.lang-see-all-content {
  width: 90%;
}

.lang-see-all-redirect {
  width: 10%;
  text-align: center;
}
</style>
