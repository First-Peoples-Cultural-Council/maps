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
        v-for="name in otherNames"
        :key="name"
        :content="name"
        class="mr-2"
      ></LanguageDetailBadge>
      <LanguageSummary
        :population="language.pop_total_value.toString() || 'NA'"
        :speakers="language.fluent_speakers.toString() || 'NA'"
        :somewhat="language.some_speakers.toString() || 'NA'"
        :learners="language.learners.toString() || 'NA'"
        class="mt-4"
      ></LanguageSummary>
    </section>
    <section>
      <LanguageSeeAll
        :content="`Learn more about ${language.name}`"
        class="mt-3"
        @click.native="handleMoreDetails"
      ></LanguageSeeAll>
    </section>
    <section class="pl-3 pr-3 pt-2">
      <CommunityCard
        v-for="community in communities"
        :key="'community' + community.id"
        :name="community.name"
        class="mt-3 hover-left-move"
        @click.native="
          $router.push({
            path: `/content/${encodeURIComponent(community.name)}`
          })
        "
      ></CommunityCard>
      <PlacesCard
        v-for="place in places"
        :key="'place' + place.id"
        :name="place.properties.name"
        class="mt-3 hover-left-move"
        @click.native="
          $router.push({
            path: `/place-names/${encodeURIComponent(place.properties.name)}`
          })
        "
      ></PlacesCard>
      <ArtsCard
        v-for="(art, index) in arts"
        :key="'art' + index"
        class="mt-3 hover-left-move"
        :arttype="art.properties.type"
        :name="art.properties.title"
        @click.native="
          $router.push({
            path: `/art/${encodeURIComponent(art.properties.title)}`
          })
        "
      >
      </ArtsCard>
    </section>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageSummary from '@/components/languages/LanguageSummary.vue'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import { zoomToLanguage } from '@/mixins/map.js'
export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge,
    LanguageSummary,
    LanguageSeeAll,
    CommunityCard,
    PlacesCard,
    ArtsCard
  },
  computed: {
    ...mapState({
      mapinstance: state => state.mapinstance.mapInstance,

      arts() {
        return this.$store.state.arts.arts
      },
      languages() {
        return this.$store.state.languages.languageSet
      },
      otherNames() {
        return this.language.other_names.split(',')
      },
      languageColor() {
        return this.language.color
      }
    })
  },
  watch: {
    language(newlang, oldlang) {
      if (oldlang && newlang && oldlang.name !== newlang.name) {
        zoomToLanguage({ map: this.mapinstance, lang: newlang })
      }
    }
  },
  async asyncData({ $axios, store, params }) {
    const languageName = params.lang

    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const languages = await $axios.$get(getApiUrl(`language/`))
    const language = languages.find(lang => lang.name === languageName)
    const languageId = language.id

    const result = await Promise.all([
      $axios.$get(getApiUrl(`language/${languageId}`)),
      $axios.$get(getApiUrl(`community/?lang=${languageId}`)),
      $axios.$get(getApiUrl(`placename-geo/?lang=${languageId}`))
    ])

    return {
      language: result[0],
      communities: result[1],
      places: result[2].features
    }
  },

  created() {
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
  },
  head() {
    return {
      title: this.language.name + ' Language Resources and Stats',
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: `${this.language.name}, also known as ${
            this.language.other_names
          } is an indigenous language of British Columbia.`
        }
      ]
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
