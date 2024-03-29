<template>
  <b-button
    block
    variant="danger"
    class="flag-button"
    @click="modalShow = true"
  >
    <MdFlagIcon
      class="d-inline-block mr-1"
      w="15"
      h="15"
      style="fill: white;"
    ></MdFlagIcon
    >{{ title || 'Flag' }}
    <b-modal
      v-model="modalShow"
      hide-header
      centered
      :ok-disabled="!isValid"
      ok-title="Submit"
      @ok="handleSubmit"
    >
      <b-alert
        v-if="errorMessage"
        show
        variant="danger"
        class="font-08 padding-05"
        >{{ errorMessage }}</b-alert
      >
      <h4 class="font-08">Select a reason</h4>
      <b-form-select
        v-model="selected"
        :options="options"
        size="sm"
      ></b-form-select>
      <div>
        <h4 class="font-08 mt-3">State a reason</h4>
        <b-form-textarea
          id="textarea"
          v-model="text"
          placeholder="Enter reason for flagging this content..."
          rows="3"
          max-rows="6"
        ></b-form-textarea>
      </div> </b-modal
  ></b-button>
</template>
<script>
import MdFlagIcon from 'vue-ionicons/dist/md-flag.vue'
export default {
  components: {
    MdFlagIcon
  },
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
  computed: {
    isValid() {
      return this.selected && this.text
    }
  },
  methods: {
    async handleSubmit(e) {
      e.preventDefault()
      if (!this.selected && !this.text) {
        this.errorMessage = 'Please select an option, and state your reason.'
        return false
      }

      const reason = `${
        this.options.find(o => o.value === this.selected).text
      }- ${this.text}`

      const result = await this.submitFlag(this.id, reason)
      this.modalShow = false
      if (result.message === 'Flagged!') {
        this.$root.$emit('notification', {
          title: 'Success',
          message: 'Flagged sucessfully',
          time: 1500,
          variant: 'success'
        })
      }
    },
    async submitFlag(id, reason) {
      if (!id) {
        return false
      }

      const data = {
        id,
        type: this.type,
        reason
      }

      if (this.media && this.media.placename) {
        data.belongs = 'placename'
        data.belongid = this.media.placename
      } else if (this.media && this.media.community) {
        data.belongs = 'community'
        data.belongid = this.media.community
      }

      const result = await this.$store.dispatch('user/flagContent', data)
      return result
    }
  }
}
</script>
<style>
.flag-button {
  background-color: #c46257;
  padding: 0.2em 1em;
  font-size: 0.8em;
}
</style>
