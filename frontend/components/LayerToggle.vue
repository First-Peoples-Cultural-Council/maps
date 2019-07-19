<template>
  <div>
    <div class="cursor-pointer" @click="on = !on">
      <span class="font-08 d-inline-block"> {{ layerName }}</span>
      <span class="float-right">
        <img v-if="on" src="@/assets/images/on.svg" alt="On" />
        <img v-else src="@/assets/images/off.svg" alt="Off" />
      </span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    layerName: {
      default: '',
      type: String
    },
    layer: {
      default: '',
      type: String
    }
  },
  data() {
    return {
      on: false
    }
  }
}
</script>

<style></style>
