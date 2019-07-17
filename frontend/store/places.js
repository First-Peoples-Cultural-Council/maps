export const state = () => ({
  places: [],
  placesSet: []
})

export const mutations = {
  set(state, places) {
    state.places = places
  },

  setStore(state, placesSet) {
    state.placesSet = placesSet
  }
}
