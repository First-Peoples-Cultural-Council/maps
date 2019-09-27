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
    },
    media: {
      default: null,
      type: Object
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

      let type = null
      let type_id = null
      if (this.media.placename) {
        type = 'placename'
        type_id = this.media.placename
      } else if (this.media.community) {
        type = 'community'
        type_id = this.community
      }
      try {
        const result = await this.$store.dispatch('user/deleteMedia', {
          id: this.id,
          type,
          type_id
        })

        if (result.request && result.request.status === 204) {
          this.showModal = false
          this.$root.$emit('notification', {
            content: 'Media Deleted Successfully',
            time: 2000
          })
        } else {
          throw result
        }
      } catch (e) {
        this.$root.$emit('notification', {
          content: 'Fail deleting media',
          time: 2000,
          danger: true
        })
      }
    }
  }
}
</script>
<style></style>
