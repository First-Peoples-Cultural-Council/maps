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
          <Badge :content="badgeContent" :number="languages.length"></Badge>
        </section>
        <hr />
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div v-for="(language, index) in languages" :key="index">
            <LanguageCard
              class="mt-3 hover-left-move"
              :name="language.name"
              :color="language.color"
              @click.native.prevent="
                handleCardClick($event, language.name, 'languages')
              "
            ></LanguageCard>
          </div>
        </section>
      </div>
    </SideBar>
    <DetailSideBar
      v-else-if="this.$route.name === 'index-languages-lang'"
      :width="detailOneWidth"
    >
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
    <DetailSideBar v-else :width="detailTwoWidth">
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
import LanguageCard from '@/components/languages/LanguageCard.vue'
export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LangFamilyTitle,
    LanguageCard,
    DetailSideBar
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
      badgeContent: 'Languages',
      detailOneWidth: 375,
      detailTwoWidth: 500
    }
  },
  computed: {
    languages() {
      return this.$store.state.languages.languages
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    }
  },
  methods: {
    handleCardClick(e, data) {
      // const lang = this.languages.find(l => l.name === data)
      // zoomToLanguage({ map: this.mapinstance, lang: lang })
      this.$router.push({
        path: `/languages/${encodeURIComponent(data)}`
      })
    }
  },
  head() {
    return {
      title: `Indigenous Languages List in British Columbia`,
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `A Full List of Indigenous Languages Spoken By First Nations in British Columbia, Canada.`
        }
      ]
    }
  }
}
</script>

<style></style>
