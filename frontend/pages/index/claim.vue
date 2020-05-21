<template>
  <div class="clain-email">
    <div>
      <Logo />
    </div>
    <div v-if="isLoggedIn && claimSuccess" class="claim-info-container">
      <div class="alert alert-success">
        {{ message }}
      </div>
    </div>
    <div v-else class="claim-info-container no-user">
      <div class="alert alert-danger">
        {{ message }}
      </div>
    </div>
  </div>
</template>

<script>
import * as Cookies from 'js-cookie'
import { getApiUrl, getCookie } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    Logo
  },
  data() {
    return {
      claimSuccess: false,
      message: 'Please wait while we are checking your User Invitation',
      invalidMessage:
        'Sorry but the URL link you provided to claim your profile is invalid',
      redirectMessage: 'Please wait while we redirect you to the singup page',
      createProfileMessage:
        'Please wait while we connect your artist profile to your account',
      claimSuccessMessage: 'Thank you for claiming your profile(s)'
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    userid() {
      return this.$store.state.user.user.id
    },
    email() {
      return this.$store.state.user.user && this.$store.state.user.user.email
    },
    user() {
      return this.$store.state.user.user
    }
  },
  mounted() {
    const inviteMode = Cookies.get('inviteMode')

    const email = this.$route.query.email
    const key = this.$route.query.key

    // NOTE: Invite mode means you have a valid URL and you were asked to sign up
    if (inviteMode && this.isLoggedIn) {
      // The `if` block will be executed if the user is undergoing a claiming
      // artist profile process. The condition is set in order to avoid
      // the claim function to be triggered outside the invite flow
      this.claimSuccess = true

      this.message = this.createProfileMessage

      this.claimArtistProfile(email, key, this.userid)
    } else if (!this.isLoggedIn) {
      // If you are neither in invite mode, nor logged in, you will trigger the invite
      // process and you will be asked to register. The Inviet Mode will be activated
      if (email && key) {
        this.processInvite(email, key)
      } else {
        this.message = this.invalidMessage
      }
    } else {
      // If you access then claim page while you are logged in, but you're not actively
      // claiming a profile, you will be notified that your claim URL is invalid
      this.message = this.invalidMessage
    }
  },
  methods: {
    redirectLogin() {
      window.location.href = `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    },
    async validateUrl(email, key, headers = {}) {
      console.log(headers)

      // Checking the validity will confirm if the invite URL was sent
      // out by our system, and this would allow visual feedback to users
      const validateUrl = `${getApiUrl('key/validate/')}`
      const isValid = await this.$axios.post(
        validateUrl,
        {
          email,
          key
        },
        {
          headers
        }
      )

      return isValid
    },
    async processInvite(email, key) {
      const result = await this.validateUrl(email, key)
      const isValid = result.data.valid

      if (isValid) {
        // Set cookies that will be reused later on after logging in
        Cookies.set('inviteEmail', email)
        Cookies.set('inviteKey', key)
        Cookies.set('inviteMode', true)

        this.message = this.redirectMessage

        this.redirectLogin()
      } else {
        this.message = this.invalidMessage
      }
    },
    async claimArtistProfile(email, key, userId) {
      const headers = {
        'X-CSRFToken': getCookie('csrftoken')
      }
      const claimConfirmUrl = `${getApiUrl('profile/claim/confirm/')}`
      const result = await await this.$axios.post(
        claimConfirmUrl,
        {
          email,
          key,
          user_id: userId
        },
        {
          headers
        }
      )
      const isClaimSuccessful = result.data.success

      if (isClaimSuccessful) {
        this.message = this.claimSuccessMessage
      } else {
        this.message = this.invalidMessage
      }

      // Clear Cookies whether or not the request succeeded or failed
      // to make sure that the user has to repeat the process
      // Cookies.remove('inviteEmail')
      // Cookies.remove('inviteKey')
      // Cookies.remove('inviteMode')
    }
  }
}
</script>

<style>
.clain-email {
  height: 100%;
}
.claim-info-container {
  padding: 16px;
  font-family: sans-serif;
  height: 100%;
}
.no-user {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
