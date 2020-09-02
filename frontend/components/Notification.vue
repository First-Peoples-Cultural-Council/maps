<template>
  <div>
    <b-button
      v-if="!unsubscribe"
      block
      variant="dark"
      size="sm"
      class="notify-button"
      @click="toggleNotificationModal"
      >{{ title }}
    </b-button>
    <b-button
      v-else
      class="notify-button"
      block
      variant="dark"
      size="sm"
      @click="unsub"
      >Unsubscribe
    </b-button>
    <b-modal v-model="modalShow" hide-header @ok="handleNotification">
      <label for="notify-name" class="font-weight-bold font-08 color-dark-gray"
        >Enter a name for this notification</label
      >
      <b-form-input
        id="notify-name"
        v-model="name"
        type="text"
        placeholder="Enter a name"
        :state="notifyState"
        class="font-08"
        aria-describedby="input-notify-help"
      ></b-form-input>

      <b-form-invalid-feedback id="input-notify-help">
        Name is required
      </b-form-invalid-feedback>
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
      default: null,
      type: String
    },
    isServer: {
      default: false,
      type: Boolean
    },
    unsubscribe: {
      default: false,
      type: Boolean
    },
    subscription: {
      default: null,
      type: Object
    },
    title: {
      default: 'Subscribe',
      type: String
    }
  },
  data() {
    return {
      modalShow: false,
      name: null,
      notifyState: null
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    }
  },
  methods: {
    toggleNotificationModal() {
      if (this.isLoggedIn) {
        this.modalShow = true
      } else {
        this.$root.$emit(
          'toggleMessageBox',
          `You need to be logged in first, before proceeding.\n Press "OK" to proceed to Login/Register. `
        )
      }
    },
    async unsub() {
      const data = {
        id: this.subscription.id
      }
      try {
        const result = await this.$store.dispatch(
          'user/removeNotification',
          data
        )
        console.log('Unsub Result', result)
        if (result.request && result.request.status === 204) {
          this.$store.dispatch('user/getNotifications', {
            isServer: this.isServer
          })
        }
      } catch (e) {
        console.error(e)
      }
    },
    async handleNotification(e) {
      e.preventDefault()

      if (!this.id || !this.type) {
        this.modalShow = false
        return false
      }
      if (!this.name) {
        this.notifyState = false
        return false
      }

      const data = {
        name: this.name
      }
      if (this.type === 'community') {
        data.community = this.id
        data.language = null
      } else if (this.type === 'language') {
        data.language = this.id
        data.community = null
      }

      try {
        const result = await this.$store.dispatch('user/addNotification', data)
        if (result.request && result.request.status === 201) {
          this.$store.dispatch('user/getNotifications', {
            isServer: this.isServer
          })
          // console.log('It Got here')
          // this.$root.$emit('notificationadded', result.data)
        }
      } catch (e) {}
      this.modalShow = false
    }
  }
}
</script>
<style>
.notify-button {
  border-radius: 0.2em;
  font-size: 0.8em;
  padding: 0.2em 0.2em;
}
</style>
