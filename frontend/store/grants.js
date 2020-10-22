export const state = () => ({
  grantsSet: [],
  grantsGeo: [],
  filterDate: null,
  currentGrant: null,
  categorySearchSet: [],
  grantFilterMode: 'all',
  grantCategoryList: [],
  grantsSearch: ''
})

export const mutations = {
  setGrants(state, grantsSet) {
    state.grantsSet = grantsSet
  },
  setGrantsGeo(state, grantsGeo) {
    state.grantsGeo = grantsGeo
  },
  setGrantFilterDate(state, value) {
    state.filterDate = value
  },
  setCurrentGrant(state, grant) {
    state.currentGrant = grant
  },
  setGrantCategorySearchSet(state, result) {
    state.categorySearchSet = result
  },
  setGrantFilter(state, value) {
    state.grantFilterMode = value
  },
  setCategoryTag(state, value) {
    state.grantCategoryList = value
  },
  setGrantsSearch(state, query) {
    state.grantsSearch = query
  }
}
