export const state = () => ({
  mapInstance: null,
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
  }
}
