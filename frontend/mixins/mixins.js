import Vue from 'vue'
Vue.mixin({
  mounted() {
    this.$store.commit('sidebar/set', false)
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
      console.log('Data', data)
      if (this.mode === data) {
        this.mode = 'All'
      } else {
        this.mode = data
      }

      console.log('Mode', this.mode)

      if (isMobileSideBarOpen) {
        e.stopPropagation()
      }
    }
  }
})
