<template>
  <div>
    <div class="d-inline-block cursor-pointer" @click="modalShow = true">
      Flag
    </div>
    <b-modal v-model="modalShow" hide-header @ok="handleSubmit">
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
      modalShow: false,
      selected: null,
      options: [
        { value: null, text: 'Select your reason here' },
        { value: 'a', text: 'Inappropriate Content' },
        { value: 'b', text: 'Misinformation' },
        { value: 'c', text: 'Other' }
      ],
      text: '',
      flagged: false
    }
  },
  methods: {
    async handleSubmit(e) {
      console.log('Handle Submit')
      e.preventDefault()
      const reason =
        this.selected === 'c'
          ? this.text
          : this.options.find(o => o.value === this.selected).text
      console.log('Reason', reason)
      const result = await this.submitFlag(this.id, reason)
      if (result === '"Flagged!"') {
      }
      // this.modalShow = false
    },
    async submitFlag(id, reason) {
      if (!id) {
        return false
      }
      const result = await this.$axios.$patch(
        `${getApiUrl(`media/${id}/flag/`)}`,
        {
          status_reason: reason
        },
        {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        }
      )
      return result
    }
  }
}
</script>
<style></style>
