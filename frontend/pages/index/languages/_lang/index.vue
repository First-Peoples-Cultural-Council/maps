<template>
  <div class="language">
    <div class="color-row" :style="'background-color: ' + languageColor"></div>
    <LanguageDetailCard
      :color="languageColor"
      :name="this.$route.params.lang"
    ></LanguageDetailCard>
    <section class="ml-2 mr-2">
      <h5 class="other-lang-names-title text-uppercase mt-4">
        Other Language Names
      </h5>
      <LanguageDetailBadge
        v-for="(name, index) in otherNames"
        :key="index"
        :content="name"
        class="mr-2"
      ></LanguageDetailBadge>
      <LanguageSummary
        population="121"
        speakers="121"
        somewhat="121"
        learners="87"
        class="mt-4"
      ></LanguageSummary>
      <LanguageSeeAll
        content="See all details"
        class="mt-3"
        @click.native="handleMoreDetails"
      ></LanguageSeeAll>
    </section>
  </div>
</template>

<script>
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import { mapState } from 'vuex'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageSummary from '@/components/languages/LanguageSummary.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { zoomToLanguage } from '@/mixins/map.js'
export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge,
    LanguageSummary,
    LanguageSeeAll
  },
  computed: {
    ...mapState({
      mapinstance: state => state.mapinstance.mapInstance,
      language() {
        return this.languages.find(
          lang => lang.name === this.$route.params.lang
        )
      },
      otherNames() {
        return this.language.other_names.split('/')
      },
      languageColor() {
        return this.language.color
      }
    })
  },
  watch: {
    mapinstance(mapinstance) {
      const self = this
      mapinstance.once('idle', function(e) {
        zoomToLanguage({ map: mapinstance, lang: self.$route.params.lang })
      })
    }
  },
  async asyncData({ $axios, store }) {
    const api = process.server
      ? 'http://nginx/api/language/'
      : 'http://localhost/api/language/'
    const languages = await $axios.$get(api)

    return {
      languages
    }
  },
  methods: {
    handleMoreDetails() {
      this.$router.push({
        path: `${encodeURIComponent(this.$route.params.lang)}/details`
      })
    }
  }
}
</script>

<style>
.color-row {
  background-color: black;
  height: 7px;
}
.other-lang-names-title {
  color: var(--color-gray);
  font-size: 0.8em;
}
</style>
