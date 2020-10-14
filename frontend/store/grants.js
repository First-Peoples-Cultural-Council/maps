export const state = () => ({
  grantsGeo: [],
  grantsGeoSet: []
})

export const mutations = {
  setGrantsGeo(state, grantsGeo) {
    state.grantsGeo = grantsGeo
  },
  setGrantsGeoStore(state, grantsGeoSet) {
    state.grantsGeoSet = grantsGeoSet
  }
}
