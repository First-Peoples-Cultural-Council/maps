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
import { zoomToPoint } from '@/mixins/map.js'

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
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      zoomToPoint({ map: map, geom: this.community.point })
    })
  }
}
</script>

<style></style>
