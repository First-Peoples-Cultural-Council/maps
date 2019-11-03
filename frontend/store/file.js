import { getCookie } from '@/plugins/utils.js'

export const state = () => ({
  file: null
})

export const mutations = {}

export const actions = {
  async uploadMedia({ commit }, formData) {
    const headers = {
      headers: {
        'X-CSRFToken': getCookie('csrftoken')
      }
    }

    console.log('Headers', headers)
    console.log('FormData', formData)
    try {
      const result = await this.$axios.post(`/api/media/`, formData, headers)
      return result
    } catch (e) {
      return { error: e, status: 'failed' }
    }
  }
}
