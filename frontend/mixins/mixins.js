import Vue from 'vue'

Vue.mixin({
  computed: {
    isSuperUser() {
      if (!this.$store.state.user.user) {
        return null
      }
      return this.$store.state.user.user.is_superuser
    },
    routeName() {
      return this.$route.name
    },
    isEmbed() {
      return this.$store.state.app.isEmbed
    },
    showOtherLanguages() {
      return this.$store.state.app.showOtherLanguages
    },
    showCommunities() {
      return this.$store.state.app.showCommunities
    },
    showCommunitiesOutsideLanguage() {
      return this.$store.state.app.showCommunitiesOutsideLanguage
    },
    showArtsPoints() {
      return this.$store.state.app.showArtsPoints
    },
    showHeritagePoints() {
      return this.$store.state.app.showHeritagePoints
    },
    lockBounds() {
      return this.$store.state.app.lockBounds
    }
  },
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
      }

      if (e && isMobileSideBarOpen) {
        e.stopPropagation()
      }
    },
    goToGrants(program) {
      this.$store.commit('grants/setGrantFilter', program)
      this.$root.$emit('checkDimension')
      // Close Drawer on every Grants redirection
      this.$store.commit('sidebar/setDrawerContent', false)

      this.$router.push({
        path: '/grants'
      })
    }
  }
})
