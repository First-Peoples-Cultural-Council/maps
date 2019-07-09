<template>
  <div>
    <SideBar active="Heritages">
      Heritages
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
