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
    // whatever route we're on, its data should be allowed to overlap other stuff.
    this.map.setLayoutProperty('fn-arts', 'icon-allow-overlap', false)
    this.map.setLayoutProperty('fn-arts', 'text-allow-overlap', false)
    this.map.setLayoutProperty('fn-nations', 'icon-allow-overlap', false)
    this.map.setLayoutProperty('fn-nations', 'text-allow-overlap', false)
    this.map.setLayoutProperty('fn-places', 'icon-allow-overlap', false)
    this.map.setLayoutProperty('fn-places', 'text-allow-overlap', false)

    if (route.name === 'index-content-fn') {
      this.map.setLayoutProperty('fn-nations', 'icon-allow-overlap', true)
      this.map.setLayoutProperty('fn-nations', 'text-allow-overlap', true)
    }
    if (route.name === 'index-art-art') {
      this.map.setLayoutProperty('fn-arts', 'icon-allow-overlap', true)
      this.map.setLayoutProperty('fn-arts', 'text-allow-overlap', true)
    }
    if (route.name === 'index-place-names-placename') {
      this.map.setLayoutProperty('fn-places', 'icon-allow-overlap', true)
      this.map.setLayoutProperty('fn-places', 'text-allow-overlap', true)
    }
  }
})

Vue.mixin({
  mounted() {
    this.$store.commit('sidebar/set', false)
  }
})
