<template>
  <div class="fpcc-card" :class="{ 'fpcc-card-white': variant == 'white' }">
    <div class="fpcc-card-header">
      <slot name="header"></slot>
    </div>
    <div class="fpcc-card-body"><slot name="body"></slot></div>
    <div class="fpcc-card-footer">
      <slot name="footer"></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    variant: {
      default: 'normal',
      type: String
    }
  }
}
</script>

<style>
.fpcc-card {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 0.5em 0em 0.5em 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
  display: table;
}
.fpcc-card-header {
  display: table-cell;
  vertical-align: middle;
  width: 10%;
}
.fpcc-card-body {
  display: table-cell;
  padding: 0 0.5em;
  vertical-align: middle;
  width: 75%;
}
.fpcc-card-footer {
  display: table-cell;
  vertical-align: middle;
  width: 55px;
}

.fpcc-card-white {
  background-color: White;
}

.fpcc-card:hover {
  border: 1px solid #b57936;
}
</style>
