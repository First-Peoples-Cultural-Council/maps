<template>
  <div>
    <label for="text-title" class="font-08 color-dark-gray font-weight-bold"
      >Title</label
    >
    <b-form-input
      id="text-title"
      v-model="title"
      placeholder="Enter a title for this youtube video"
      aria-describedby="text-title-feedback"
      size="sm"
      class=""
      :state="titlestate"
    ></b-form-input>

    <b-form-invalid-feedback id="text-title-feedback">
      Title is required
    </b-form-invalid-feedback>

    <label for="text-area" class="font-08 color-dark-gray font-weight-bold mt-2"
      >Text/Note</label
    >
    <b-form-textarea
      id="text-area"
      v-model="text"
      size="sm"
      placeholder="Enter a description for this video"
      aria-describedby="text-area-feedback"
    ></b-form-textarea>

    <label
      for="youtube-link"
      class="font-08 color-dark-gray font-weight-bold mt-2"
      >Youtube Link</label
    >

    <b-form-input
      id="youtube-link"
      v-model="youtubeLink"
      placeholder="Enter the link"
      aria-describedby="youtube-feedback"
      size="sm"
      class=""
      :state="youtubestate"
      @input="checkValidYtLink"
    ></b-form-input>

    <b-form-invalid-feedback id="youtube-feedback">
      Youtube link is required
    </b-form-invalid-feedback>

    <CommunityOnly
      v-if="!isArtwork"
      class="mt-3"
      :commonly.sync="commonly"
    ></CommunityOnly>

    <b-row class="field-row my-4">
      <b-form-checkbox
        id="is-agree"
        v-model="isAgree"
        class="d-inline-block ml-3"
        name="is-agree"
      >
        By uploading this I acknowledge that I own the copyright to this media.
        FPCC does not take responsibility for the content uploaded to the First
        Peoples’ Map of B.C.
      </b-form-checkbox>
    </b-row>

    <b-button
      size="sm"
      variant="dark"
      class="mt-2"
      :disabled="!isAgree"
      @click="handleYoutubeUpload"
      >Upload</b-button
    >
    <b-button
      size="sm"
      variant="dark"
      class="mt-2"
      @click="$root.$emit('closeUploadModal')"
      >Cancel</b-button
    >
  </div>
</template>
<script>
import { getFormData, isValidYoutubeLink } from '@/plugins/utils.js'
import CommunityOnly from '@/components/CommunityOnly.vue'
export default {
  components: {
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
    }
  },
  data() {
    return {
      title: '',
      text: '',
      titlestate: null,
      commonly: null,
      youtubeLink: null,
      youtubestate: null,
      isAgree: false
    }
  },
  computed: {
    isArtwork() {
      return this.$route.query.type || this.$route.query.upload_artwork
    }
  },
  methods: {
    isValidYoutubeLink,
    resetState() {
      this.title = ''
      this.text = ''
      this.titlestate = null
      this.youtubeLink = null
    },
    async handleYoutubeUpload(e) {
      if (!this.title) {
        this.titlestate = false
      } else {
        this.titlestate = null
      }

      if (!this.youtubeLink) {
        this.youtubestate = false
      } else {
        this.youtubestate = true
      }

      if (!this.title || !this.youtubeLink) {
        return false
      }

      const formData = getFormData(this.getMediaData(), true)

      if (this.$route.query.mode === 'placename' || this.$route.query.type) {
        this.$store.commit('file/setMediaFiles', this.getMediaData())
      } else {
        try {
          const result = await this.uploadNote(formData)

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
          this.$root.$emit('fileUploadFailed', 'Note/Text')
        }
      }

      this.resetState()
    },

    checkValidYtLink() {
      this.youtubestate = !!this.isValidYoutubeLink(this.youtubeLink)
    },

    async uploadNote(formData) {
      const dataObj = {
        formData,
        callProgressModal: this.callProgressModal
      }

      const result = await this.$store.dispatch('file/uploadMedia', dataObj)
      return result
    },

    getMediaData() {
      return {
        name: this.title,
        description: this.text,
        file_type: 'youtube',
        type: this.type,
        id: this.id,
        community_only: this.commonly === 'accepted',
        url: this.youtubeLink,
        is_artwork: !!this.$route.query.upload_artwork
      }
    },

    callProgressModal(value) {
      this.$root.$emit('initiateLoadingModal', value)
    }
  }
}
</script>
<style></style>
