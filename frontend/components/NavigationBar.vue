<template>
  <div class="nav-container">
    <div class="hide-mobile">
      <div
        v-if="isLoggedIn"
        class="user-container cursor-pointer hide-mobile"
        @click="profile"
      >
        <nav class="navbar-icon-container">
          <img
            v-if="!picture"
            src="@/assets/images/user_icon_red.svg"
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
      <div class="navbar-container cursor-pointer hide-mobile" @click="openNav">
        <nav class="navbar-icon-container">
          <img
            src="@/assets/images/menu_icon.svg"
            alt="Menu"
            class="navbar-icon"
          />
        </nav>
      </div>
    </div>

    <div
      class="d-none cursor-pointer mobile-logo-container"
      @click="$router.push({ path: '/' })"
    >
      <img src="@/assets/images/symbol@2x.png" alt="Menu" class="mobile-logo" />
    </div>
    <div class="d-none mobile-search-container">
      <div
        class="navbar-icon-container cursor-pointer"
        @click="$root.$emit('openContributeModal')"
      >
        <img
          src="@/assets/images/plus_medium_red.svg"
          alt="Search"
          class="navbar-icon"
        />
      </div>
      <div
        class="navbar-icon-container cursor-pointer"
        @click="$root.$emit('openShareEmbed')"
      >
        <img
          src="@/assets/images/share_icon_red.svg"
          alt="Search"
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
      <div class="navbar-container cursor-pointer" @click="openNav">
        <nav class="navbar-icon-container">
          <img
            src="@/assets/images/menu_icon.svg"
            alt="Menu"
            class="navbar-icon"
          />
        </nav>
      </div>
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
          <nuxt-link
            v-if="isLoggedIn"
            class="color-gray d-none user-mobile text-center"
            :to="`/profile/${userid}`"
            @click.native="resetMap"
          >
            <div class="text-center d-inline-block">
              <img
                v-if="!picture"
                src="@/assets/images/user_icon_red.svg"
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
              <nuxt-link class="color-gray" to="/" @click.native="handleNavLink"
                >Home</nuxt-link
              >
            </li>
            <li v-if="isLoggedIn">
              <nuxt-link class="color-gray" :to="`/profile/${userid}`"
                >Profile</nuxt-link
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
                to="/heritages"
                @click.native="resetMap"
                >Heritages</nuxt-link
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
                href="https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=3b9okcenun1vherojjv4hc6rb3&redirect_uri=https://maps-dev.fpcc.ca"
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
import { mapState } from 'vuex'
import { getApiUrl } from '@/plugins/utils.js'

export default {
  components: {},
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
    console.log('mounted')
  },
  methods: {
    showSearch() {
      this.$root.$emit('showSearchOverlay', true)
    },
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
        'https://fplm.auth.ca-central-1.amazoncognito.com/logout?response_type=token&client_id=3b9okcenun1vherojjv4hc6rb3&redirect_uri=https://maps-dev.fpcc.ca'
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
