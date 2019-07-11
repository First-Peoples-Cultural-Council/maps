<template>
  <div>
    <SideBar
      v-if="this.$route.name < 'index-languages-lang'"
      active="Languages"
    >
      <div>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge :content="badgeContent" :number="communities.length"></Badge>
        </section>
        <hr />
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div
            v-for="community in communities"
            :key="community.properties.title"
          >
            <CommunityCard
              class="mt-3"
              :name="community.properties.title"
              @click.native.prevent="
                handleCardClick($event, community.properties.title)
              "
            ></CommunityCard>
          </div>
        </section>
      </div>
    </SideBar>
    <DetailSideBar v-else>
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import Badge from '@/components/Badge.vue'
import LangFamilyTitle from '@/components/languages/LangFamilyTitle.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
export default {
  components: {
    SideBar,
    Badge,
    LangFamilyTitle,
    DetailSideBar,
    CommunityCard
  },
  props: {
    communities: {
      default() {
        return []
      },
      type: Array
    }
  },
  data() {
    return {
      badgeContent: 'Communities'
    }
  },
  methods: {
    handleCardClick(e, title) {
      this.$router.push({
        path: `/content/${encodeURIComponent(title)}`
      })
    }
  }
}
</script>

<style></style>
