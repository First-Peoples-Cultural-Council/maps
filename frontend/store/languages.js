export const state = () => ({
  languages: [],
  languageSet: [],
  languageGeo: []
})

export const mutations = {
  set(state, languages) {
    state.languages = languages
  },

  setStore(state, languageSet) {
    state.languageSet = languageSet
  },

  setGeo(sate, languageGeo) {
    state.languageGeo = languageGeo
  }
}
