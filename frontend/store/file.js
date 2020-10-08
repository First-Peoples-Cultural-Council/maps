import { getApiUrl, getCookie } from '@/plugins/utils.js'

export const state = () => ({
  file: null,
  fileList: []
})

export const mutations = {
  setMediaFiles(state, value) {
    state.fileList.unshift(value)
  },
  setNewMediaFiles(state, value) {
    state.fileList = value
  }
}

export const actions = {
  async uploadMedia({ commit }, dataObj) {
    const config = {
      headers: { 'X-CSRFToken': getCookie('csrftoken') },
      onUploadProgress: progressEvent => {
        const { loaded, total } = progressEvent
        const percentCompleted = Math.round((loaded * 100) / total)
        console.log(`${loaded}KB uploaded of ${total}KB`)

        if (dataObj.callProgressModal) {
          dataObj.callProgressModal(percentCompleted)
        }
      }
    }

    try {
      const result = await this.$axios.post(
        `/api/media/`,
        dataObj.formData,
        config
      )
      return result
    } catch (e) {
      return { error: e, status: 'failed' }
    }
  },

  async getUploadMedia({ state, commit }, id) {
    const removeOld = state.fileList.filter(file => {
      return !file.creator
    })

    // Reset list of Media, removed existing ones
    commit('setNewMediaFiles', removeOld)

    try {
      const result = await this.$axios.get(getApiUrl(`media/?placename=${id}`))
      if (result) {
        const newMedia = result.data.sort((a, b) => b.id - a.id)
        commit('setNewMediaFiles', [...removeOld, ...newMedia])
        return result
      }
    } catch (e) {
      return { error: e, status: 'failed' }
    }
  }
}
