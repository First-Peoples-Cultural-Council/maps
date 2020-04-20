export const state = () => ({
  arts: [],
  artsSet: [],
  artSearch: '',
  filter: 'artwork',
  selectedFilterTag: [],
  artsSearchSet: [],
  taxonomySearchSet: []
})

export const mutations = {
  set(state, arts) {
    state.arts = arts
  },
  setStore(state, artsSet) {
    state.artsSet = artsSet
  },
  setSearchSet(state, artsSearchSet) {
    state.artsSearchSet = artsSearchSet
  },
  setArtSearch(state, query) {
    state.artSearch = query
  },
  setFilter(state, value) {
    state.filter = value
  },
  setFilterTag(state, value) {
    state.selectedFilterTag = value
  },
  setTaxonomySearchSet(state, result) {
    state.taxonomySearchSet = result
  }
}

export const actions = {
  isKindLoaded({ state }, kind) {
    if (!state.artsSet) {
      return false
    } else {
      const data = state.artsSet.find(art => art.properties.kind === kind)

      const isLoaded = !!data
      return isLoaded
    }
  }
}
