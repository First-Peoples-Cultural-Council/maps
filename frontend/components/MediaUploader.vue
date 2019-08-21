<template>
  <b-row no-gutters>
    <b-col xl="10">
      <b-form-file
        ref="fileUpload"
        v-model="file"
        class="d-none"
        :state="Boolean(file)"
        placeholder="Choose a file or drop it here..."
        drop-placeholder="Drop file here..."
      ></b-form-file>
      <div class="mediaUploadArea cursor-pointer" @click="triggerBrowse">
        <p class="m-0 p-0">
          <img
            class="d-inline-block"
            src="@/assets/images/clip_icon.svg"
            alt="Clip"
          />
          <span style="color: #C46257;">Choose files</span>, drop files here or
          record an audio
        </p>
        <div v-for="(fileToBeUploaded, index) in files" :key="index">
          <div>
            {{ fileToBeUploaded.name }}
          </div>
        </div>
        <div
          v-for="(audioToBeUploaded, index) in audios"
          class="mt-2"
          :key="'audio' + index"
        >
          <div>
            <AudioComponent
              class="mb-2"
              :audio-url="audioToBeUploaded.audioUrl"
              :audio-object="audioToBeUploaded.audio"
            ></AudioComponent>
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
      files: [],
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
  watch: {
    file(newFile, oldFile) {
      if (oldFile && oldFile.name === newFile.name) {
        return
      }
      this.files.push(newFile)
      console.log('This files', this.files)
    }
  },
  methods: {
    triggerBrowse(e) {
      console.log(this.$refs.fileUpload.$el.children[0].click())
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
</style>
