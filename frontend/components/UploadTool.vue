<template>
  <div>
    <UploadButton @click.native="openModal"></UploadButton>
    <UploadModal :id="id" :type="type"></UploadModal>
  </div>
</template>
<script>
import UploadModal from '@/components/UploadModal.vue'
import UploadButton from '@/components/UploadButton.vue'
export default {
  components: {
    UploadModal,
    UploadButton
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
  methods: {
    openModal(e) {
      this.$root.$emit('openUploadModal')
    }
  }
}
</script>
<style></style>
