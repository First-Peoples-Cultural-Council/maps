<template>
  <div class="clain-email">
    <div>
      <Logo />
    </div>
    <div class="claim-header">
      <h2>
        <em>Claim Profile</em>
      </h2>
    </div>
    <div v-if="!claimSuccess">
      <div v-if="isLoggedIn && places.length !== 0" class="claim-body">
        <!-- 
        Show current user the logged in account's details 
        to allow him/her to verify if they are claiming the
        profiles in the correct account
      -->
        <div class="alert alert-warning">
          You are currenty logged in as <b>{{ fullName }} ({{ email }})</b>.
          Please make sure you are using the correct account before you claim
          the profile(s) below.
        </div>
        <p>Profiles</p>
        <ul>
          <li v-for="place in places" :key="`place-${place.id}`">
            <a :href="getFPCCLink(place)" target="_blank">{{ place.name }}</a>
            ({{ getPlaceKind(place) }})
          </li>
        </ul>
        <div
          class="claim-cta"
          :class="{ 'button--loading': isLoading }"
          @click="handleClaim"
        >
          <span class="button__text">Claim</span>
        </div>
      </div>
      <!-- If there are no places, note that there's nothing to claim -->
      <div v-else-if="places.length === 0" class="claim-body">
        <div class="alert alert-danger">
          {{ noProfilesMessage }}
        </div>
      </div>
      <!-- If there's no user, force a login -->
      <div v-else class="claim-body">
        <div class="alert alert-warning">
          {{ redirectMessage }}
        </div>
      </div>
    </div>
    <div v-else class="claim-body">
      <div class="alert alert-success">
        You have successfully claimed your profile(s)!
      </div>
      <router-link :to="`/profile/${userid}`">Visit my profile</router-link>
    </div>
  </div>
</template>

<script>
import * as Cookies from 'js-cookie'
import startCase from 'lodash/startCase'
import { getApiUrl, getCookie, encodeFPCC } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    Logo
  },
  data() {
    return {
      isLoading: false,
      places: [],
      claimSuccess: false,
      message: 'Please wait while we are checking your User Invitation.',
      invalidMessage:
        'Sorry but the URL link you provided to claim your profile is invalid.',
      redirectMessage: 'Please wait while we redirect you to the singup page.',
      noProfilesMessage:
        'There are no unclaimed profiles associated with this invite.'
    }
  },
  computed: {
    userid() {
      return this.$store.state.user.user.id
    },
    email() {
      return this.$store.state.user.user && this.$store.state.user.user.email
    },
    fullName() {
      const user = this.$store.state.user.user

      const name = []
      if (user && user.first_name) {
        name.push(user.first_name)
      }

      if (user && user.last_name) {
        name.push(user.last_name)
      }

      const fullName = name.join(' ')

      if (!fullName) {
        return 'Anonymous'
      }

      return fullName
    }
  },
  mounted() {
    const email = this.$route.query.email
    const key = this.$route.query.key

    // Link is invalid if no email or key is present
    if (!email || !key) {
      return (this.message = this.invalidMessage)
    }

    // Redirect to login page if user is not logged in
    if (!this.isLoggedIn) {
      return this.redirectLogin(email, key)
    }

    // Return Places to be claimed by the user based on matching data
    this.getPlaces(email, key)

    // Clear Cookies whether or not the request succeeded or failed
    // to make sure that the user has to repeat the process
    Cookies.remove('inviteEmail')
    Cookies.remove('inviteKey')
    Cookies.remove('inviteMode')
  },
  methods: {
    getPlaceKind(place) {
      if (place.kind === 'poi' || place.kind === '') {
        return 'Point of Interest'
      }
      return startCase(place.kind)
    },
    getFPCCLink(place) {
      let prefix = 'art'

      if (place.kind === 'poi' || place.kind === '') {
        prefix = 'place-names'
      }
      return `/${prefix}/${encodeFPCC(place.name)}`
    },
    redirectLogin(email, key) {
      // Set cookies that will be reused later on after logging in
      Cookies.set('inviteEmail', email)
      Cookies.set('inviteKey', key)
      Cookies.set('inviteMode', true)

      window.location.href = `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    },
    async claimPlaces(email, key, userId) {
      this.isLoading = true

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

      this.isLoading = false

      if (result.status === 200) {
        this.claimSuccess = true
        this.message = result.data.message
      } else {
        this.message = this.invalidMessage
      }
    },
    async getPlaces(email, key) {
      const claimConfirmUrl = `${getApiUrl(
        'profile/claim/confirm/'
      )}?email=${email}&key=${key}`
      const result = await await this.$axios.get(claimConfirmUrl)

      if (result.status === 200) {
        this.places = result.data.places
      }
    },
    handleClaim() {
      // Don't trigger confirmation if it's already loading
      if (this.isLoading) return

      // Confirm action first before actually triggering the process
      if (
        !window.confirm(
          'Are you sure you wish to claim the profile(s) listed? The profile(s) will be bound to the currently logged in account.'
        )
      )
        return

      // Process the invitation
      const email = this.$route.query.email
      const key = this.$route.query.key
      this.claimPlaces(email, key, this.userid)
    }
  }
}
</script>

<style lang="scss" scoped>
.clain-email {
  height: 100%;
}

.claim-header,
.claim-body {
  padding: 1.5em;
  font-family: 'BCSans', sans-serif;
}

.claim-header {
  padding-bottom: 0.75em;
  font-family: sans-serif;
}

.claim-body {
  padding-top: 0;
}

.claim-cta {
  background-color: #c46156;
  display: flex;
  position: relative;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-radius: 0.5em;
  margin-bottom: 1em;
  margin-top: 1em;
  cursor: pointer;
  color: white;
}

.button__text {
  color: #ffffff;
  transition: all 0.2s;
}

.button--loading .button__text {
  visibility: hidden;
  opacity: 0;
}

.button--loading::after {
  content: '';
  position: absolute;
  width: 16px;
  height: 16px;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  margin: auto;
  border: 4px solid transparent;
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: button-loading-spinner 1s ease infinite;
}

@keyframes button-loading-spinner {
  from {
    transform: rotate(0turn);
  }

  to {
    transform: rotate(1turn);
  }
}
</style>
