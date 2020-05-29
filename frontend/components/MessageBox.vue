<template>
  <div>
    <b-modal v-model="show" ok-only hide-header @ok="redirectToLogin">
      <div class="message-box-container">
        <!-- <img class="message-box-icon" src="@/assets/images/user_icon.svg" /> -->
        <span class="message-box-content">
          {{ message }}
        </span>
      </div>
    </b-modal>
  </div>
</template>
<script>
export default {
  props: {},
  data() {
    return {
      show: false,
      message: ''
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    }
  },
  mounted() {
    this.$root.$on('toggleMessageBox', message => {
      this.toggleModal()
      this.message = message
    })
  },
  methods: {
    toggleModal() {
      this.show = !this.show
    },
    redirectToLogin() {
      if (!this.isLoggedIn) {
        window.location = `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
      }
    }
  }
}
</script>
<style>
.message-box-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
