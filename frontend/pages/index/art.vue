<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-art'" active="Arts">
      <section class="ml-2 mr-2 mt-2 pt-2">
        <ArtsCard
          v-for="(art, index) in arts"
          :key="index"
          :arttype="art.properties.type"
          :name="art.properties.title"
          class="mb-2"
          @click.native="$router.push({ path: `/art/${art.properties.title}` })"
        ></ArtsCard>
      </section>
    </SideBar>
    <DetailSideBar
      v-else-if="this.$route.name === 'index-art-art'"
      :width="375"
    >
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'

export default {
  components: {
    SideBar,
    ArtsCard,
    DetailSideBar
  },
  computed: {
    arts() {
      return this.$store.state.arts.arts
    }
  }
}
</script>
<style></style>
