<template>
  <div>
    <b-row no-gutters>
      <b-col xl="10" class="pr-1">
        <b-form-file
          ref="fileUpload"
          v-model="file"
          accept="image/vorbis, image/mpeg"
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
              <span style="color: #C46257;">click here</span> to choose a file
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
      <b-col xl="2">
        <div class="text-center cursor-pointer" @click="record">
          <img
            class="d-inline-block"
            src="@/assets/images/record_audio_box.svg"
            alt="Record"
          />
        </div>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import AudioComponent from '@/components/Audio.vue'

export default {
  components: {
    AudioComponent
  },
  props: {
    mode: {
      default: 'single',
      type: String
    }
  },
  data() {
    return {
      file: null,
      recording: false,
      mediaRecorder: null,
      audioChunksCollection: [],
      audioChunks: [],
      audioUrl: null,
      audio: null
    }
  },
  computed: {
    audioBlob() {
      return this.$store.state.contribute.audioBlob
    },
    audioFile() {
      return this.$store.state.contribute.audioFile
    }
  },
  watch: {
    file(newFile, oldFile) {
      this.$store.commit('contribute/setAudioFile', newFile)
    },
    audio(newAudio, oldAudio) {}
  },
  methods: {
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
        this.recording = true
        navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
          this.mediaRecorder = new MediaRecorder(stream)
          this.mediaRecorder.start()

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
        })
      } else {
        this.recording = false
        this.mediaRecorder.stop()
        this.audioChunks = []
      }
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
</style>
