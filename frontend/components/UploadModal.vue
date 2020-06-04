<template>
  <div>
    <b-modal
      id="uploadModal"
      ref="multiUploadModal"
      v-model="modalShow"
      :modal-class="{
        'upload-modal-padded': view === 'FileUploader'
      }"
      hide-header
      hide-footer
    >
      <b-row no-gutters>
        <b-col lg="12" xl="12">
          <transition name="component-fade" mode="out-in">
            <b-button
              v-if="view !== 'UploadOptions'"
              class="mb-2"
              variant="dark"
              size="sm"
              @click="view = 'UploadOptions'"
              >Back To Options</b-button
            >
          </transition>

          <transition name="component-fade" mode="out-in">
            <component
              :is="view"
              :id="id"
              :type="type"
              :placeholder="placeholder"
              :mode="mode"
            ></component>
          </transition>
        </b-col>
      </b-row>
    </b-modal>
  </div>
</template>
<script>
import FileUploader from '@/components/FileUploader.vue'
import AudioRecorder from '@/components/AudioRecorder.vue'
import UploadOptions from '@/components/UploadOptions.vue'
import NoteUploader from '@/components/NoteUploader.vue'
import YoutubeUploader from '@/components/YoutubeUpload.vue'
import VimeoUploader from '@/components/VimeoUpload.vue'

export default {
  components: {
    FileUploader,
    UploadOptions,
    AudioRecorder,
    NoteUploader,
    YoutubeUploader,
    VimeoUploader
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
      modalShow: false,
      view: 'UploadOptions',
      placeholder: 'Drop or select photo',
      mode: null
    }
  },
  mounted() {
    this.$root.$on('openUploadModal', () => {
      this.modalShow = true
    })

    this.$root.$on('closeUploadModal', () => {
      this.modalShow = false
    })

    this.$root.$on('uploadModeChosen', ({ comp, mode }) => {
      this.view = comp
      this.mode = mode
    })

    this.$root.$on('fileUploaded', data => {
      this.modalShow = false
      this.$root.$emit('notification', {
        title: 'Success',
        message: 'Media Successfully uploaded',
        time: 2000,
        variant: 'success'
      })

      if (this.$route.name === 'index-art-art') {
        this.$root.$emit('fileUploadSuccess')
      } else if (this.$route.name === 'index-place-names-placename') {
        this.$root.$emit('fileUploadedPlaces', data)
      } else if (this.$route.name === 'index-content-fn') {
        this.$root.$emit('fileUploadedCommunity', data)
      }
    })

    this.$root.$on('fileUploadFailed', type => {
      this.$root.$emit('notification', {
        title: 'Failed',
        message: `${type} Upload Failed, please try again`,
        time: 2000,
        variant: 'danger'
      })
      if (this.$route.name === 'index-art-art') {
        this.$root.$emit('fileUploadSuccess')
      }
    })

    this.$root.$on('bv::modal::hide', (bvEvent, modalId) => {
      if (modalId === 'uploadModal') {
        this.view = 'UploadOptions'
      }
    })
  }
}
</script>
<style>
.component-fade-enter-active,
.component-fade-leave-active {
  transition: opacity 0.3s ease;
}
.component-fade-enter, .component-fade-leave-to
/* .component-fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
