<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-heritages'" active="Heritages">
      <section class="ml-2 mr-2 mt-2 pt-2"></section>
    </SideBar>
    <DetailSideBar
      v-else-if="this.$route.name === 'index-heritages-heritage'"
      :width="detailOneWidth"
    >
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'

export default {
  components: {
    SideBar,
    DetailSideBar
  }
}
</script>
<style></style>
