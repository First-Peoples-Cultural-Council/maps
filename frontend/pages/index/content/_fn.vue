<template>
  <div>
    <DetailSideBar>
      <CommunityDetailCard
        :name="community.properties.title"
      ></CommunityDetailCard>
    </DetailSideBar>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import CommunityDetailCard from '@/components/communities/CommunityDetailCard.vue'
export default {
  components: {
    DetailSideBar,
    CommunityDetailCard
  },
  props: {
    communities: {
      default() {
        return []
      },
      type: Array
    }
  },
  computed: {
    community() {
      return this.communities.find(
        comm => comm.properties.title === this.$route.params.fn
      )
    }
  }
}
</script>

<style></style>
