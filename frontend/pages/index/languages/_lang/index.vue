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
        :population="language.pop_total_value.toString() || 'NA'"
        :speakers="language.fluent_speakers.toString() || 'NA'"
        :somewhat="language.some_speakers.toString() || 'NA'"
        :learners="language.learners.toString() || 'NA'"
        class="mt-4"
      ></LanguageSummary>
      <LanguageSeeAll
        content="See all details"
        class="mt-3"
        @click.native="handleMoreDetails"
      ></LanguageSeeAll>
    </section>
    <section class="pl-2 pr-2 pt-2">
      <CommunityCard
        v-for="(community, index) in communities"
        :key="index"
        :name="community.name"
        class="mb-2"
      ></CommunityCard>
      <PlacesCard
        v-for="place in places"
        :key="place.properties.name"
        :name="place.properties.name"
        class="mb-2"
      ></PlacesCard>
      <ArtsCard
        v-for="art in arts"
        :key="art.name"
        :arttype="art.properties.type"
        :name="art.properties.title"
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
      communities() {
        return this.$store.state.communities.communities
      },
      places() {
        return this.$store.state.places.places
      },
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
    let language = languages.find(lang => lang.name === languageName)
    const languageId = language.id
    language = await $axios.$get(getApiUrl(`language/${languageId}`))
    return {
      language: language
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
