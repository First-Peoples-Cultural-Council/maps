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
        this.$store.commit('arts/setFilter', 'All')
      } else {
        this.mode = data
        this.$store.commit('arts/setFilter', data)
      }

      if (isMobileSideBarOpen) {
        e.stopPropagation()
      }
    }
  }
})
