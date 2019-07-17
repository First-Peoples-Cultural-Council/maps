import Vue from 'vue'
Vue.prototype.$eventHub = new Vue({
}) // Global event bus

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
    if (route.name !== 'index-languages-lang') {
      this.map.setFilter('langs-highlighted', ['in', 'name', ''])
    }
  }
})
