import Vue from 'vue'

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
      }

      if (e && isMobileSideBarOpen) {
        e.stopPropagation()
      }
    },
    goToGrants(program) {
      this.$store.commit('grants/setGrantFilter', program)
      this.$root.$emit('checkDimension')

      this.$router.push({
        path: '/grants'
      })
    }
  }
})
