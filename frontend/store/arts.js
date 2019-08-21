export const state = () => ({
  arts: [],
  artsSet: []
})

export const mutations = {
  set(state, arts) {
    state.arts = arts
  },

  setStore(state, artsSet) {
    state.artsSet = artsSet
  }
}
