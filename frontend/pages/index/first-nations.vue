<template>
  <div>
    <SideBar active="Languages">
      <div>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge :content="badgeContent" :number="communities.length"></Badge>
        </section>
        <hr />
        <section class="community-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div v-for="community in communities" :key="community.name">
            <CommunityCard
              class="mt-3"
              :name="community.name"
              @click.native.prevent="handleCardClick($event, community.name)"
            ></CommunityCard>
          </div>
        </section>
      </div>
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Badge from '@/components/Badge.vue'
import LangFamilyTitle from '@/components/languages/LangFamilyTitle.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'

export default {
  components: {
    SideBar,
    Badge,
    LangFamilyTitle,
    CommunityCard
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
