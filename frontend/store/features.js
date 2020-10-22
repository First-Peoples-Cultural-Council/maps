export const state = () => ({
  feature: null,
  marker: null,
  popup: null
})

export const mutations = {
  set(state, feature) {
    state.feature = feature
  },
  setMarker(state, marker) {
    if (state.marker) state.marker.remove()

    state.marker = marker
  },
  setPopup(state, popup) {
    if (state.popup) state.popup.remove()

    state.popup = popup
  }
}
