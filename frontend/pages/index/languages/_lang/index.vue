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
import { mapState } from 'vuex'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
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
    language(newlang, oldlang) {
      console.log('language changed from', oldlang.name, 'to', newlang.name)
      if (oldlang && newlang && oldlang.name !== newlang.name) {
        zoomToLanguage({ map: this.mapinstance, lang: newlang })
      }
    }
  },
  async asyncData({ $axios, store }) {
    const api = process.server ? 'http://nginx/api/language/' : '/api/language/'
    const languages = await $axios.$get(api)
    return {
      languages
    }
  },
  created() {
    console.log('created')
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      zoomToLanguage({ map: map, lang: this.language })
    })
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

<style scoped>
.color-row {
  background-color: black;
  height: 7px;
}
.other-lang-names-title {
  color: var(--color-gray);
  font-size: 0.8em;
}
</style>
