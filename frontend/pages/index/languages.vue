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
            <b-row>
              <b-col
                v-for="community in communities"
                :key="'community ' + community.name"
                lg="12"
                xl="12"
                md="6"
                sm="6"
              >
                <CommunityCard
                  class="mt-3 hover-left-move"
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
import SideBar from '@/components/SideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import Filters from '@/components/Filters.vue'
import { encodeFPCC } from '@/plugins/utils.js'

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
      mode: 'All'
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
    languagesCount() {
      return this.$store.state.languages.languagesCount
    }
  },
  mounted() {
    this.$eventHub.whenMap(map => {
      this.$root.$emit('updateData')
    })
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

<style>
.language-family-header {
  font: Regular 15px/18px;
  letter-spacing: 0;
  color: #707070;
  opacity: 0.5;
}
.language-family-title {
  font: Bold 15px/18px;
  letter-spacing: 0;
  color: #707070;
  opacity: 0.7;
}
</style>
