<template>
  <div
    class="fpcc-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <div class="fpcc-card-header"><slot name="header"></slot></div>
    <div class="fpcc-card-body"><slot name="body"></slot></div>
    <div class="fpcc-card-footer">
      <div class="fpcc-card-more">
        <img v-if="!hover" src="@/assets/images/go_icon.svg" alt="Go" />
        <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      hover: false
    }
  },
  methods: {
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    }
  }
}
</script>

<style>
.fpcc-card {
  display: flex;
  align-items: center;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 0.5em 0em 0.5em 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
}

.fpcc-card:hover {
  position: relative;
  left: 10px;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: var(--color-darkgray);
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

.fpcc-card-more {
  background-color: var(--color-beige);
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}
</style>
