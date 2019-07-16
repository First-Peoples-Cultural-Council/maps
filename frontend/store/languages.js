export const state = () => ({
  languages: []
})

export const mutations = {
  set(state, languages) {
    state.languages = languages
  }
}
