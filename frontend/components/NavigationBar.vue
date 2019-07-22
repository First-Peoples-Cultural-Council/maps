<template>
  <div>
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
            <li><nuxt-link to="/">Home</nuxt-link></li>
            <li><nuxt-link to="/languages">Languages</nuxt-link></li>
            <li><nuxt-link to="/first-nations">First Nations</nuxt-link></li>
            <li><nuxt-link to="/place-names">Place-names</nuxt-link></li>
            <li><a target="_blank" href="https://firstvoices.com">Phrases</a></li>
            <!-- <li><a target="_blank" href="https://maps.fpcc.ca/help">Help</a></li>
            <li class="login-nav cursor-pointer">
              <a href="https://maps.fpcc.ca/user/login" class="d-block"
                >Login</a
              >
            </li> -->
            <li class="close-nav cursor-pointer" @click="closeNav">
              <a href="#">
                <img src="@/assets/images/close_icon.svg" alt="Close"
              /></a>
            </li>
          </ul>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  data() {
    return {
      navigationOpen: false
    }
  },
  methods: {
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
    }
  }
}
</script>

<style>
.navbar-container {
  position: fixed;
  top: 10px;
  right: 10px;
  background-color: white;
  padding: 1em;
  border-radius: 50%;
  z-index: 50;
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
  display: flex;
  align-items: center;
}
.nav-links li {
  margin-right: 1em;
  font-size: 0.8em;
}

.nav-links a {
  color: var(--color-gray);
  font-weight: 500;
}

.login-nav a {
  background-color: var(--color-beige);
  border-radius: 0.5em;
  padding: 0.5em 2.7em;
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
</style>
