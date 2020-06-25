<template>
  <div class="nav-container">
    <div class="navigation-container hide-mobile">
      <Event />
      <div
        v-if="isLoggedIn"
        class="user-container menu-container cursor-pointer hide-mobile"
        @click="profile"
      >
        <div
          v-if="
            isLoggedIn &&
              user.languages &&
              user.languages.length === 0 &&
              user.communities &&
              user.communities.length === 0
          "
          class="notify-badge"
        ></div>
        <nav class="navbar-icon-container">
          <img
            v-if="!picture"
            src="@/assets/images/user_icon.svg"
            alt="Menu"
            class="navbar-icon user_icon"
          />
          <img
            v-if="picture"
            :src="picture"
            alt="Menu"
            class="navbar-icon user_icon"
          />
        </nav>
      </div>
      <div v-else class="menu-container hide-mobile" @click="redirectLogin">
        <span>LOGIN</span>
        <img src="@/assets/images/user_icon.svg" alt="Menu" />
      </div>
      <div class="menu-container  hide-mobile" @click="openNav">
        <span>MENU</span>
        <img src="@/assets/images/menu_icon.svg" alt="Menu" />
      </div>
    </div>

    <div class="d-none cursor-pointer mobile-logo-container">
      <Logo :logo-alt="4"></Logo>
    </div>
    <div class="d-none mobile-search-container">
      <div class="navbar-icon-container cursor-pointer" @click="showEvent">
        <img
          src="@/assets/images/event_icons.svg"
          alt="Event"
          class="navbar-icon"
        />
      </div>
      <div
        class="navbar-icon-container cursor-pointer"
        @click="$root.$emit('openContributeModal')"
      >
        <img
          src="@/assets/images/plus_bigger_icon.svg"
          alt="Contribute"
          class="navbar-icon"
        />
      </div>
      <div
        class="navbar-icon-container cursor-pointer"
        @click="$root.$emit('openShareEmbed')"
      >
        <img
          src="@/assets/images/share_icon_red.svg"
          alt="Share"
          class="navbar-icon"
        />
      </div>
      <div class="navbar-icon-container cursor-pointer" @click="showSearch">
        <img
          src="@/assets/images/search_icon.svg"
          alt="Search"
          class="navbar-icon"
        />
      </div>
      <div class="navbar-icon-container cursor-pointer" @click="openNav">
        <img
          src="@/assets/images/menu_icon.svg"
          alt="Menu"
          class="navbar-icon"
        />
      </div>
    </div>
    <transition name="fade">
      <div v-if="navigationOpen" class="navigation">
        <div
          class="nav-header cursor-pointer pl-2"
          @click.prevent="handleNavLink"
        >
          <img
            src="../assets/images/symbol@2x.png"
            alt="Language Map Of British Columbia"
            height="auto"
            width="50"
            class="d-inline-block mb-2"
          />
          <div
            style="color: #632015; font-size: 1.2em;"
            class="d-inline-block font-weight-bold ml-3"
          >
            First Peoples' Map of B.C.
          </div>
        </div>
        <div class="nav-body">
          <nuxt-link
            v-if="isLoggedIn"
            class="color-gray d-none user-mobile text-center"
            :to="`/profile/${userid}`"
            @click.native="resetMap"
          >
            <div class="text-center d-inline-block">
              <img
                v-if="!picture"
                src="@/assets/images/user_icon.svg"
                alt="Menu"
                class="navbar-icon user_icon d-inline-block"
              />
              <img
                v-if="picture"
                :src="picture"
                alt="Menu"
                class="navbar-icon user_icon d-inline-block"
              />
            </div>
          </nuxt-link>

          <ul class="nav-links p-0 m-0 list-style-none">
            <li>
              <a class="color-gray" href="/page/order-maps">Order Maps</a>
            </li>
            <li>
              <a class="color-gray" href="/page/tos">Terms of Use</a>
            </li>
            <li>
              <a class="color-gray" href="/page/help">Help</a>
            </li>
            <li>
              <a class="color-gray" href="/page/contact">Contact Us</a>
            </li>
            <li class="login-nav cursor-pointer">
              <a v-if="!email" :href="getLoginUrl" class="d-block">Login</a>
              <a v-if="email" @click="logout">Logout</a>
            </li>
          </ul>
          <div
            class="close-nav cursor-pointer d-inline-block"
            @click="closeNav"
          >
            <a href="#">
              <img src="@/assets/images/close_icon.svg" alt="Close"
            /></a>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import { getApiUrl } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'
import Event from '@/components/Event.vue'

export default {
  components: {
    Logo,
    Event
  },
  data() {
    return {
      navigationOpen: false,
      show: false
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    userid() {
      return this.$store.state.user.user.id
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    },
    email() {
      return this.$store.state.user.user && this.$store.state.user.user.email
    },
    ...mapState({
      picture: state => state.user.picture
    }),
    user() {
      return this.$store.state.user.user
    }
  },
  mounted() {
    // console.log('mounted')
  },
  methods: {
    showSearch() {
      this.$root.$emit('showSearchOverlay', true)
    },
    showEvent() {
      this.$root.$emit('toggleEventOverlay', true)
    },
    profile() {
      this.$root.$emit('resetMap')
      this.$router.push({ path: '/profile/' + this.$store.state.user.user.id })
    },
    async logout() {
      await this.$axios.$get(
        `${getApiUrl('user/logout/')}?timestamp=${new Date().getTime()}`
      )

      this.$store.commit('user/setUser', null)
      this.$store.commit('user/setLoggedIn', false)
      this.$store.commit('user/setPicture', null)

      setTimeout(() => {
        window.location.href =
          'https://auth.firstvoices.com/logout?response_type=token&client_id=tssmvghv2kfepud7tth4olugp&redirect_uri=https://maps.fpcc.ca'
      }, 500)
    },
    handleLogoClick() {
      this.$router.push({
        path: '/'
      })
    },
    openNav() {
      this.navigationOpen = true
    },
    closeNav() {
      this.navigationOpen = false
    },
    handleNavLink() {
      this.$store.commit('mapinstance/setForceReset', true)
      if (this.$route.name === 'index') {
        this.$root.$emit('resetMap')
        this.$store.commit('mapinstance/setForceReset', false)
      } else {
        this.$router.push({ path: '/' })
      }

      this.closeNav()
    },
    resetMap() {
      this.$root.$emit('resetMap')
      this.closeNav()
    },
    redirectLogin() {
      window.location.href = `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    },
    redirectLogout() {
      window.location.href = `${process.env.COGNITO_URL}/logout?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    },
    getLoginUrl() {
      return `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    }
  }
}
</script>

<style lang="scss">
.navigation-container {
  display: flex;
}
.notify-badge {
  position: absolute;
  top: 2.5px;
  right: 5px;
  width: 10px;
  height: 10px;
  background-color: rgba(173, 20, 20, 0.753);
  border-radius: 50%;
}

.menu-container {
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: white;
  z-index: 50;
  border: 1px solid #beb2a5;
  padding: 0.8em;
  border-radius: 1.5em;
  margin-right: 0.5em;
  box-shadow: 0px 3px 6px #00000022;
  color: #151515;
  font: Bold 15px/18px Proxima Nova;

  & > * {
    margin: 0 0.4em 0 0.2em;
  }

  img {
    width: 18px;
    height: 18px;
  }
}

.user-container {
  display: relative;
  width: 47px;
  height: 47px;
}
.navigation {
  position: fixed;
  height: 86px;
  width: 100%;
  display: flex;
  background-color: white;
  top: 0;
  left: 0;
  z-index: 999999;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0px 1px 4px rgba(0, 0, 0, 0.2);
  padding-right: 0.5em;
}
.nav-logo-img {
  display: inline-block;
  height: 40px;
  width: auto;
}
.navbar-icon-container {
  line-height: 0;
  color: #151515;
  font: Bold 15px/18px Proxima Nova;
}

.navbar-icon {
  display: inline-block;
  width: 18px;
  height: 22px;
  line-height: 0;
  padding: 0;
  margin: 0;
}
.nav-links {
  display: inline-block;
  text-align: center;
}
.nav-links li {
  margin-right: 1em;
  font-size: 0.8em;
  display: inline-block;
}

.nav-links a {
  color: var(--color-gray, '#6f6f70');
  font-weight: 500;
}

.login-nav a {
  display: inline-block;
  background-color: #f4eee9;
  border-radius: 0.5em;
  padding: 0.5em 2.7em;
  color: #6f6f70;
}
.close-nav {
  border-radius: 50%;
  border: 1px solid #dedcda;
  padding: 1em;
  line-height: 0;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

.user_icon {
  display: inline-block;
  width: 23px;
  height: 23px;
}

@media (max-width: 1200px) {
  .menu-container {
    width: 45px;
    height: 45px;
    margin: 0 0.25em;
  }
  .menu-container span {
    display: none;
  }
  .user-container {
    margin: 0 0.25em;
  }
}

/* Navigation Icons when Drawer is open */
.arts-container .menu-container {
  width: 45px;
  height: 45px;
}
.arts-container .menu-container span {
  display: none;
}

.arts-container .menu-container img {
  margin: 0;
}
.arts-container .user-container {
  margin: 0 0.25em;
}

@media (max-width: 992px) {
  .searchbar-mobile {
    flex: 10 1 auto;
  }

  .user-mobile {
    display: block !important;
  }

  .user_icon {
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 0.5em;
    width: 80px;
    height: 80px;
    border-radius: 0.5em;
  }
  .nav-container {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .navbar-icon-container {
    padding-right: 1em;
  }

  .navbar-icon-container .navbar-icon {
    width: 25px;
    height: 25px;
  }

  .mobile-logo {
    display: inline-block;
    height: 100%;
  }

  .mobile-logo-container {
    display: inline-block !important;
    height: 100%;
  }

  .mobile-search-container {
    display: flex !important;
  }

  .navbar-container {
    display: inline-block;
    position: static;
    background-color: white;
    border: 0;
    top: unset;
    left: unset;
    right: unset;
    bottom: unset;
    z-index: unset;
    padding: 0;
    margin: 0;
  }

  .navigation {
    flex-direction: column;
    height: auto;
    padding: 0.5em;
  }

  .nav-links {
    display: flex;
    flex-direction: column;
    margin-top: 1em !important;
  }

  .nav-links li {
    margin: 0.5em 0;
  }

  .nav-header {
    align-self: self-end;
  }

  .close-nav {
    position: absolute;
    top: 0.5em;
    right: 0.5em;
    padding: 0.75em;
  }
}
</style>
