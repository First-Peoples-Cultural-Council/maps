<template>
  <div>
    <SideBar active="Languages">
      <div>
        <Accordion :content="accordionContent"></Accordion>
        <section class="badge-section mt-2">
          <Badge :content="badgeContent" :number="badgeNumber"></Badge>
        </section>
        <hr />
        <section class="language-section mt-2">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
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
import LangFamilyTitle from '@/components/LangFamilyTitle.vue'
export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LangFamilyTitle
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
