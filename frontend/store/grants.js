export const state = () => ({
  grantsGeo: [],
  grantsGeoSet: [],
  filterDate: null,
  currentGrant: null,
  categorySearchSet: [],
  grantFilterMode: 'arts',
  grantCategoryList: []
})

export const mutations = {
  setGrantsGeo(state, grantsGeo) {
    state.grantsGeo = grantsGeo
  },
  setGrantsGeoStore(state, grantsGeoSet) {
    state.grantsGeoSet = grantsGeoSet
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
  }
}
