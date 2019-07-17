export const state = () => ({
  languages: [],
  languageSet: []
})

export const mutations = {
  set(state, languages) {
    state.languages = languages
  },

  setStore(state, languageSet) {
    state.languageSet = languageSet
  }
}
