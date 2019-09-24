<template>
  <div>
    <b-button variant="dark" size="sm" @click="showModal = true"
      >Delete</b-button
    >
    <b-modal v-model="showModal" hide-header @ok="handleDelete">
      Are you sure you want to delete this media?</b-modal
    >
  </div>
</template>
<script>
import { getApiUrl, getCookie } from '@/plugins/utils.js'
export default {
  props: {
    id: {
      default: null,
      type: Number
    }
  },
  data() {
    return {
      showModal: false
    }
  },
  methods: {
    async handleDelete(e) {
      e.preventDefault()
      try {
        const result = await this.$axios.delete(
          getApiUrl(`media/${this.id}/`),
          {},
          {
            headers: {
              'X-CSRFToken': getCookie('csrftoken')
            }
          }
        )
        console.log('Result', result)
        this.showModal = false
      } catch (e) {}
    }
  }
}
</script>
<style></style>
