export const state = () => ({
  grantsSet: [],
  grantsGeo: [],
  filterDate: null,
  currentGrant: null
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
  }
}
