<template>
  <div>
    <b-button
      v-if="!unsubscribe"
      block
      variant="dark"
      size="sm"
      class="notification-badge"
      @click="!unsubscribe ? toggleNotificationModal() : unsub()"
      ><span class="font-07">{{ !unsubscribe ? title : 'Unsubscribe' }}</span>
      <img
        class="notification-icon"
        src="@/assets/images/bell-icon.png"
        alt="Learn"
      />
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
.notification-badge {
  line-height: 0;
  display: inline-block;
  color: white;
  border-radius: 0.2em;
  padding: 3.5px 7.5px;
  width: auto;
  letter-spacing: 1px;
}
.notification-badge span {
  text-transform: uppercase;
  font-weight: Bold;
  font-size: 12px;
}
.notification-badge span,
.notification-badge img {
  display: inline-block;
  vertical-align: middle;
}
.notification-icon {
  width: 15px;
  height: 15px;
}
</style>
