<template>
  <div>
    <SideBar active="Languages">
      <div>
        Hello!
        <Accordion></Accordion>
        <nuxt-child />
      </div>
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
export default {
  components: {
    SideBar,
    Accordion
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
