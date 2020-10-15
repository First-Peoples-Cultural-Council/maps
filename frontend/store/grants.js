export const state = () => ({
  grantsGeo: [],
  grantsGeoSet: [],
  filterDate: { fromDate: 0, toDate: 0 },
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
  }
}
