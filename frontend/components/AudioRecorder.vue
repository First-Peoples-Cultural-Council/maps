<template>
  <div>
    <div @click="record">
      <img src="@/assets/images/record_audio_box.svg" alt="Record" />
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      recording: false,
      mediaRecorder: null,
      audioChunks: [],
      audioBlob: null,
      audioUrl: null,
      audio: null
    }
  },
  mounted() {
    console.log(navigator.mediaDevices.getUserMedia)
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
            this.audioBlob = new Blob(this.audioChunks)
            this.audioUrl = URL.createObjectURL(this.audioBlob)
            this.audio = new Audio(this.audioUrl)
            this.audio.play()
          })
        })
      } else {
        this.recording = false
        this.mediaRecorder.stop()
      }
    }
  }
}
</script>

<style></style>
