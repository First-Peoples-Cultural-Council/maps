export const state = () => ({
  communities: null
})

export const mutations = {
  set(state, communities) {
    state.communities = communities
  }
}
