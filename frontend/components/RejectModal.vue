<template>
  <div>
    <div class="cursor-pointer" @click="modalShow = true">
      <b-button block variant="danger" size="sm" @click="modalShow = true"
        >Reject</b-button
      >
    </div>
    <b-modal v-model="modalShow" hide-header @ok="handleSubmit">
      <b-alert
        v-if="errorMessage"
        show
        variant="danger"
        class="font-08 padding-05"
        >{{ errorMessage }}</b-alert
      >
      <h5 class="font-08">Select a reason</h5>
      <b-form-select
        v-model="selected"
        :options="options"
        size="sm"
      ></b-form-select>
      <div v-if="selected === 'c'">
        <h5 class="font-08 mt-3">State a reason</h5>
        <b-form-textarea
          id="textarea"
          v-model="text"
          placeholder="Enter something..."
          rows="3"
          max-rows="6"
        ></b-form-textarea>
      </div>
    </b-modal>
  </div>
</template>
<script>
export default {
  props: {
    id: {
      default: null,
      type: Number
    },
    type: {
      default: 'media',
      type: String
    },
    title: {
      default: null,
      type: String
    },
    media: {
      default: null,
      type: Object
    }
  },
  data() {
    return {
      modalShow: false,
      selected: null,
      options: [
        { value: null, text: 'Select your reason here' },
        { value: 'a', text: 'Inappropriate Content' },
        { value: 'b', text: 'Misinformation' },
        { value: 'c', text: 'Other' }
      ],
      text: '',
      flagged: false,
      errorMessage: null
    }
  },
  methods: {
    async handleSubmit(e) {
      e.preventDefault()
      if (!this.selected) {
        this.errorMessage = 'Please select an option'
        return false
      }
      e.preventDefault()
      const reason =
        this.selected === 'c'
          ? this.text
          : this.options.find(o => o.value === this.selected).text
      const result = await this.submitReject(this.id, reason)
      this.modalShow = false
      console.log('Result', result)
    },
    async submitReject(e, reason) {
      const data = {
        id: this.id,
        type: this.type,
        reason,
        media: this.media
      }
      const result = await this.$store.dispatch('user/rejectContent', data)
      return result
    }
  }
}
</script>
<style></style>
