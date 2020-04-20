export const state = () => ({
  arts: [],
  artsSet: [],
  artSearch: '',
  filter: 'artwork',
  selectedFilterTag: []
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
  },
  setFilter(state, value) {
    state.filter = value
  },
  setFilterTag(state, value) {
    state.selectedFilterTag = value
  }
}
