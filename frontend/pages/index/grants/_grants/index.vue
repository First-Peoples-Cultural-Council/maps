<template>
  <div>
    <div class="w-100">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          GRANTS:
          <span class="font-weight-bold">{{ grant.name }}</span>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
        <Logo :logo-alt="1" class="cursor-pointer hide-mobile"></Logo>
        <div>
          <div
            class="text-center d-none mobile-close"
            :class="{ 'content-mobile': mobileContent }"
            @click="$store.commit('sidebar/setMobileContent', false)"
          >
            <img
              class="d-inline-block"
              src="@/assets/images/arrow_down_icon.svg"
            />
          </div>
          <div>
            <GrantsDetailCard
              :name="grant.name"
              :arttype="'Grants'"
              :tags="[]"
            ></GrantsDetailCard>
          </div>
          <div class="grants-detail-container">
            <section class="artist-content-field">
              <h5 class="field-title">
                Amount:
              </h5>
              <span class="field-content">
                <span> {{ grant.amount }}</span>
              </span>
            </section>

            <section v-if="grant.project_brief" class="artist-content-field">
              <h5 class="field-title">
                Grants Description:
              </h5>
              <span class="field-content">
                <span v-html="stringSplit(grant.project_brief)"></span>
                <a v-if="showExpandBtn()" href="#" @click="toggleDescription">{{
                  collapseDescription ? 'read less' : 'read more'
                }}</a>
              </span>
            </section>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import GrantsDetailCard from '@/components/grants/GrantsDetailCard.vue'
import Logo from '@/components/Logo.vue'

import { zoomToPoint } from '@/mixins/map.js'
import { getApiUrl, encodeFPCC, makeMarker } from '@/plugins/utils.js'

export default {
  components: {
    GrantsDetailCard,
    Logo
  },
  data() {
    return {
      collapseDescription: false
    }
  },
  watchQuery: true,
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },

    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    grants() {
      return this.$store.state.grants.grantsSet
    }
  },

  async asyncData({ params, $axios, store }) {
    const now = new Date()

    const grants = await $axios.$get(getApiUrl(`grants`))

    const grantFind = grants.features.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.grants
      }
    })

    const grant = await $axios.$get(
      getApiUrl(`grants/${grantFind.id}?timestamp=` + now.getTime())
    )

    return {
      grant
    }
  },
  mounted() {},
  created() {
    this.setupMap()
  },
  methods: {
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          if (this.grant.point)
            zoomToPoint({ map, geom: this.grant.point, zoom: 11 })
        }
        if (this.grant.point) {
          const icon = 'grant_icon.svg'
          makeMarker(this.grant.point, icon, 'grant-marker').addTo(map)
        }
      })
    },
    showExpandBtn() {
      return this.grant.project_brief.length >= 50
    },
    toggleDescription() {
      this.collapseDescription = !this.collapseDescription
    },
    stringSplit(string) {
      const stringValue = this.collapseDescription
        ? `${string} `
        : string.replace(/(.{200})..+/, '$1 ...')
      return stringValue
    }
  },
  head() {
    return {
      title: 'Grants Title goes here',
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: 'Sample Grants Description'
        }
      ]
    }
  }
}
</script>
<style></style>
