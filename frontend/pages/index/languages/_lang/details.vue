<template>
  <div>
    <div class="color-row" :style="'background-color: ' + languageColor"></div>

    <LanguageDetailCard
      :color="languageColor"
      :name="this.$route.params.lang"
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
      <table class="lang-detail-table mt-3">
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
                content="Athabaskan-Eyak-Tingit"
              ></LanguageDetailBadge>
            </td>
            <td>
              <LanguageDetailBadge
                content="Dene (Athabaskan)"
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
        {{ language.notes || placeholder }}
      </div>
      <div class="lang-statement">
        <h5 class="font-08 color-gray mt-3">Statement about language health</h5>
        <p class="font-08 color-gray">
          “English is now the first language of most Dane-zaa children, and of
          many adults in our communities. Dane-zaa Záágéʔ was our primary
          language until our grandparents and parents started to send our
          children to school in the 1950s. English only became dominant in the
          1980s. Because our language is orally based, Dane-zaa Záágéʔ becomes
          increasingly endangered as our fluent speakers pass away.”
        </p>
      </div>
      <div class="lang-links">
        <h5 class="text-uppercase color-gray font-08">Links</h5>
        <ul class="list-style-none p-0 m-0 font-08">
          <li>
            <a href="#" class="color-gold"
              >Dane Wajich Dane-ẕaa Stories & Songs - Language page</a
            >
          </li>
          <li>
            <a href="#" class="color-gold"
              >Images From a Stories Land: the Dane-zaa living landscape of
              northeastern BC</a
            >
          </li>
          <li>
            <a href="#" class="color-gold"
              >BC Archives: Living In A Storied Land</a
            >
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'

export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge
  },
  data() {
    return {
      placeholder: `We call our language Dane-zaa Záágéʔ, which translates as “people-regular language” in English. It is also known as the Beaver Language, because of the name the Europeans gave our people during the fur trade.
        Dane-zaa Záágéʔ is a member of the Athabaskan language family, which is one of the largest in North America. It includes the Navajo language of the American Southwest, Hupa, spoken along the Pacific Coast of California and Oregon, and many languages of Alaska and Canada. Dane-zaa Záágéʔ is closely related to the languages spoken by our neighboring Athabaskan groups, such as Dene Dháh (Alberta Slavey), Sekani, Tsuut’ina (Sarcee), Dene Sųłiné (Chipewyan), and Dene Zā́gé’ (Kaska). Dane-zaa Záágéʔ is spoken at Hanás̱ Saahgéʔ (Doig River), Blueberry, Halfway River, and Prophet River in British Columbia as well as at the Boyer River (Rocky Lane) and Child Lake (Eleske) Reserves in Alberta.`
    }
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
    const api = process.server ? 'http://nginx/api/language/' : '/api/language/'
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
.lang-detail-table {
  width: 100%;
}
</style>
