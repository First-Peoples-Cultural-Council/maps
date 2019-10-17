import Vue from 'vue'
const _markers = []
Vue.prototype.$eventHub = new Vue({}) // Global event bus

Vue.prototype.$eventHub.whenMap = function(fn) {
  if (this.map) {
    fn(this.map)
  } else {
    this.$on('map-loaded', fn)
  }
}
Vue.prototype.$eventHub.revealArea = function(where) {
  this.whenMap(map => {
    const mapboxgl = require('mapbox-gl')

    const el = document.createElement('div')
    el.className = 'marker hover-marker'
    const marker = new mapboxgl.Marker(el).setLngLat(where)
    marker.addTo(map)
    _markers.push(marker)
  })
}
Vue.prototype.$eventHub.doneReveal = function() {
  for (let i = 0; i < _markers.length; i++) {
    const marker = _markers[i]
    marker.remove()
  }
}

Vue.prototype.$eventHub.$on('map-loaded', function(map) {
  this.map = map
})

Vue.prototype.$eventHub.$on('route-changed', function(route) {
  if (this.map) {
    this.doneReveal() // hide the little magnifier element when routing, it's dependent on a hover and the map position.
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

    const markers = this.map.getContainer().getElementsByClassName('marker')
    for (let i = 0; i < markers.length; i++) {
      const marker = markers[i]
      marker.remove()
    }
    if (route.name !== 'index-place-names-placename') {
      this.map.setFilter('fn-places-highlighted', ['in', 'name', ''])
    }
  }
})
