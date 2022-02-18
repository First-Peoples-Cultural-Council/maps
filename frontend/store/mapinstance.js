import assign from 'lodash/assign'

export const state = () => ({
  mapInstance: null,
  mapState: {
    previous: null,
    now: null
  },
  lat: '',
  lng: '',
  zoom: '',
  forceReset: false,
  embedOptions: ['embed=1']
})

export const mutations = {
  set(state, mapInstance) {
    state.mapInstance = mapInstance
  },
  setDraw(state, draw) {
    state.draw = draw
  },
  setView(state, { lat, lng, zoom }) {
    state.lat = lat
    state.lng = lng
    state.zoom = zoom
  },
  setMapState(state, { lat, lng, zoom }) {
    if (state.mapState.now !== null) {
      state.mapState.previous = assign({}, state.mapState.now)
      state.mapState.now = {
        lat,
        lng,
        zoom
      }
    } else {
      state.mapState.now = {
        lat,
        lng,
        zoom
      }
    }
  },
  setForceReset(state, resetState) {
    state.forceReset = resetState
  },
  setEmbedOptions(state, embedOptions) {
    state.embedOptions = embedOptions
  }
}
