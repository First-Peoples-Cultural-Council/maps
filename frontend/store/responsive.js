export const state = () => ({
  isMobileSideBarOpen: false
})

export const mutations = {
  setMobileSideBarState(state, mobileSideBarState) {
    state.isMobileSideBarOpen = mobileSideBarState
  }
}
