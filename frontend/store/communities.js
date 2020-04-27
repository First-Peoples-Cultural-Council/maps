export const state = () => ({
  communities: [],
  communitySet: [],
  communitySearchSet: []
})

export const mutations = {
  set(state, communities) {
    state.communities = communities
  },
  setStore(state, communitySet) {
    state.communitySet = communitySet
  },
  setSearchStore(state, communitySearchSet) {
    state.communitySearchSet = communitySearchSet
  }
}
