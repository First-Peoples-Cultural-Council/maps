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
  setSearchSet(state, communitySearchSet) {
    state.communitySearchSet = communitySearchSet
  }
}
