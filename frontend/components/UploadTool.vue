<template>
  <div>
    <UploadButton @click.native="toggleUploadModal"></UploadButton>
    <UploadModal v-if="showModal" :id="id" :type="type"></UploadModal>
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
  data() {
    return {
      showModal: false
    }
  },
  methods: {
    toggleUploadModal() {
      this.showModal = !this.showModal
      this.$root.$emit('openUploadModal')
    },
    openModal(e) {}
  }
}
</script>
<style></style>
