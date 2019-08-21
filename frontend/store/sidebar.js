export const state = () => ({
  isDetailMode: false
})

export const mutations = {
  set(state, isDetailMode) {
    state.isDetailMode = isDetailMode
  }
}
