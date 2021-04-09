<template>
  <div>
    <b-form-file
      ref="fileUpload"
      v-model="file"
      accept="image/*, video/*"
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
          aria-describedby="title-help title-feedback"
          rows="3"
          max-rows="6"
          class="mt-2 mb-2 font-08"
        ></b-form-textarea>

        <CommunityOnly
          v-if="!isArtwork"
          :commonly.sync="commonly"
        ></CommunityOnly>

        <b-button variant="dark" size="sm" @click="handleUpload"
          >Upload</b-button
        >
        <b-button
          size="sm"
          variant="dark"
          class=""
          @click="$root.$emit('closeUploadModal')"
          >Cancel</b-button
        >
      </div>
    </transition>
  </div>
</template>

<script>
import ToolTip from '@/components/Tooltip.vue'
import { getFormData } from '@/plugins/utils.js'
import CommunityOnly from '@/components/CommunityOnly.vue'

export default {
  components: {
    ToolTip,
    CommunityOnly
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
      fileName: '',
      file: null,
      description: '',
      errorMessage: null,
      successMessage: null,
      commonly: 'not_accepted'
    }
  },
  computed: {
    isArtwork() {
      return this.$route.query.type || this.$route.query.upload_artwork
    }
  },
  methods: {
    resetToInitialState() {
      this.fileName = ''
      this.file = null
      this.description = ''
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

      if (this.$route.query.mode === 'placename' || this.$route.query.type) {
        this.$store.commit('file/setMediaFiles', this.getMediaData())
      } else {
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
          this.$root.$on('fileUploadFailed', 'File')
        }
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
        id: this.id,
        community_only: this.commonly === 'accepted',
        is_artwork: !!this.$route.query.upload_artwork
      })
    },

    getMediaData() {
      return {
        name: this.fileName,
        file_type: 'image',
        description: this.description,
        media_file: this.file,
        type: this.type,
        id: this.id,
        community_only: false
      }
    },
    async uploadFile(formData) {
      const dataObj = {
        formData,
        callProgressModal: this.callProgressModal
      }

      const result = await this.$store.dispatch('file/uploadMedia', dataObj)
      return result
    },
    callProgressModal(value) {
      this.$root.$emit('initiateLoadingModal', value)
    }
  }
}
</script>

<style>
.file-upload-input {
  font-size: 0.8em;
  overflow: hidden;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
