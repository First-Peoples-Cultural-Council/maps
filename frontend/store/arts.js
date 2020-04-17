export const state = () => ({
  arts: [],
  artsSet: [],
  artsSearchSet: []
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
  }
}
