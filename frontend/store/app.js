export const state = () => ({
  isMobile: false,
  isDataLoaded: false
})

export const mutations = {
  setMobile(state, m) {
    state.isMobile = m
  },
  setIsDataLoaded(state, isLoaded) {
    state.isDataLoaded = isLoaded
  }
}
