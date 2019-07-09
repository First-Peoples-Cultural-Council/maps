<template>
  <div>
    <SideBar active="Arts">
      Hello
      <nuxt-child />
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'

export default {
  components: {
    SideBar
  }
}
</script>

<style></style>
