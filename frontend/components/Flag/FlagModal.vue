<template>
  <div>
    <div class="d-inline-block cursor-pointer" @click="modalShow = true">
      <b-badge variant="danger">
        <img
          src="@/assets/images/flag_icon.svg"
          alt="Flag"
          class="d-inline-block mr-1"
          style="height: 15px; width: 15px;"
        />{{ title || 'Flag' }}</b-badge
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
import { getApiUrl, getCookie } from '@/plugins/utils.js'
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
      const result = await this.submitFlag(this.id, reason)
      this.modalShow = false
      if (result.message === 'Flagged!') {
        this.$root.$emit(`${this.type}_flagged`, result)
        this.$root.$emit('notification', {
          content: 'Flag Succeeded. Thanks!',
          time: 3000
        })
      }
    },
    async submitFlag(id, reason) {
      if (!id) {
        return false
      }
      const result = await this.$axios.$patch(
        `${getApiUrl(`${this.type}/${id}/flag/`)}`,
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
