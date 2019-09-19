<template>
  <div>
    <b-form-file
      ref="fileUpload"
      v-model="file"
      class="file-upload-input"
      :placeholder="placeholder"
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

            <ToolTip
              content="Give the file a title so that users know what it is."
            ></ToolTip>
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

        <ToolTip
          content="If the file needs more information, for example a description of what it includes or copyright information, add it here."
        ></ToolTip>
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
import ToolTip from '@/components/Tooltip.vue'
import { getFormData } from '@/plugins/utils.js'

export default {
  components: {
    ToolTip
  },
  props: {
    id: {
      default: null,
      type: Number
    },
    type: {
      default: 'placename',
      type: String
    },
    placeholder: {
      default: 'Choose a file or drop it here',
      type: String
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
      let result
      if (this.fileName === '' || !this.fileName) {
        return (this.errorMessage = 'Please enter the name of the file')
      }
      const formData = this.getFormData()

      try {
        result = await this.uploadFile(formData)
        if (
          result.request.status === 201 &&
          result.request.statusText === 'Created'
        ) {
          this.$root.$emit('fileUploaded', result.data)
        } else {
          throw result
        }
      } catch (e) {
        console.error(e)
        this.$root.$emit('notification', {
          content: 'File Upload Failed, please try again',
          time: 1500,
          danger: true
        })
      }
      this.resetToInitialState()
    },

    getFormData() {
      return getFormData({
        name: this.fileName,
        file_type: this.file.type,
        description: this.description,
        media_file: this.file,
        type: this.type,
        id: this.id
      })
    },
    async uploadFile(formData) {
      const result = await this.$store.dispatch('file/uploadMedia', formData)
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
