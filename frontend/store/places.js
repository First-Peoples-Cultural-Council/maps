import { getApiUrl } from '@/plugins/utils.js'

export const state = () => ({
  places: [],
  placesSet: [],
  medias: []
})

export const mutations = {
  set(state, places) {
    state.places = places
  },

  setStore(state, placesSet) {
    state.placesSet = placesSet
  },

  setMedias(state, medias) {
    state.medias = medias
  }
}

export const actions = {
  async getPlaceMedias({ commit }, data) {
    console.log(
      'API TEXT',
      getApiUrl(`placename/${data.id}?timestamp=${new Date().getTime()}/`)
    )
    const result = await this.$axios.$get(
      getApiUrl(`placename/${data.id}?timestamp=${new Date().getTime()}/`)
    )
    console.log('Dispatch', result.medias)
    commit('setMedias', result.medias)
    return result
  }
}
