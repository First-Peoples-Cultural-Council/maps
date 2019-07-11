export const state = () => ({
  communities: []
})

export const mutations = {
  set(state, communities) {
    state.communities = communities
  }
}
