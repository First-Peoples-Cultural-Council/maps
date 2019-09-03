<template>
  <b-row no-gutters>
    <b-form-file
      ref="fileUpload"
      v-model="file"
      class=""
      placeholder="Choose a file or drop it here..."
      drop-placeholder="Drop file here..."
    ></b-form-file>
    <div v-if="file">
      <b-row>
        <b-col xl="3">
          <label for="file-name">Name: </label>
        </b-col>
        <b-col xl="9">
          <b-form-input
            id="file-name"
            v-model="fileName"
            placeholder="Enter Name"
            required
          ></b-form-input>
        </b-col>
      </b-row>
      <b-button @click="handleUpload">Upload</b-button>
    </div>
    <div v-if="errorMessage">
      {{ errorMessage }}
    </div>
  </b-row>
</template>

<script>
import { getCookie } from '@/plugins/utils.js'

export default {
  props: {
    placeId: {
      default: null,
      type: Number
    }
  },
  data() {
    return {
      fileName: null,
      file: null,
      errorMessage: null,
      successMessage: null
    }
  },
  methods: {
    clearFiles() {
      this.$refs.fileUpload.reset()
    },
    async handleUpload() {
      console.log('Cookie', getCookie('csrftoken'))
      const formData = this.getFormData()
      try {
        const result = await this.uploadFile(formData)
        this.clearFiles()
        this.file = null
        console.log('Upload Result', result)
      } catch (e) {
        console.error(e)
        this.errorMessage(e)
      }
    },
    getFormData() {
      const formData = new FormData()
      formData.append('name', this.fileName)
      formData.append('description', '')
      formData.append('file_type', this.file.type)
      formData.append('media_file', this.file)
      formData.append('placename', this.placeId)
      return formData
    },
    async uploadFile(formData) {
      const result = await this.$axios.$post(`/api/media/`, formData, {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      })
      return result
    }
  }
}
</script>

<style></style>
