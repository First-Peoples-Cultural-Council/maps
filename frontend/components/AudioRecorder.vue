<template>
  <div>
    <b-row no-gutters>
      <b-col xl="10" class="pr-1">
        <div class="audioRecordedArea">
          <p class="p-0 m-0">
            <span v-if="!recording">
              Click on
              <img
                src="@/assets/images/record_icon_grey.svg"
                alt="Mic"
                class="d-inline-block valign-middle"
              />
              to record the pronounciation
            </span>
            <span
              v-else
              class="d-flex align-items-center justify-content-center"
            >
              Recording... <b-spinner type="grow" label="Spinning"></b-spinner>
            </span>
            <span v-if="audioUrl">
              <Audio
                class="mt-2"
                :audio-object="audio"
                :audio-u-r-l="audioUrl"
              ></Audio>
            </span>
          </p>
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
import Audio from '@/components/Audio.vue'

export default {
  components: {
    Audio
  },
  props: {
    mode: {
      default: 'single',
      type: String
    }
  },
  data() {
    return {
      recording: false,
      mediaRecorder: null,
      audioChunksCollection: [],
      audioChunks: [],
      audioBlob: null,
      audioUrl: null,
      audio: null
    }
  },
  methods: {
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
            this.audioBlob = new Blob(this.audioChunks)
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
