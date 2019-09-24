import { getCookie, getApiUrl } from '@/plugins/utils.js'

export const state = () => ({
  user: null,
  isLoggedIn: false,
  notifications: null,
  mediaToVerify: null,
  placesToVerify: null,
  membersToVerify: null
})

export const mutations = {
  setUser(state, user) {
    state.user = user
  },

  setLoggedIn(state, loggedIn) {
    state.isLoggedIn = loggedIn
  },

  setNotification(state, notifications) {
    state.notifications = notifications
  },
  setMediaToVerify(state, mtv) {
    state.mediaToVerify = mtv
  },
  setPlacesToVerify(state, ptv) {
    state.placesToVerify = ptv
  },
  setMembersToVerify(state, utv) {
    state.membersToVerify = utv
  }
}

export const actions = {
  async saveLocation({ commit }, data) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }
    try {
      const result = await this.$axios.post(`/api/favourite/`, data, headers)
      return result
    } catch (e) {
      return { error: e, status: 'failed' }
    }
  },

  async approve({ commit }, data) {
    console.log('Data', data)
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }
    const mode = data.verify ? 'verify' : 'reject'
    const result = await this.$axios.patch(
      `${getApiUrl(`${data.type}/${data.tv.id}/${mode}/`)}`,
      {
        status_reason: mode
      },
      headers
    )
    return result
  },

  async addNotification({ commit }, data) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }
    const result = await this.$axios.post(
      getApiUrl(`notification/`),
      data,
      headers
    )
    return result
  },

  async getNotifications({ commit }, data) {
    let result = null
    if (data.isServer) {
      result = await this.$axios.get(
        getApiUrl(`notification?timestamp=${new Date().getTime()}/`)
      )
    } else {
      const headers = {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      }
      result = await this.$axios.get(
        getApiUrl(`notification?timestamp=${new Date().getTime()}/`),
        {},
        headers
      )
    }

    commit('setNotification', result.data)
    return result
  },

  async deleteMedia({ commit }, data) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }
    const result = await this.$axios.delete(
      getApiUrl(`media/${data.id}/`),
      headers
    )

    return result
  },

  async getPlacesToVerify({ commit }, data) {
    const result = await this.$axios.$get(
      `${getApiUrl(
        `placename/list_to_verify?timestamp=${new Date().getTime()}/`
      )}`
    )
    commit('setPlacesToVerify', result)
    return result
  },

  async getMediaToVerify({ commit }, data) {
    const result = await this.$axios.$get(
      `${getApiUrl(`media/list_to_verify?timestamp=${new Date().getTime()}/`)}`
    )
    commit('setMediaToVerify', result)
    return result
  },

  async getMembersToVerify({ commit }, data) {
    const result = await this.$axios.$get(
      `${getApiUrl(
        `community/list_member_to_verify?timestamp=${new Date().getTime()}/`
      )}`
    )
    commit('setMembersToVerify', result)
    return result
  }
}
