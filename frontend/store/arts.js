export const state = () => ({
  arts: [],
  artsSet: [],
  artSearch: '',
  currentPlacename: {},
  currentMedia: {},
  mediaCount: 0,
  filter: 'artwork',
  taxonomyFilter: [],
  artsSearchSet: [],
  taxonomySearchSet: [],
  artsGeo: [],
  artsGeoSet: [],
  artworks: [],
  artworkSet: [],
  eventsSet: []
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
  setFilter(state, value) {
    state.filter = value
  },
  setTaxonomyTag(state, value) {
    state.taxonomyFilter = value
  },
  setTaxonomySearchSet(state, result) {
    state.taxonomySearchSet = result
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
  },
  setNextEvents(state, events) {
    state.eventsSet = events
  },
  setCurrentPlacename(state, placename) {
    state.currentPlacename = placename
  },
  setMediaCount(state, count) {
    state.mediaCount = count
  },
  setCurrentMedia(state, media) {
    state.currentMedia = media
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
