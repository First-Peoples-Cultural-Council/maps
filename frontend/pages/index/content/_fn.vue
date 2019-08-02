<template>
  <div>
    <DetailSideBar>
      <template v-slot:badges>
        <h5
          class="color-gray font-08 p-0 m-0"
          style="margin-bottom: 0.2em !important;"
        >
          <span class="d-inline-block valign-middle">
            Community:
            <span class="font-weight-bold">{{ community.name }}</span>
          </span>
        </h5>
        <Badge
          content="Languages"
          :number="commDetails.languages.length"
          class="cursor-pointer"
          type="language"
        ></Badge>
      </template>
      <CommunityDetailCard
        :name="community.name"
        :population="commDetails.population"
        :server="isServer"
        :audio-file="commDetails.audio_file"
      ></CommunityDetailCard>
      <hr class="sidebar-divider mt-0" />
      <Filters class="mb-1"></Filters>

      <section class="pl-3 pr-3">
        <h5 class="other-lang-names-title text-uppercase mt-4">
          Other Community Names
        </h5>
        <LanguageDetailBadge
          v-for="(name, index) in otherNames"
          :key="index"
          :content="name"
          class="mr-2"
        ></LanguageDetailBadge>
        <ul class="list-style-none m-0 p-0 mt-2">
          <li>
            <span class="font-08 color-gray">Email:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.email || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Website:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.website || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Phone #:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.phone || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Alternate Phone #:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.alt_phone || 'N/A' }}
            </span>
          </li>
          <li>
            <span class="font-08 color-gray">Fax #:</span>
            <span class="font-08 font-weight-bold color-gray">
              {{ commDetails.fax || 'N/A' }}
            </span>
          </li>
        </ul>
        <div class="mt-3">
          <b-table
            hover
            :items="lna"
            responsive
            small
            table-class="lna-table"
            thead-class="lna-table-thead"
            tbody-class="lna-table-tbody"
          ></b-table>
        </div>
        <div
          v-for="language in commDetails.languages"
          :key="'language' + language.id"
        >
          <LanguageCard
            class="mt-3 hover-left-move"
            :name="language.name"
            :color="language.color"
            @click.native.prevent="
              $router.push({
                path: `/languages/${encodeURIComponent(language.name)}`
              })
            "
          ></LanguageCard>
        </div>
      </section>
    </DetailSideBar>
  </div>
</template>

<script>
import { values, omit } from 'lodash'
import DetailSideBar from '@/components/DetailSideBar.vue'
import CommunityDetailCard from '@/components/communities/CommunityDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import Badge from '@/components/Badge.vue'

export default {
  components: {
    DetailSideBar,
    CommunityDetailCard,
    LanguageDetailBadge,
    Filters,
    LanguageCard,
    Badge
  },
  computed: {
    communities() {
      return this.$store.state.communities.communitySet
    },
    community() {
      return this.communities.find(comm => comm.name === this.$route.params.fn)
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    commDetails() {
      const filteredCommDetails = omit(this.communityDetail, ['name'])
      const details = filteredCommDetails
      return details
    },
    lna() {
      const lnas = values(this.commDetails.lna_by_language)
      return lnas.map(lna => {
        console.log(lna)
        let fluent
        let someSpeakers
        let learners
        const pop = this.commDetails.popluation
        // get percentages.
        if (pop) {
          fluent = ((100 * lna.fluent_speakers) / pop).toFixed(1) + '%'
          someSpeakers = ((100 * lna.some_speakers) / pop).toFixed(1) + '%'
          learners = ((100 * lna.learners) / pop).toFixed(1) + '%'
        } else {
          learners = 0
          fluent = 0
          someSpeakers = 0
        }
        return {
          language: lna.lna.language,
          fluent_speakers: fluent,
          some_speakers: someSpeakers,
          learners
        }
      })
    },
    otherNames() {
      return this.commDetails.other_names.split(',')
    }
  },
  watch: {
    community(newComm, oldComm) {
      if (newComm !== oldComm) {
        this.setupMap()
      }
    }
  },
  async asyncData({ params, $axios, store, $route }) {
    function getApiUrl(path) {
      return process.server ? `http://nginx/api/${path}` : `/api/${path}`
    }

    const communities = await $axios.$get(getApiUrl(`/community/`))
    const community = communities.find(comm => comm.name === params.fn)
    const communityDetail = await $axios.$get(
      getApiUrl(`community/${community.id}/`)
    )

    const isServer = !!process.server
    return {
      communityDetail,
      isServer
    }
  },
  created() {
    // We don't always catch language routing updates, so also zoom to language on create.
    this.setupMap()
  },
  methods: {
    setupMap() {
      this.$eventHub.whenMap(map => {
        zoomToPoint({ map, geom: this.community.point, zoom: 11 })
        map.setFilter('fn-nations-highlighted', [
          '==',
          'name',
          this.community.name
        ])
      })
    }
  }
}
</script>

<style>
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

.lna-table {
  border: 1px solid #ebe6dc;
  margin-bottom: 0;
}
.lna-table-thead {
  font-size: 0.8em;
  color: var(--color-gray);
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
  color: var(--color-gray);
  vertical-align: middle;
}
</style>
