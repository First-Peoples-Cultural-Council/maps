export const state = () => ({
  isDetailMode: false,
  mode: 'All'
})

export const mutations = {
  set(state, isDetailMode) {
    state.isDetailMode = isDetailMode
  },

  setMode(state, mode) {
    state.mode = mode
  }
}
