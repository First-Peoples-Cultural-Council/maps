<template>
  <div>
    <DetailSideBar>
      <CommunityDetailCard
        :name="community.name"
        :population="commDetails.population"
      ></CommunityDetailCard>
      <hr class="sidebar-divider" />
      <Filters class="mb-4"></Filters>
      <ul class="list-style-none m-0 pl-3 pr-3">
        <li v-for="(value, key) in commDetails" :key="key">
          <div v-if="value">
            <div v-if="key === 'lna_by_language'" class="mt-3">
              <h5 class="font-09 font-weight-bold ">Language Analysis</h5>
              <div v-for="(lna, lnaKey) in value" :key="'lna' + lnaKey">
                {{ lna }}
              </div>
            </div>
            <div v-else>
              <h5 class="font-09 font-weight-bold">{{ key }}</h5>
              <span class="font-09 d-inline-block">{{ value || 'N/A' }}</span>
            </div>
          </div>
        </li>
      </ul>
    </DetailSideBar>
  </div>
</template>

<script>
import { omit } from 'lodash'
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
    },
    commDetails() {
      const filteredCommDetails = omit(this.communityDetail, ['name'])
      const details = filteredCommDetails
      return details
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
  async asyncData({ params, $axios, store, $route }) {
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const communities = await $axios.$get(getApiUrl(`/community/`))
    const community = communities.find(comm => comm.name === params.fn)
    const communityDetail = await $axios.$get(
      getApiUrl(`community/${community.id}/`)
    )

    return {
      communityDetail
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
