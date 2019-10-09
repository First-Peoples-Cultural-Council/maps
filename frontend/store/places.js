import { getApiUrl, getCookie } from '@/plugins/utils.js'

export const state = () => ({
  place: null,
  placeCommunity: null,
  places: [],
  placesSet: [],
  medias: [],
  favourites: [],
  badgePlaces: [],
  filteredBadgePlaces: []
})

export const mutations = {
  set(state, places) {
    state.places = places
  },

  setPlace(state, place) {
    state.place = place
  },

  setPlaceCommunity(state, placeComm) {
    state.placeCommunity = placeComm
  },

  setStore(state, placesSet) {
    state.placesSet = placesSet
  },

  setMedias(state, medias) {
    state.medias = medias
  },

  setFavourites(state, favourites) {
    state.favourites = favourites
  },

  setBadgePlaces(state, bplaces) {
    state.badgePlaces = bplaces
  },

  setFilteredBadgePlaces(state, fplaces) {
    state.filteredBadgePlaces = fplaces
  }
}

export const actions = {
  async getPlaceMedias({ commit }, data) {
    const result = await this.$axios.$get(
      getApiUrl(`placename/${data.id}?timestamp=${new Date().getTime()}/`)
    )
    console.log('Dispatch', result.medias)
    commit('setMedias', result.medias)
    return result
  },

  async getPlace({ commit, dispatch }, data) {
    const result = await this.$axios.$get(
      getApiUrl(`placename/${data.id}?timestamp=${new Date().getTime()}/`)
    )
    commit('setPlace', result)
    if (result.community) {
      dispatch(
        'places/getPlaceCommunity',
        {
          id: result.community
        },
        {
          root: true
        }
      )
    }
    return result
  },

  async getPlaceCommunity({ commit }, data) {
    const result = await this.$axios.$get(getApiUrl(`community/${data.id}/`))
    commit('setPlaceCommunity', result)
    return result
  },

  async getFavourites({ commit }, data) {
    const result = await this.$axios.$get(
      getApiUrl(`favourite?timestamp=${new Date().getTime()}/`)
    )
    commit('setFavourites', result)
    return result
  },

  async setFavourite({ commit, dispatch }, data) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }
    const result = await this.$axios.post(
      getApiUrl(`favourite/`),
      data,
      headers
    )
    await dispatch('places/getFavourites', {}, { root: true })
    return result
  },

  async removeFavourite({ commit, dispatch }, data) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }
    const result = await this.$axios.delete(
      getApiUrl(`favourite/${data.favourite.id}`),
      headers
    )
    await dispatch('places/getFavourites', {}, { root: true })
    return result
  }
}
