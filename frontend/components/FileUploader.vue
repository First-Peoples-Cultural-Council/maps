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
            <label class="font-08" for="file-name">Title</label>
            <b-button
              v-b-tooltip.hover.click.top="
                'Give the file a title so that users know what it is.'
              "
              size="sm"
              variant="dark"
              style="padding: 0.05em 0.5em !important;"
              >?</b-button
            >
            <b-form-input
              id="file-name"
              v-model="fileName"
              class="font-08"
              placeholder="Enter Title (required)"
              required
            ></b-form-input>
          </b-col>
        </b-row>
        <label class="mt-3 font-08" for="textarea">Description</label>
        <b-button
          v-b-tooltip.hover.click.top="
            'If the file needs more information, for example a description of what it includes or copyright information, add it here.'
          "
          size="sm"
          variant="dark"
          style="padding: 0.05em 0.5em !important;"
          >?</b-button
        >
        <b-form-textarea
          id="textarea"
          v-model="description"
          placeholder="Enter description"
          rows="3"
          max-rows="6"
          class="mt-2 mb-2 font-08"
        ></b-form-textarea>
        <b-button variant="info" size="sm" @click="handleUpload"
          >Upload</b-button
        >
        <b-button variant="danger" size="sm" @click="resetToInitialState"
          >Cancel</b-button
        >
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
      if (this.fileName === '' || !this.fileName) {
        return (this.errorMessage = 'Please enter the name of the file')
      }
      const formData = this.getFormData()
      try {
        const result = await this.uploadFile(formData)
        this.clearFiles()
        this.$root.$emit('fileUploaded', result)
        this.file = null
        this.fileName = ''
        this.description = ''
      } catch (e) {}
    },
    getFormData() {
      const formData = new FormData()
      formData.append('name', this.fileName)
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
