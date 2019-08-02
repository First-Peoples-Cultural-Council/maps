export const state = () => ({
  languages: [],
  languagesCount: null,
  languageSet: [],
  languageGeo: [],
  comingFromDetail: false
})

export const mutations = {
  set(state, languages) {
    state.languages = languages
  },
  setStore(state, languageSet) {
    state.languageSet = languageSet
  },

  setGeo(state, languageGeo) {
    state.languageGeo = languageGeo
  },
  setComingFromDetail(state, comingFromDetail) {
    state.comingFromDetail = comingFromDetail
  },

  setLanguagesCount(state, languagesCount) {
    state.languagesCount = languagesCount
  }
}
