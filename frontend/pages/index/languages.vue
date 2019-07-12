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
          <Badge :content="badgeContent" :number="features.length"></Badge>
        </section>
        <hr />
        <section class="language-section pl-3 pr-3">
          <LangFamilyTitle language="ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)"></LangFamilyTitle>
          <div v-for="(language, index) in features" :key="index">
            <LanguageCard
              class="mt-3 hover-left-move"
              :name="language.properties.title"
              :color="language.properties.color"
              @click.native.prevent="
                handleCardClick($event, language.properties.title)
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
import { zoomToLanguage } from '@/mixins/map.js'
export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LangFamilyTitle,
    LanguageCard,
    DetailSideBar
  },
  props: {
    features: {
      type: Array,
      default: function() {
        return []
      }
    }
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
      badgeContent: 'Languages',
      languages: [],
      detailOneWidth: 375,
      detailTwoWidth: 500
    }
  },
  computed: {
    feature() {
      return this.$store.state.features.feature
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    }
  },
  async asyncData({ $axios }) {
    const api = process.server ? 'http://nginx/api/language/' : '/api/language/'
    console.log('Process', process)
    const data = await $axios.$get(api)
    return {
      languages: data
    }
  },
  mounted() {
    console.log('Route', this.$route)
  },
  methods: {
    handleCardClick(e, data) {
      zoomToLanguage({ map: this.mapinstance, lang: data })
      this.$router.push({
        path: `/languages/${encodeURIComponent(data)}`
      })
    }
  }
}
</script>

<style></style>
