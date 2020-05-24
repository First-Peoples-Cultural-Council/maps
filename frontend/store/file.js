import { getCookie } from '@/plugins/utils.js'

export const state = () => ({
  file: null,
  fileList: []
})

export const mutations = {
  setMediaFiles(state, value) {
    state.fileList.push(value)
  },
  setNewMediaFiles(state, value) {
    state.fileList = value
  }
}

export const actions = {
  async uploadMedia({ commit }, formData) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }

    try {
      const result = await this.$axios.post(`/api/media/`, formData, headers)
      return result
    } catch (e) {
      return { error: e, status: 'failed' }
    }
  }
}
