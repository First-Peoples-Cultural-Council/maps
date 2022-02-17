export const state = () => ({
  isMobile: false,
  isDataLoaded: false,
  isEmbed: false,
  showOtherLanguages: true,
  showCommunitiesOutsideLanguage: true,
  showCommunities: true,
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
  setShowCommunities(state, showCommunities) {
    state.showCommunities = showCommunities
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
