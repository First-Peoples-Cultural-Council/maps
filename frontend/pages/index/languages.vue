<template>
  <div>
    <SideBar active="Languages">
      <div>
        <Accordion :content="accordionContent"></Accordion>
        <section class="badge-section">
          <Badge content="Languages" number="23"></Badge>
        </section>
        <nuxt-child />
      </div>
    </SideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
export default {
  components: {
    SideBar,
    Accordion,
    Badge
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.'
    }
  },
  methods: {
    handleNavigation(e, data) {
      console.log('Handling Navigation!', e, data)
      console.log('Router!', this.$router)
    }
  }
}
</script>

<style>
.badge-section {
  margin-top: 1em;
}
</style>
