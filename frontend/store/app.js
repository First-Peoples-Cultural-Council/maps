export const state = () => ({
  isMobile: false,
  isDataLoaded: false,
  isEmbed: false,
  showOtherLanguages: true,
  showCommunitiesOutsideLanguage: true,
  showArtsPoints: true,
  lockBounds: false
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
  },
  setShowOtherLanguages(state, showOtherLanguages) {
    state.showOtherLanguages = showOtherLanguages
  },
  setShowCommunitiesOutsideLanguage(state, showCommunitiesOutsideLanguage) {
    state.showCommunitiesOutsideLanguage = showCommunitiesOutsideLanguage
  },
  setShowArtsPoints(state, showArtsPoints) {
    state.showArtsPoints = showArtsPoints
  },
  setLockBounds(state, lockBounds) {
    state.lockBounds = lockBounds
  }
}
