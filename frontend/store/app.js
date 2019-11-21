export const state = () => ({
  isMobile: false
})

export const mutations = {
  setMobile(state, m) {
    state.isMobile = m
  }
}
