<template>
  <div>
    <SideBar
      v-if="this.$route.name < 'index-languages-lang'"
      active="Languages"
    >
      <div>
        <section class="pl-3 pr-3 mt-3">
          <Accordion :content="accordionContent"></Accordion>
        </section>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge :content="badgeContent" :number="communities.length"></Badge>
        </section>
        <hr />
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div
            v-for="community in communities.features"
            :key="community.properties.name"
          >
            <CommunityCard
              class="mt-3"
              :name="community.properties.name"
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
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import LangFamilyTitle from '@/components/languages/LangFamilyTitle.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LangFamilyTitle,
    DetailSideBar,
    CommunityCard
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
      badgeContent: 'Communities',
      communities: []
    }
  },
  computed: {
    feature() {
      return this.$store.state.features.feature
    }
  },
  async asyncData({ $axios }) {
    const api = process.server
      ? 'http://nginx/api/community/'
      : 'http://localhost/api/community/'
    const data = await $axios.$get(api)
    return {
      communities: data
    }
  },
  mounted() {
    console.log('Route', this.$route)
    console.log('Lang', this.languages)
  },
  methods: {
    handleNavigation(e, data) {
      console.log('Handling Navigation!', e, data)
      console.log('Router!', this.$router)
    }
  }
}
</script>

<style></style>
