export const state = () => ({
  feature: null,
  markers: [],
  popups: []
})

export const mutations = {
  set(state, feature) {
    state.feature = feature
  },
  addMarker(state, marker) {
    state.markers.push(marker)
  },
  addPopup(state, popup) {
    state.popups.push(popup)
  }
}
