export const state = () => ({
  isDetailMode: false,
  mobileContent: false,
  isArtsMode: false,
  showGallery: false
})

export const mutations = {
  set(state, isDetailMode) {
    state.isDetailMode = isDetailMode
  },

  setMobileContent(state, mobileContent) {
    state.mobileContent = mobileContent
  },

  setDrawerContent(state, value) {
    state.isArtsMode = value
  },

  setGallery(state, value) {
    state.showGallery = value
  }
}
