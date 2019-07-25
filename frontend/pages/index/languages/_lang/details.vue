<template>
  <div>
    <div class="color-row" :style="'background-color: ' + languageColor"></div>

    <LanguageDetailCard
      :color="languageColor"
      :name="this.$route.params.lang"
      :detail="true"
    ></LanguageDetailCard>
    <section class="pl-3 pr-3">
      <h5 class="other-lang-names-title text-uppercase mt-4">
        Other Language Names
      </h5>
      <LanguageDetailBadge
        v-for="(name, index) in otherNames"
        :key="index"
        :content="name"
        class="mr-2"
      ></LanguageDetailBadge>
      <table v-if="language.sub_family" class="lang-detail-table mt-3">
        <thead>
          <tr>
            <th>Language Family</th>
            <th>Language Sub Family</th>
            <th>Region</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <LanguageDetailBadge
                :content="language.sub_family.name"
              ></LanguageDetailBadge>
            </td>
            <td>
              <LanguageDetailBadge
                :content="language.sub_family.family.name"
              ></LanguageDetailBadge>
            </td>
            <td>
              <LanguageDetailBadge
                content="Northeastern BC"
              ></LanguageDetailBadge>
            </td>
          </tr>
        </tbody>
      </table>
      <div class="lang-notes mt-3 color-gray font-08">
        {{ language.notes || '' }}
      </div>
      <div class="lang-statement"></div>
      <div v-if="language.languagelink_set.length > 0" class="lang-links mt-4">
        <h5 class="text-uppercase color-gray font-08">Links</h5>
        <ul class="list-style-none p-0 m-0 font-08">
          <li v-for="(link, index) in language.languagelink_set" :key="index">
            <a class="color-gold word-break-all" :href="link.url">{{
              link.title
            }}</a>
          </li>
        </ul>
      </div>
      <div v-if="language.fv_archive_link" class="mt-4">
        <h5 class="text-uppercase color-gray font-08">
          First Voices Archive Link
        </h5>
        <a
          class="color-gold font-08 word-break-all"
          :href="language.fv_archive_link"
          >{{ language.fv_archive_link }}</a
        >
      </div>
    </section>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import { zoomToLanguage } from '@/mixins/map.js'

export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge
  },
  data() {},
  computed: {
    ...mapState({
      mapinstance: state => state.mapinstance.mapInstance,
      otherNames() {
        return this.language.other_names.split(',')
      },
      languageColor() {
        return this.language.color
      }
    })
  },
  async asyncData({ $axios, store, params }) {
    const languageName = params.lang

    function getApiUrl(path) {
      return process.server ? `https://nginx/api/${path}` : `/api/${path}`
    }

    const languages = await $axios.$get(getApiUrl(`language/`))
    const language = languages.find(lang => lang.name === languageName)
    const languageId = language.id

    const result = await Promise.all([
      $axios.$get(getApiUrl(`language/${languageId}`))
    ])

    return {
      language: result[0]
    }
  },
  mounted() {
    this.$store.commit('sidebar/set', true)
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.$eventHub.whenMap(map => {
      zoomToLanguage({ map: map, lang: this.language })
    })
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
.lang-detail-table {
  width: 100%;
}
</style>
