<template>
  <div class="nav-container">
    <div v-if="email" class="user-container cursor-pointer" @click="profile">
      <nav class="navbar-icon-container">
        <img
          src="@/assets/images/user_icon_red.svg"
          alt="Menu"
          class="navbar-icon user_icon"
        />
      </nav>
    </div>
    <div class="navbar-container cursor-pointer" @click="openNav">
      <nav class="navbar-icon-container">
        <img
          src="@/assets/images/menu_icon.svg"
          alt="Menu"
          class="navbar-icon"
        />
      </nav>
    </div>
    <transition name="fade">
      <div v-if="navigationOpen" class="navigation">
        <div class="nav-header pl-2">
          <img
            src="@/assets/images/symbol_text.png"
            alt="Logo"
            class="nav-logo-img cursor-pointer"
            @click="handleLogoClick"
          />
        </div>
        <div class="nav-body">
          <ul class="nav-links p-0 m-0 list-style-none">
            <li>
              <nuxt-link class="color-gray" to="/" @click.native="handleNavLink"
                >Home</nuxt-link
              >
            </li>
            <li>
              <nuxt-link
                class="color-gray"
                to="/languages"
                @click.native="resetMap"
                >Languages</nuxt-link
              >
            </li>
            <li>
              <nuxt-link
                class="color-gray"
                to="/first-nations"
                @click.native="resetMap"
                >First Nations</nuxt-link
              >
            </li>
            <li>
              <nuxt-link
                class="color-gray"
                to="/place-names"
                @click.native="resetMap"
                >Place-names</nuxt-link
              >
            </li>
            <li>
              <a class="color-gray" href="http://184.69.112.115/orderMaps"
                >Order Maps</a
              >
            </li>
            <li>
              <a class="color-gray" href="https://maps.fpcc.ca/help">Help</a>
            </li>
            <li class="login-nav cursor-pointer">
              <a
                v-if="!email"
                href="https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://maps-dev.fpcc.ca"
                class="d-block"
                >Login</a
              >
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
import { getApiUrl } from '@/plugins/utils.js'

export default {
  data() {
    return {
      navigationOpen: false
    }
  },
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    },
    email() {
      return this.$store.state.user.user && this.$store.state.user.user.email
    }
  },
  methods: {
    profile() {
      this.$router.push({ path: '/profile/' + this.$store.state.user.user.id })
    },
    async logout() {
      await this.$axios.$get(
        `${getApiUrl('user/logout/')}?timestamp=${new Date().getTime()}`
      )
      this.$store.commit('user/setUser', null)
      this.$store.commit('user/setLoggedIn', false)
      window.location =
        'https://fplm.auth.ca-central-1.amazoncognito.com/logout?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://maps-dev.fpcc.ca'
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
    }
  }
}
</script>

<style>
.navbar-container,
.user-container {
  position: fixed;
  top: 10px;
  right: 10px;
  background-color: white;
  padding: 1em;
  border-radius: 50%;
  z-index: 50;
}
.user-container {
  padding: 0.67em;
  width: 45px;
  height: 45px;
  right: 60px;
}
.navigation {
  position: fixed;
  height: 86px;
  width: 100%;
  display: flex;
  background-color: white;
  top: 0;
  left: 0;
  z-index: 10000;
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
}
.navbar-icon {
  display: inline-block;
  width: 15px;
  height: 15px;
  line-height: 0;
  padding: 0;
  margin: 0;
}
.nav-links {
  display: inline-block;
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

@media (max-width: 992px) {
  .nav-container {
    display: inline-block;
    display: table-cell;
    width: 15%;
    vertical-align: middle;
  }

  .navbar-container {
    position: static;
    display: inline-block;
    padding: 0.8em;
    border: 1px solid rgba(0, 0, 0, 0.1);
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
