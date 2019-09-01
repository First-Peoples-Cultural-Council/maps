export const state = () => ({
  user: null,
  isLoggedIn: false
})

export const mutations = {
  setUser(state, user) {
    state.user = user
  },

  setLoggedIn(state, loggedIn) {
    state.isLoggedIn = loggedIn
  }
}
