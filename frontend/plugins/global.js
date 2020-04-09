import Vue from 'vue'
import { geomToLatLng } from '@/plugins/utils.js'

const _markers = []
Vue.prototype.$eventHub = new Vue({}) // Global event bus

Vue.prototype.$eventHub.whenMap = function(fn) {
  if (this.map) {
    fn(this.map)
  } else {
    this.$on('map-loaded', fn)
  }
}
Vue.prototype.$eventHub.revealArea = function(geometry) {
  this.whenMap(map => {
    const mapboxgl = require('mapbox-gl')

    const el = document.createElement('div')
    el.className = 'marker hover-marker'
    el.innerHTML =
      '<svg xmlns="http://www.w3.org/2000/svg" width="19.019" height="12.436" viewBox="0 0 19.019 12.436"><defs><style>.a{fill:#fff;}</style></defs><path class="a" d="M1664.865,763.183l-1.3,1.3,3.991,3.991h-15.493v1.856h15.493l-3.991,3.991,1.3,1.3,6.218-6.218Z" transform="translate(-1652.064 -763.184)"/></svg>'
    // console.log('where', geometry, geomToLatLng(geometry))
    const marker = new mapboxgl.Marker(el).setLngLat(geomToLatLng(geometry))
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

    // console.log('routed to', route.name)

    // if (route.name !== 'index-content-fn') {
    //   this.map.setFilter('fn-nations-highlighted', ['in', 'name', ''])
    // }
    // if (route.name !== 'index-place-names-placename') {
    //   this.map.setFilter('fn-places-highlighted', ['in', 'name', ''])
    // }

    const markers = this.map.getContainer().getElementsByClassName('marker')
    for (let i = 0; i < markers.length; i++) {
      const marker = markers[i]
      marker.remove()
    }
  }
})
