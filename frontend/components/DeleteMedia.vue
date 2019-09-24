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
        const result = await this.$store.dispatch('user/deleteMedia', {
          id: this.id
        })

        if (result.request && result.request.status === 204) {
          this.showModal = false
          this.$root.$emit('mediaDeleted', this.id)
          this.$root.$emit('notification', {
            content: 'Media Deleted Successfully',
            time: 2000
          })
        } else {
          throw result
        }
      } catch (e) {
        this.$root.$emit('notification', {
          content: 'Media Deleted Successfully',
          time: 2000
        })
      }
    }
  }
}
</script>
<style></style>
