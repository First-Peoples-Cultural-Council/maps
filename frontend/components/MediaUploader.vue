<template>
  <b-row no-gutters>
    <b-col xl="10">
      w
      <div class="mediaUploadArea cursor-pointer" @click="triggerBrowse">
        <p class="m-0 p-0">
          <span v-if="!recording">
            <img
              class="d-inline-block"
              src="@/assets/images/clip_icon.svg"
              alt="Clip"
            />

            <span style="color: #C46257;">Choose files</span>, drop files here
            or record an audio
          </span>
          <span v-else class="d-flex align-items-center justify-content-center">
            Recording... <b-spinner type="grow" label="Spinning"></b-spinner>
          </span>
        </p>
        <div v-for="(fileToBeUploaded, index) in files" :key="index">
          <div></div>
          <b-button
            block
            variant="light"
            class="file-button text-align-left mt-1 mb-1"
            @click.stop=""
          >
            {{ fileToBeUploaded.name }}
            <b-badge
              pill
              variant="dark"
              class="float-right"
              @click="removeFile($event, fileToBeUploaded)"
              >X</b-badge
            >
          </b-button>
        </div>
        <div
          v-for="(audioToBeUploaded, index) in audios"
          :key="'audio' + index"
          class="mt-2"
        >
          <div class="d-flex">
            <AudioComponent
              class="mt-1 mb-1 mr-2"
              :audio-url="audioToBeUploaded.audioUrl"
              :audio-object="audioToBeUploaded.audio"
            ></AudioComponent>
            <b-button
              variant="dark"
              @click.prevent.stop="deleteAudio($event, audioToBeUploaded)"
              >X</b-button
            >
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
</template>

<script>
import AudioComponent from '@/components/Audio.vue'

export default {
  components: {
    AudioComponent
  },
  data() {
    return {
      file: null,
      audios: [],
      recording: false,
      mediaRecorder: null,
      audioChunksCollection: [],
      audioChunks: [],
      audioBlob: null,
      audioUrl: null,
      audio: null
    }
  },
  computed: {
    files() {
      return this.$store.state.contribute.files
    }
  },
  watch: {
    file(newFile, oldFile) {
      if (!newFile) {
        return
      }
      if (oldFile && oldFile.name === newFile.name) {
        return
      }
      this.$store.commit('contribute/addFile', newFile)
    }
  },
  methods: {
    deleteAudio(e, data) {
      this.audios = this.audios.filter(
        audio => audio.audioUrl !== data.audioUrl
      )
    },
    clearFiles() {
      this.$refs.fileUpload.reset()
    },
    removeFile(e, data) {
      this.$store.commit(
        'contribute/setFiles',
        this.files.filter(file => file.name !== data.name)
      )
      this.clearFiles()
    },
    triggerBrowse(e) {
      this.$refs.fileUpload.$el.children[0].click()
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
            this.audioBlob = new Blob(this.audioChunks)
            this.audioUrl = URL.createObjectURL(this.audioBlob)
            this.audio = new Audio(this.audioUrl)
            this.audios.push({
              audioBlob: this.audioBlob,
              audioUrl: this.audioUrl,
              audio: this.audio
            })
            console.log('Audios', this.audios)
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
.mediaUploadArea {
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

.file-button {
  font-size: 1em;
  padding: 0.2em 1em;
  text-align: left;
}
</style>
