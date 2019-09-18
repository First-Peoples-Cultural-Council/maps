<template>
  <div>
    <b-list-group>
      <b-list-group-item
        class="flex-column align-items-start"
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
        class="flex-column align-items-start"
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
