export const state = () => ({
  isMobile: false,
  isDataLoaded: false,
  isEmbed: false
})

export const mutations = {
  setMobile(state, m) {
    state.isMobile = m
  },
  setIsDataLoaded(state, isLoaded) {
    state.isDataLoaded = isLoaded
  },
  setIsEmbed(state, isEmbed) {
    state.isEmbed = isEmbed
  }
}
