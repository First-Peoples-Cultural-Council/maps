<template>
  <div class="W-100">
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-3 pr-3 d-none content-mobile-title"
    >
      <div>
        Language:
        <span class="font-weight-bold">{{ language.name }}</span>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>

    <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
      <div
        class="text-center d-none mobile-close"
        :class="{ 'content-mobile': mobileContent }"
        @click="$store.commit('sidebar/setMobileContent', false)"
      >
        <img class="d-inline-block" src="@/assets/images/arrow_down_icon.svg" />
      </div>

      <div
        class="color-row"
        :style="'background-color: ' + languageColor"
      ></div>

      <LanguageDetailCard
        :color="languageColor"
        :name="this.$route.params.lang"
        :detail="true"
        audio-file=""
        :link="language.fv_archive_link"
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
            </tr>
          </tbody>
        </table>
        <div v-if="language.dialect_set.length > 0">
          <h5 class="other-lang-names-title text-uppercase mt-4">
            Dialect
          </h5>
          <LanguageDetailBadge
            v-for="(dialect, index) in language.dialect_set"
            :key="index"
            :content="dialect.name"
            class="mr-2"
          ></LanguageDetailBadge>
        </div>
        <div class="lang-notes mt-3 color-gray font-08">
          {{ language.notes || '' }}
        </div>
        <div class="lang-statement"></div>
        <div
          v-if="language.languagelink_set.length > 0"
          class="lang-links mt-4"
        >
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
          <LanguageSeeAll
            :content="`Learn ${language.name} on FirstVoices`"
            @click.native="handleClick($event, language.fv_archive_link)"
          ></LanguageSeeAll>
        </div>
        <!--  Commented out until data is fixed -->
        <!--        <div class="mt-3">-->
        <!--          <b-table-->
        <!--            hover-->
        <!--            :items="lna"-->
        <!--            responsive-->
        <!--            small-->
        <!--            table-class="lna-table"-->
        <!--            thead-class="lna-table-thead"-->
        <!--            tbody-class="lna-table-tbody"-->
        <!--          ></b-table>-->
        <!--        </div>-->
        <p>
          Source:
          <a
            :href="
              `http://www.fpcc.ca/files/PDF/FPCC-LanguageReport-180716-WEB.pdf`
            "
            target="_blank"
            >Report on the status of B.C. First Nations Languages 2018</a
          >
        </p>
      </section>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import values from 'lodash/values'
import omit from 'lodash/omit'
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import { zoomToLanguage, selectLanguage } from '@/mixins/map.js'
import LanguageSeeAll from '@/components/languages/LanguageSeeAll.vue'
import { getApiUrl, encodeFPCC } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    LanguageDetailCard,
    LanguageDetailBadge,
    LanguageSeeAll,
    Logo
  },
  head() {
    return {
      meta: [
        {
          name: 'google-site-verification',
          content: 'wWf4WAoDmF6R3jjEYapgr3-ymFwS6o-qfLob4WOErRA'
        }
      ]
    }
  },
  data() {},
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    ...mapState({
      mapinstance: state => state.mapinstance.mapInstance,
      otherNames() {
        return this.language.other_names.split(',')
      },
      languageColor() {
        return this.language.color
      },
      lna() {
        const lnas = values(this.language.lna_by_nation)
        return lnas.map(lna =>
          omit(lna, ['lna', 'id', 'name', 'pop_off_res', 'pop_on_res'])
        )
      }
    })
  },
  async asyncData({ $axios, store, params }) {
    const languageName = params.lang

    const languages = await $axios.$get(getApiUrl(`language/`))
    const language = languages.find(
      lang => encodeFPCC(lang.name) === languageName
    )
    const languageId = language.id

    const result = await Promise.all([
      $axios.$get(getApiUrl(`language/${languageId}`))
    ])

    return {
      language: result[0]
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/set', true)
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('sidebar/set', false)
    next()
  },
  mounted() {
    this.$store.commit('sidebar/set', true)
    this.$eventHub.whenMap(map => {
      if (this.$route.hash.length <= 1) {
        zoomToLanguage({ map, lang: this.language })
      } else {
        selectLanguage({ map, lang: this.language })
      }
    })
  },
  methods: {
    handleClick(e, data) {
      window.open(data)
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
  color: var(--color-gray, #6f6f70);
  font-size: 0.8em;
}

.lang-detail-table th {
  font-size: 0.6em;
  text-transform: uppercase;
  color: var(--color-gray, #6f6f70);
}
.lang-detail-table {
  width: 100%;
}

.lna-table {
  border: 1px solid #ebe6dc;
  margin-bottom: 0;
}
.lna-table-thead {
  font-size: 0.8em;
  color: var(--color-gray, #6f6f70);
}

.lna-table-thead th {
  font-weight: normal;
  vertical-align: middle !important;
  border: 0;
  border-bottom: 0 !important;
  padding-left: 0.5em;
  padding-right: 0.5em;
}

.lna-table-tbody {
  font-size: 0.8em;
}

.lna-table-tbody td {
  padding-left: 0.5em;
  padding-right: 0.5em;
  color: var(--color-gray, #6f6f70);
  vertical-align: middle;
}
</style>
