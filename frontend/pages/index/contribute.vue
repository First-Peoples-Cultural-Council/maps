<template>
  <div>
    <DetailSideBar :width="500">
      <h5>Hello World</h5>
    </DetailSideBar>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'

export default {
  components: {
    DetailSideBar
  },
  mounted() {
    this.$store.commit('sidebar/set', true)
  }
}
</script>

<style></style>
