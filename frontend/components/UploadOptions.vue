<template>
  <div>
    <b-list-group>
      <b-list-group-item
        class="flex-column align-items-start cursor-pointer"
        @click="
          chooseUploadType($event, { comp: 'FileUploader', mode: 'photo' })
        "
      >
        <div class="d-flex w-100 justify-content-between">
          <h5 class="mb-1">Upload A Photo</h5>
        </div>

        <small class="text-muted"
          >Add a significant photo pertaining to this area</small
        >
      </b-list-group-item>

      <b-list-group-item
        class="flex-column align-items-start cursor-pointer"
        @click="
          chooseUploadType($event, {
            comp: 'AudioRecorder',
            mode: 'externalAudio'
          })
        "
      >
        <div class="d-flex w-100 justify-content-between">
          <h5 class="mb-1">Record/Upload Audio</h5>
        </div>

        <small class="text-muted">Record or upload a recording</small>
      </b-list-group-item>

      <b-list-group-item
        class="flex-column align-items-start cursor-pointer"
        @click="
          chooseUploadType($event, {
            comp: 'NoteUploader',
            mode: 'note'
          })
        "
      >
        <div class="d-flex w-100 justify-content-between">
          <h5 class="mb-1">Add a text or a note</h5>
        </div>

        <small class="text-muted"
          >Add a text or a note about the selected place</small
        >
      </b-list-group-item>

      <b-list-group-item
        class="flex-column align-items-start cursor-pointer"
        @click="
          chooseUploadType($event, {
            comp: 'YoutubeUploader',
            mode: 'standard'
          })
        "
      >
        <div class="d-flex w-100 justify-content-between">
          <h5 class="mb-1">Embed A Youtube Video</h5>
        </div>

        <small class="text-muted">Embed A Youtube Video</small>
      </b-list-group-item>
    </b-list-group>
  </div>
</template>
<script>
export default {
  methods: {
    chooseUploadType(e, module) {
      this.$root.$emit('uploadModeChosen', module)
    }
  }
}
</script>
<style></style>
