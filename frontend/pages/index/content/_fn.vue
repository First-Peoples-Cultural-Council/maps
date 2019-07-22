<template>
  <div>
    <DetailSideBar>
      <CommunityDetailCard :name="community.name"></CommunityDetailCard>
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
  computed: {
    communities() {
      return this.$store.state.communities.communitySet
    },
    community() {
      return this.communities.find(comm => comm.name === this.$route.params.fn)
    }
  }
}
</script>

<style></style>
