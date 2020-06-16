export const state = () => ({
  communities: [],
  communitySet: []
})

export const mutations = {
  set(state, communities) {
    state.communities = communities
  },

  setStore(state, communitySet) {
    state.communitySet = communitySet
  }
}
