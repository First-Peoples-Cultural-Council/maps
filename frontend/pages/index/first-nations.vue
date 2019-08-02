<template>
  <div>
    <SideBar active="Languages">
      <template v-slot:content>
        <hr class="sidebar-divider" />
        <Filters class="mb-2"></Filters>
      </template>
      <template v-slot:badges>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge
            :content="badgeContent"
            :number="communities.length"
            bgcolor="rgb(108, 66, 100)"
            type="community"
          ></Badge>
        </section>
      </template>
      <template v-slot:cards>
        <section class="community-section pl-3 pr-3">
          <div v-for="community in communities" :key="community.name">
            <CommunityCard
              class="mt-3 hover-left-move"
              :name="community.name"
              @click.native.prevent="handleCardClick($event, community.name)"
            ></CommunityCard>
          </div>
        </section>
      </template>
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Badge from '@/components/Badge.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    SideBar,
    Badge,
    CommunityCard,
    Filters
  },
  data() {
    return {
      badgeContent: 'Communities'
    }
  },
  computed: {
    communities() {
      return this.$store.state.communities.communities
    }
  },
  methods: {
    handleCardClick(e, title) {
      this.$router.push({
        path: `/content/${encodeURIComponent(title)}`
      })
    }
  },
  head() {
    return {
      title: `Indigenous Communities List in British Columbia`,
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `A List of Indigenous Communities. First Nations Communities in British Columbia, Canada.`
        }
      ]
    }
  }
}
</script>

<style></style>
