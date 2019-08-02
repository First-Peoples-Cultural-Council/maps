import Vue from 'vue'
Vue.prototype.$eventHub = new Vue({}) // Global event bus

Vue.prototype.$eventHub.whenMap = function(fn) {
  if (this.map) {
    fn(this.map)
  } else {
    this.$on('map-loaded', fn)
  }
}

Vue.prototype.$eventHub.$on('map-loaded', function(map) {
  this.map = map
})

Vue.prototype.$eventHub.$on('route-changed', function(route) {
  if (this.map) {
    // hide the highlight box if we navigate away from a language detail.
    if (
      route.name !== 'index-languages-lang' ||
      route.name !== 'index-languages-lang-details'
    ) {
      this.map.setFilter('fn-lang-areas-highlighted', ['in', 'name', ''])
    }

    console.log('routed to', route.name)

    if (route.name !== 'index-content-fn') {
      this.map.setFilter('fn-nations-highlighted', ['in', 'name', ''])
    }
    if (route.name !== 'index-art-art') {
      this.map.setFilter('fn-arts-highlighted', ['in', 'name', ''])
    }
    if (route.name !== 'index-place-names-placename') {
      this.map.setFilter('fn-places-highlighted', ['in', 'name', ''])
    }
  }
})

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

      if (this.mode === data) {
        this.mode = 'All'
      } else {
        this.mode = data
      }

      if (isMobileSideBarOpen) {
        e.stopPropagation()
      }
    }
  }
})
