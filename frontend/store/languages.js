export const state = () => ({
  languages: [],
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
  }
}
