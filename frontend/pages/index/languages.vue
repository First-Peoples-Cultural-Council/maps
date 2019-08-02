<template>
  <div>
    <SideBar
      v-if="this.$route.name < 'index-languages-lang'"
      active="Languages"
    >
      <template v-slot:content>
        <section class="pl-3 pr-3 mt-3">
          <Accordion :content="accordionContent"></Accordion>
        </section>

        <hr class="sidebar-divider" />
        <Filters class="mb-4"></Filters>
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
            >
              <h5 class="language-family mt-3">
                Language Family:
                {{ family === 'undefined' ? 'No Family' : family }}
              </h5>
              <div
                v-for="language in familyLanguages"
                :key="'language' + language.id"
              >
                <LanguageCard
                  class="mt-3 hover-left-move"
                  :name="language.name"
                  :color="language.color"
                  @click.native.prevent="
                    $router.push({
                      path: `languages/${encodeURIComponent(language.name)}`
                    })
                  "
                ></LanguageCard>
              </div>
            </div>
          </div>
          <div v-if="mode !== 'lang'">
            <CommunityCard
              v-for="community in communities"
              :key="'community ' + community.name"
              class="mt-3 hover-left-move"
              :name="community.name"
              @click.native.prevent="
                handleCardClick(
                  $event,
                  community.name,
                  'content',
                  community.name
                )
              "
            ></CommunityCard>
          </div>
        </section>
      </template>
    </SideBar>
    <div
      v-else-if="this.$route.name === 'index-languages-lang'"
      :width="detailOneWidth"
    >
      <nuxt-child />
    </div>
    <DetailSideBar v-else :width="detailTwoWidth">
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import Accordion from '@/components/Accordion.vue'
import Badge from '@/components/Badge.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    SideBar,
    Accordion,
    Badge,
    LanguageCard,
    DetailSideBar,
    CommunityCard,
    Filters
  },
  data() {
    return {
      accordionContent:
        'British Columbia is home to 203 First Nations communities and an amazing diversity of Indigenous languages; approximately 60% of the First Peoples’ languages of Canada are spoken in BC. You can access indexes of all the languages, First Nations and Community Champions through the top navigation on all pages of this website.',
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
  methods: {
    handleCardClick(e, data) {
      // const lang = this.languages.find(l => l.name === data)
      // zoomToLanguage({ map: this.mapinstance, lang: lang })
      this.$router.push({
        path: `/languages/${encodeURIComponent(data)}`
      })
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
