<template>
  <div>
    <SideBar
      v-if="this.$route.name < 'index-languages-lang'"
      active="Languages"
    >
      <template v-slot:content>
        <section class="pl-3 pr-3 mt-3">
          <Accordion
            class="no-scroll-accordion"
            :content="accordionContent"
          ></Accordion>
        </section>
        <section class="badge-section pl-3 pr-3 mt-3"></section>
        <hr class="sidebar-divider" />
        <Filters class="mb-2"></Filters>
      </template>
      <template v-slot:badges>
        <section class="badge-section pl-3 pr-3 mt-3">
          <Badge
            :content="badgeContent"
            :number="languagesCount"
            class="cursor-pointer"
            type="language"
            :mode="getBadgeStatus(mode, 'lang')"
            @click.native.prevent="handleBadge($event, 'lang')"
          ></Badge>
          <Badge
            content="Communities"
            :number="communities.length"
            class="cursor-pointer"
            bgcolor="#6c4264"
            type="community"
            :mode="getBadgeStatus(mode, 'comm')"
            @click.native.prevent="handleBadge($event, 'comm')"
          ></Badge>
        </section>
      </template>
      <template v-slot:cards>
        <section class="language-section pl-3 pr-3">
          <div v-if="mode !== 'comm'">
            <div
              v-for="(familyLanguages, family) in languages"
              :key="'langfamily' + family"
              class="language-family-container"
            >
              <h5 class="language-family mt-0">
                <span class="language-family-header">Language Family:</span>
                <span class="language-family-title">{{
                  family === 'undefined' ? 'No Family' : family
                }}</span>
              </h5>
              <b-row>
                <b-col
                  v-for="language in familyLanguages"
                  :key="'language' + language.id"
                  lg="12"
                  xl="12"
                  md="6"
                  sm="6"
                >
                  <LanguageCard
                    class="mt-2 hover-left-move"
                    :name="language.name"
                    :color="
                      (language.family && language.family.color) ||
                        language.color
                    "
                    @click.native.prevent="
                      handleCardClick($event, language.name, 'lang')
                    "
                  ></LanguageCard>
                </b-col>
              </b-row>
            </div>
          </div>
          <div v-if="mode !== 'lang'">
            <h5 class="language-family mt-2 ">Communities</h5>
            <b-row>
              <b-col
                v-for="community in paginatedCommunities"
                :key="'community ' + community.name"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <CommunityCard
                  class="mb-2 hover-left-move"
                  :name="community.name"
                  :community="community"
                  @click.native.prevent="
                    handleCardClick($event, community.name, 'comm')
                  "
                ></CommunityCard>
              </b-col>
            </b-row>
          </div>
        </section>
      </template>
    </SideBar>
    <div v-else>
      <nuxt-child />
    </div>
  </div>
</template>

<script>
import groupBy from 'lodash/groupBy'
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC, getApiUrl } from '@/plugins/utils.js'

export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LanguageCard,
    CommunityCard,
    Filters
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in B.C. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
      badgeContent: 'Languages',
      detailOneWidth: 375,
      detailTwoWidth: 500,
      mode: 'All',
      maximumLength: 0
    }
  },
  computed: {
    languages() {
      return this.$store.state.languages.languages
    },

    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    communities() {
      return this.$store.state.communities.communities
    },
    paginatedCommunities() {
      return this.communities.slice(0, this.maximumLength)
    },
    languagesCount() {
      return this.$store.state.languages.languagesCount
    },
    isMobile() {
      return this.$store.state.responsive.isMobileSideBarOpen
    }
  },
  async fetch({ $axios, store }) {
    const currentLanguages = store.state.languages.languageSet

    if (currentLanguages.length === 0) {
      // Fetch languages and communites data
      const languages = await $axios.$get(getApiUrl('language'))
      const communities = await $axios.$get(getApiUrl('community'))

      // Set language stores
      store.commit('languages/set', groupBy(languages, 'family.name')) // All data
      store.commit('languages/setStore', languages) // Updating data based on map

      // Set community stores
      store.commit('communities/set', communities) // All data
      store.commit('communities/setStore', communities) // Updating data based on map
    }
  },
  mounted() {
    this.$eventHub.whenMap(map => {
      this.$root.$emit('updateData')
    })

    // Trigger addeventlistener only if there's Sidebar, used for Pagination
    if (this.$route.name === 'index-languages') {
      const listElm = this.isMobile
        ? document.querySelector('#side-inner-collapse')
        : document.querySelector('#sidebar-container')
      listElm.addEventListener('scroll', e => {
        if (listElm.scrollTop + listElm.clientHeight >= listElm.scrollHeight) {
          if (this.communities.length > this.maximumLength) {
            this.loadMoreData()
          }
        }
      })
      this.loadMoreData()
    }
  },
  destroyed() {
    window.removeEventListener('scroll', () => {})
  },
  methods: {
    handleCardClick($event, name, type) {
      switch (type) {
        case 'lang':
          this.$router.push({
            path: `/languages/${encodeFPCC(name)}`
          })
          break
        case 'comm':
          this.$router.push({
            path: `/content/${encodeFPCC(name)}`
          })
          break
      }
    },
    loadMoreData() {
      this.$store.commit('sidebar/toggleLoading', true)
      setTimeout(() => {
        this.maximumLength += 10
        this.$store.commit('sidebar/toggleLoading', false)
      }, 250)
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
