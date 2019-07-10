<template>
  <div>
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
      <table class="lang-detail-table">
        <thead>
          <tr>
            <th>Language Family</th>
            <th>Language Sub Family</th>
            <th>Region</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Athabaskan-Eyak-Tingit</td>
            <td>Dene (Athabaskan)</td>
            <td>Northeastern BC</td>
          </tr>
        </tbody>
      </table>
    </section>
  </div>
</template>

<script>
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'

import { mapState } from 'vuex'
export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge
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
  async asyncData({ $axios, store }) {
    const api = process.server
      ? 'http://nginx/api/language/'
      : 'http://localhost/api/language/'
    const languages = await $axios.$get(api)

    return {
      languages
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

.lang-detail-table th {
  font-size: 0.6em;
  text-transform: uppercase;
  color: var(--color-gray);
}
</style>
