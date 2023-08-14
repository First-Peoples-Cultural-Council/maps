<template>
  <div>
    <div class="upload-img-container mt-3">
      <div v-if="file" class="upload-img">
        <img
          v-if="fileSrc === null"
          class="upload-placeholder"
          :src="require(`@/assets/images/artist_icon.svg`)"
        />
        <img v-else :src="fileSrc" />
        <b-button
          v-if="fileSrc !== null"
          class="upload-remove"
          @click="removeImg()"
          >Remove Image</b-button
        >
      </div>

      <b-form-file
        ref="fileUpload"
        v-model="file"
        accept="image/*, video/*"
        class="file-upload-input"
        :placeholder="placeholder"
        drop-placeholder="Drop file here..."
      ></b-form-file>
    </div>

    <transition name="fade">
      <div v-if="file" class="mt-4">
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

        <div v-if="errorMessage">
          <b-alert variant="warning" show>{{ errorMessage }}</b-alert>
        </div>

        <b-row class="field-row my-4">
          <b-form-checkbox
            id="is-agree"
            v-model="isAgree"
            class="d-inline-block ml-3"
            name="is-agree"
          >
            By uploading this I acknowledge that I own the copyright to this
            media. FPCC does not take responsibility for the content uploaded to
            the First Peoples’ Map of B.C.
          </b-form-checkbox>
        </b-row>

        <b-button
          variant="dark"
          size="sm"
          :disabled="!isAgree"
          @click="handleUpload"
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

const base64Encode = data =>
  new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(data)
    reader.onload = () => resolve(reader.result)
    reader.onerror = error => reject(error)
  })

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
      fileSrc: null,
      description: '',
      errorMessage: null,
      successMessage: null,
      commonly: 'not_accepted',
      isAgree: false
    }
  },
  computed: {
    isArtwork() {
      return this.$route.query.type || this.$route.query.upload_artwork
    }
  },
  watch: {
    file(newValue, oldValue) {
      if (newValue !== oldValue) {
        if (newValue) {
          base64Encode(newValue)
            .then(value => {
              this.fileSrc = value
            })
            .catch(() => {
              this.fileSrc = null
            })
        } else {
          this.fileSrc = null
        }
      }
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
    removeImg() {
      this.file = null
      this.fileSrc = null
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

<style lang="scss">
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

.upload-img-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  margin: 0 auto;

  .upload-img {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 150px;
    height: 150px;
    border-radius: 100%;
    border: 2px solid rgba(0, 0, 0, 0.125);
    margin-bottom: 0.5em;

    &:hover {
      img {
        opacity: 0.5;
      }
      .upload-remove {
        display: block;
        opacity: 1;
      }
    }
  }
  img {
    width: 150px;
    height: 150px;
    border-radius: 100%;
    object-fit: cover;
  }

  .upload-placeholder {
    width: 90px;
    height: 90px;
    object-fit: contain;
    border-radius: 0;
  }

  .upload-remove {
    display: none;
    position: absolute;
    margin: auto auto;
    font-size: 0.75em;
    display: none;
  }
}
</style>
