<template>
  <div>
    <b-row no-gutters>
      <b-col lg="10" xl="10" class="pr-1">
        <b-form-file
          ref="fileUpload"
          v-model="file"
          accept="audio/mp3,audio/*;capture=microphone"
          class="d-none"
          :state="Boolean(file)"
          placeholder="Choose a file or drop it here..."
          drop-placeholder="Drop file here..."
        ></b-form-file>
        <div
          class="audioRecordedArea cursor-pointer"
          @click.prevent="triggerBrowse"
        >
          <div class="p-0 m-0">
            <span v-if="!recording">
              Click on
              <img
                src="@/assets/images/record_icon_grey.svg"
                alt="Mic"
                class="d-inline-block valign-middle"
              />
              to record the pronounciation or
              <span style="color: #C46257;">click here</span> to choose an audio
              file
              <span v-if="audioErrorMessage" class="d-block">
                <b-alert
                  style="line-height: 1em;"
                  class="m-0 mt-3"
                  show
                  variant="danger"
                  >{{ audioErrorMessage }}</b-alert
                >
              </span>
            </span>
            <span
              v-else
              class="d-flex align-items-center justify-content-center"
            >
              Recording...
              <b-spinner type="grow" label="Spinning"></b-spinner> click
              <img
                src="@/assets/images/record_icon_grey.svg"
                alt="Mic"
                class="d-inline-block valign-middle ml-1 mr-1"
              />
              again to stop recording
            </span>
            <div v-if="audioUrl" class="d-flex align-items-center">
              <AudioComponent
                class="mt-2 mr-2"
                :audio-object="audio"
                :audio-url="audioUrl"
              ></AudioComponent>
              <b-button
                class="mt-2"
                variant="dark"
                @click.prevent.stop="resetAudio"
                >X</b-button
              >
            </div>
            <div v-if="file">
              <b-button
                block
                variant="light"
                class="file-button text-align-left mt-1 mb-1"
                @click.stop=""
              >
                {{ file.name }}
                <b-badge
                  pill
                  variant="dark"
                  class="float-right"
                  @click="resetFile($event, file)"
                  >X</b-badge
                >
              </b-button>
            </div>
          </div>
        </div>
      </b-col>
      <b-col lg="2" xl="2">
        <div
          v-if="recordingSupport"
          class="text-center cursor-pointer"
          @click="record"
        >
          <img
            class="d-inline-block"
            :class="{ 'recording-image': recording }"
            src="@/assets/images/record_audio_box.svg"
            alt="Record"
          />
        </div>
      </b-col>
    </b-row>
    <b-row v-if="mode === 'externalAudio' && (audio || file)">
      <b-col xl="12">
        <label class="font-08" for="file-name">Title</label>

        <ToolTip
          content="Give this audio a title so that users know what it is."
        ></ToolTip>
        <b-form-input
          id="file-name"
          v-model="title"
          class="font-08"
          :state="titleState"
          aria-describedby="title-help title-feedback"
          placeholder="Enter Title (required)"
          required
        ></b-form-input>
        <b-form-invalid-feedback id="title-feedback">
          Title is required
        </b-form-invalid-feedback>

        <label class="mt-3 font-08" for="textarea">Description</label>

        <ToolTip
          content="If the audio file needs more information, for example a description of what it includes or copyright information, add it here."
        ></ToolTip>
        <b-form-textarea
          id="textarea"
          v-model="description"
          placeholder="Enter description"
          rows="3"
          max-rows="6"
          class="mt-2 mb-2 font-08"
        ></b-form-textarea>

        <CommunityOnly
          v-if="!isArtwork"
          :commonly.sync="commonly"
        ></CommunityOnly>

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
          @click="externalAudioUpload"
          >Upload</b-button
        >
        <b-button
          size="sm"
          variant="dark"
          class=""
          @click="$root.$emit('closeUploadModal')"
          >Cancel</b-button
        >
      </b-col>
    </b-row>
  </div>
</template>

<script>
import AudioComponent from '@/components/Audio.vue'
import ToolTip from '@/components/Tooltip.vue'
import { getFormData } from '@/plugins/utils.js'
import CommunityOnly from '@/components/CommunityOnly.vue'

export default {
  components: {
    AudioComponent,
    ToolTip,
    CommunityOnly
  },
  props: {
    mode: {
      default: 'single',
      type: String
    },
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
      title: null,
      titleState: null,
      description: null,
      file: null,
      recording: false,
      mediaRecorder: null,
      audioChunksCollection: [],
      audioChunks: [],
      audioUrl: null,
      audio: null,
      audioErrorMessage: null,
      recordingSupport: true,
      commonly: null,
      isAgree: false
    }
  },
  computed: {
    audioBlob() {
      return this.$store.state.contribute.audioBlob
    },
    audioFile() {
      return this.$store.state.contribute.audioFile
    },
    isArtwork() {
      return this.$route.query.type || this.$route.query.upload_artwork
    }
  },
  watch: {
    file(newFile, oldFile) {
      this.$store.commit('contribute/setAudioFile', newFile)
    },
    audio(newAudio, oldAudio) {}
  },
  mounted() {
    if (!window.MediaRecorder) {
      this.recordingSupport = false
      this.audioErrorMessage = `Audio recording not supported. Reasons could be due to: insecure connection, declined permission or browser does not support this technology. Please upload a recording instead.`
    }
  },
  methods: {
    async externalAudioUpload(e) {
      if (!this.title) {
        this.titleState = false
        return
      }

      const file =
        this.file ||
        (this.audioChunks && this.blobToFile(new Blob(this.audioChunks)))
      const file_type = this.file
        ? this.file.type
        : this.mediaRecorder.mimeType.split(';')[0]

      const formData = getFormData(this.getMediaData(file, file_type))
      const dataObj = {
        formData,
        callProgressModal: this.callProgressModal
      }

      if (this.$route.query.mode === 'placename' || this.$route.query.type) {
        this.$store.commit(
          'file/setMediaFiles',
          this.getMediaData(file, file_type)
        )
        this.$root.$emit('closeUploadModal')
      } else {
        try {
          const result = await this.$store.dispatch('file/uploadMedia', dataObj)
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
          this.$root.$emit('fileUploadFailed', 'Audio')
        }
      }

      this.clearFiles()
      this.resetFile()
    },
    getMediaData(file, file_type) {
      return {
        name: this.title,
        file_type,
        description: this.description,
        media_file: file,
        type: this.type,
        id: this.id,
        community_only: this.commonly === 'accepted',
        is_artwork: !!this.$route.query.upload_artwork
      }
    },
    blobToFile(blob) {
      blob.lastModifiedDate = new Date()
      blob.name = this.title
      return blob
    },
    triggerBrowse(e) {
      if (!this.recording) {
        this.$refs.fileUpload.$el.children[0].click()
      }
    },
    clearFiles() {
      this.$refs.fileUpload.reset()
    },
    resetFile(e) {
      this.clearFiles()
      this.file = null
      this.$store.commit('contribute/setAudioFile', null)
    },
    resetAudio() {
      this.recording = false
      this.mediaRecorder = null
      this.audioChunksCollection = []
      this.audioChunks = []
      this.audioUrl = null
      this.audio = null
      this.$store.commit('contribute/setAudioBlob', null)
    },
    record(e) {
      if (!this.recording) {
        try {
          navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
            try {
              this.mediaRecorder = new MediaRecorder(stream)

              this.mediaRecorder.start()
              this.recording = true
              this.mediaRecorder.addEventListener('dataavailable', event => {
                this.audioChunks.push(event.data)
              })

              this.mediaRecorder.addEventListener('stop', () => {
                if (this.mode !== 'single') {
                  this.audioChunksCollection.push(this.audioChunks)
                }
                this.$store.commit(
                  'contribute/setAudioBlob',
                  new Blob(this.audioChunks)
                )
                this.audioUrl = URL.createObjectURL(this.audioBlob)
                this.audio = new Audio(this.audioUrl)
              })
            } catch (e) {
              console.log('MediaRecorder does not work')
              this.audioErrorMessage = `Audio recording not supported. Reasons could be due to: insecure connection, declined permission or browser does not support this technology. Please upload a recording instead.`
            }
          })
        } catch (e) {
          this.audioErrorMessage = `Audio recording not supported. Reasons could be due to: insecure connection, declined permission or browser does not support this technology. Please upload a recording instead.`
        }
      } else {
        this.recording = false
        this.mediaRecorder.stop()
        this.audioChunks = []
      }
    },
    callProgressModal(value) {
      this.$root.$emit('initiateLoadingModal', value)
    }
  }
}
</script>

<style>
.audioRecordedArea {
  background-color: #f4eee9;
  padding: 0;
  margin: 0;
  padding: 1.5em 0.5em;
  font-size: 0.8em;
  line-height: 0.8em;
  color: #6f6f70;
  font-weight: bold;
  border-radius: 0.5em;
  text-align: center;
}

.recording-image {
  animation: expand 2s infinite;
}

@keyframes expand {
  from {
    transform: scale(0.1);
  }

  to {
    transform: scale(1);
  }
}
</style>
