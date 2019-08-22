export const state = () => ({
  isDrawMode: false,
  mode: null,
  drawnFeatures: []
})

export const mutations = {
  setMode(state, mode) {
    state.mode = mode
  },

  setIsDrawMode(state, isDrawMode) {
    state.isDrawMode = isDrawMode
  },

  setDrawnFeatures(state, drawnFeatures) {
    state.drawnFeatures = drawnFeatures
  }
}
