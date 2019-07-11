export const state = () => ({
  languages: null
})

export const mutations = {
  set(state, languages) {
    state.languages = languages
  }
}
