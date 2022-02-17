export const state = () => ({
  isMobile: false,
  isDataLoaded: false,
  isEmbed: false,
  showOtherLanguages: false,
  showCommunities: false,
  showCommunitiesOutsideLanguage: false,
  showArtsPoints: false,
  showHeritagePoints: false,
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
  setShowCommunities(state, showCommunities) {
    state.showCommunities = showCommunities
  },
  setShowCommunitiesOutsideLanguage(state, showCommunitiesOutsideLanguage) {
    state.showCommunitiesOutsideLanguage = showCommunitiesOutsideLanguage
  },
  setShowArtsPoints(state, showArtsPoints) {
    state.showArtsPoints = showArtsPoints
  },
  setShowHeritagePoints(state, showHeritagePoints) {
    state.showHeritagePoints = showHeritagePoints
  },
  setLockBounds(state, lockBounds) {
    state.lockBounds = lockBounds
  }
}
