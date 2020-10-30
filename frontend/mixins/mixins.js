import Vue from 'vue'

const showGrantsForProgram = (context, program) => {
  const geoJSON = JSON.parse(
    JSON.stringify(context.$store.state.grants.grantsGeo)
  )
  const features = geoJSON.features

  if (program === 'language') {
    const languageGrants = features.filter(grant => {
      return grant.properties.category_abbreviation.startsWith('L')
    })
    geoJSON.features = languageGrants
  } else if (program === 'arts') {
    const artsGrants = features.filter(grant => {
      return grant.properties.category_abbreviation.startsWith('A')
    })
    geoJSON.features = artsGrants
  } else if (program === 'heritage') {
    const heritageGrants = features.filter(grant => {
      return grant.properties.category_abbreviation.startsWith('H')
    })
    geoJSON.features = heritageGrants
  }
  context.$root.$emit('updateGrantsMarkers', geoJSON)
}

Vue.mixin({
  methods: {
    getBadgeStatus(mode, data) {
      if (mode === 'All') {
        return 'neutral'
      } else if (mode === data) {
        return 'active'
      } else {
        return 'inactive'
      }
    },
    handleBadge(e, data) {
      const isMobileSideBarOpen = this.$store.state.responsive
        .isMobileSideBarOpen
      if (this.mode === data) {
        this.mode = 'All'
      } else {
        this.mode = data
      }

      if (this.$route.name === 'index-art') {
        this.$store.commit('arts/setFilter', data)
      }

      if (this.$route.name === 'index-grants') {
        this.$store.commit('grants/setGrantFilter', data)
        this.$root.$emit('resetMap')

        showGrantsForProgram(this, data)
      }

      if (e && isMobileSideBarOpen) {
        e.stopPropagation()
      }
    },
    goToGrants(program) {
      this.$store.commit('grants/setGrantFilter', program)
      this.$root.$emit('checkDimension')

      showGrantsForProgram(this, program)

      this.$router.push({
        path: '/grants'
      })
    }
  }
})
