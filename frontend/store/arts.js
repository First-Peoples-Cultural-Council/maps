export const state = () => ({
  arts: [],
  artsSet: [],
  artSearch: ''
})

export const mutations = {
  set(state, arts) {
    state.arts = arts
  },

  setStore(state, artsSet) {
    state.artsSet = artsSet
  },
  setArtSearch(state, query) {
    state.artSearch = query
  }
}
