<template>
  <div>
    <b-form-file
      ref="fileUpload"
      v-model="file"
      class="file-upload-input"
      placeholder="Choose a file or drop it here..."
      drop-placeholder="Drop file here..."
    ></b-form-file>
    <transition name="fade">
      <div v-if="file" class="mt-4">
        <div v-if="errorMessage">
          <b-alert variant="warning" show>{{ errorMessage }}</b-alert>
        </div>
        <b-row>
          <b-col xl="12">
            <b-form-input
              id="file-name"
              v-model="fileName"
              class="font-08"
              placeholder="Enter Name (required)"
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
          class="mt-2 mb-2 font-08"
        ></b-form-textarea>
        <b-button @click="handleUpload">Upload</b-button>
        <b-button @click="resetToInitialState">Cancel</b-button>
      </div>
    </transition>
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
      console.log('File Name', this.fileName)
      if (this.fileName === '' || !this.fileName) {
        return (this.errorMessage = 'Please enter the name of the file')
      }
      const formData = this.getFormData()
      try {
        const result = await this.uploadFile(formData)
        this.clearFiles()
        this.$root.$emit('fileUploaded', result)
        this.file = null
      } catch (e) {
        console.error(e)
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

<style>
.file-upload-input {
  font-size: 0.8em;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
