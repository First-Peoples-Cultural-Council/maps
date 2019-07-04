<template>
  <div>
    <SideBar active="Languages">
      <div>
        <section class="pl-3 pr-3 mt-3">
          <Accordion :content="accordionContent"></Accordion>
        </section>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge :content="badgeContent" :number="badgeNumber"></Badge>
        </section>
        <hr />
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <LanguageCard class="mt-2"></LanguageCard>
        </section>
      </div>
      <div>
        <nuxt-child />
      </div>
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import LangFamilyTitle from '@/components/languages/LangFamilyTitle.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LangFamilyTitle,
    LanguageCard
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
      badgeContent: 'Languages',
      badgeNumber: 23
    }
  },
  mounted() {
    console.log('Route', this.$route)
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
