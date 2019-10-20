export const state = () => ({
  isDetailMode: false,
  mobileContent: false
})

export const mutations = {
  set(state, isDetailMode) {
    state.isDetailMode = isDetailMode
  },

  setMobileContent(state, mobileContent) {
    state.mobileContent = mobileContent
  }
}
