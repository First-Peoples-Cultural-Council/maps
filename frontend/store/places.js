export const state = () => ({
  places: []
})

export const mutations = {
  set(state, places) {
    state.places = places
  }
}
