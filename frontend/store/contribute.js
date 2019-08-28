export const state = () => ({
  isDrawMode: false,
  mode: null,
  drawnFeatures: [],
  languagesInFeature: [],
  audioBlob: null,
  audioFile: null,
  name: null,
  files: []
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
  },

  setLanguagesInFeature(state, languagesInFeature) {
    state.languagesInFeature = languagesInFeature
  },

  setAudioBlob(state, audioBlob) {
    state.audioBlob = audioBlob
  },

  setName(state, name) {
    state.name = name
  },

  setFiles(state, files) {
    state.files = files
  },

  addFile(state, file) {
    state.files.push(file)
  },

  setAudioFile(state, audioFile) {
    state.audioFile = audioFile
  }
}
