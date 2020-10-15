export const state = () => ({
  grantsGeo: [],
  grantsGeoSet: [],
  filterDate: null,
  currentGrant: null
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
  setFromDate(state, value) {
    state.filterDate.fromDate = value
  },
  setToDate(state, value) {
    state.filterDate.toDate = value
  }
}
