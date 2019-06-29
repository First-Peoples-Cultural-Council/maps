<template>
  <div>
    <SideBar active="Languages">
      <nuxt-child />
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'

export default {
  components: {
    SideBar
  },
  methods: {
    handleNavigation(e, data) {
      console.log('Handling Navigation!', e, data)
      console.log('Router!', this.$router)
    }
  }
}
</script>

<style></style>
