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
    if (route.name !== 'index-languages-lang') {
      this.map.setFilter('fn-lang-areas-highlighted', ['in', 'name', ''])
    }
  }
})

Vue.mixin({
  mounted() {
    this.$store.commit('sidebar/set', false)
  }
})

export default ({ app }) => {
  // Every time the route changes (fired on initialization too)
  app.router.beforeEach((to, from, next) => {
    console.log('To', to)
    console.log('From', from)
    console.log('To Has Hash?', to.hash)
    if (from.hash && to.hash) {
      next({
        path: to.path
      })
    } else {
      next()
    }
  })
}
