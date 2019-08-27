export const state = () => ({
  email: null
})

export const mutations = {
  setUserEmail(state, email) {
    state.email = email
  }
}
