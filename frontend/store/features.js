export const state = () => ({
  feature: null,
  markers: []
})

export const mutations = {
  set(state, feature) {
    state.feature = feature
  },
  addMarker(state, marker) {
    state.markers.push(marker)
  }
}
