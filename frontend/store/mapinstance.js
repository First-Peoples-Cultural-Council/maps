import { assign } from 'lodash'

export const state = () => ({
  mapInstance: null,
  mapState: {
    previous: null,
    now: null
  },
  lat: '',
  lng: '',
  zoom: ''
})

export const mutations = {
  set(state, mapInstance) {
    state.mapInstance = mapInstance
  },

  setView(state, { lat, lng, zoom }) {
    state.lat = lat
    state.lng = lng
    state.zoom = zoom
  },

  setMapState(state, { lat, lng, zoom }) {
    state.mapState.previous = assign({}, state.mapState.now)
    state.mapState.now = {
      lat,
      lng,
      zoom
    }
  }
}
