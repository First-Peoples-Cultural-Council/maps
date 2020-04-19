export const state = () => ({
  arts: [],
  artsSet: [],
  artsSearchSet: [],
  artSearch: '',
  artsGeo: [],
  artsGeoSet: [],
  artworks: [],
  artworkSet: []
})

export const mutations = {
  set(state, arts) {
    state.arts = arts
  },
  setStore(state, artsSet) {
    state.artsSet = artsSet
  },
  setSearchStore(state, artsSearchSet) {
    state.artsSearchSet = artsSearchSet
  },
  setArtSearch(state, query) {
    state.artSearch = query
  },
  setGeo(state, artsGeo) {
    state.artsGeo = artsGeo
  },
  setGeoStore(state, artsGeoSet) {
    state.artsGeoSet = artsGeoSet
  },
  setArtworks(state, artworks) {
    state.artworks = artworks
  },
  setArtworksStore(state, artworkSet) {
    state.artworkSet = artworkSet
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
  },
  getArtsGeoIds({ state }) {
    return state.artsGeo.map(art => art.id)
  }
}
