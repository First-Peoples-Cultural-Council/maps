<template>
  <div class="fpcc-card">
    <div class="fpcc-card-header"><slot name="header"></slot></div>
    <div class="fpcc-card-body"><slot name="body"></slot></div>
    <div class="fpcc-card-footer"><slot name="footer"></slot></div>
  </div>
</template>

<script>
export default {}
</script>

<style>
.fpcc-card {
  display: flex;
  align-items: center;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
}
.fpcc-card-header {
  flex: 1 1 0;
}
.fpcc-card-body {
  flex: 10 1 0;
  padding: 0 0.5em;
}
.fpcc-card-footer {
  flex: 2 1 0;
}
</style>
