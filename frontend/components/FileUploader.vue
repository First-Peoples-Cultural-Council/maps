<template>
  <div>
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
      <b-form-textarea
        id="textarea"
        v-model="description"
        placeholder="Enter description"
        rows="3"
        max-rows="6"
        class="mt-2 mb-2"
      ></b-form-textarea>
      <b-button @click="handleUpload">Upload</b-button>
      <b-button @click="resetToInitialState">Cancel</b-button>
    </div>
    <div v-if="errorMessage">
      {{ errorMessage }}
    </div>
  </div>
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
      description: null,
      errorMessage: null,
      successMessage: null
    }
  },
  methods: {
    resetToInitialState() {
      this.fileName = null
      this.file = null
      this.description = null
      this.errorMessage = null
      this.successMessage = null
      this.clearFiles()
    },
    clearFiles() {
      this.$refs.fileUpload.reset()
    },
    async handleUpload() {
      console.log('Cookie', getCookie('csrftoken'))
      const formData = this.getFormData()
      try {
        const result = await this.uploadFile(formData)
        this.clearFiles()
        this.$root.$emit('fileUploaded', result)
        console.log(this)
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
      formData.append('description', this.description)
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
