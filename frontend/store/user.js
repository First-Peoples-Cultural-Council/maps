export const state = () => ({
  email: null,
  isLoggedIn: false
})

export const mutations = {
  setUserEmail(state, email) {
    state.email = email
  },

  setLoggedIn(state, loggedIn) {
    state.isLoggedIn = loggedIn
  }
}
