<template>
  <div>
    <DetailSideBar>
      <CommunityDetailCard :name="community.name"></CommunityDetailCard>
      <hr class="sidebar-divider" />
      <Filters class="mb-4"></Filters>
    </DetailSideBar>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import CommunityDetailCard from '@/components/communities/CommunityDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    DetailSideBar,
    CommunityDetailCard,
    Filters
  },
  computed: {
    communities() {
      return this.$store.state.communities.communitySet
    },
    community() {
      return this.communities.find(comm => comm.name === this.$route.params.fn)
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    }
  },
  watch: {
    community(newComm, oldComm) {
      if (newComm !== oldComm) {
        this.$eventHub.whenMap(map => {
          zoomToPoint({ map: this.mapinstance, geom: this.community.point })
        })
      }
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
