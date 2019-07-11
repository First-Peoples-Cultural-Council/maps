<template>
  <div class="sidebar-container">
    <div class="sidebar-header">
      <Logo
        class="cursor-pointer"
        @click.native.prevent="handleLogoClick"
      ></Logo>
    </div>
    <div class="sidebar-body">
      <div class="sidebar-tabs">
        <div>
          <b-tabs fill content-class="mt-3">
            <b-tab id="languages-tab" title="Languages" active
              ><slot></slot
            ></b-tab>
            <b-tab id="arts-tab" title="Arts"><p>Arts</p></b-tab>
            <b-tab id="heritages-tab" title="Heritages"><p>Heritages</p></b-tab>
          </b-tabs>
        </div>
      </div>
      <div class="sidebar-content"></div>
    </div>
  </div>
</template>

<script>
import Logo from '@/components/Logo.vue'

export default {
  components: {
    Logo
  },
  filters: {
    lowerCase(value) {
      return value.toLowerCase()
    }
  },
  props: {
    active: {
      type: String,
      default: 'Languages'
    }
  },
  data() {
    return {
      navigationTabs: [
        {
          id: 0,
          name: 'Languages',
          path: '/languages',
          pathName: 'index-languages-language'
        },
        {
          id: 1,
          name: 'Arts',
          path: '/arts',
          pathName: 'index-arts-art'
        },
        {
          id: 2,
          name: 'Heritages',
          path: '/heritages',
          pathName: 'index-heritages-heritage'
        }
      ]
    }
  },
  methods: {
    handleNavigation(e, data) {
      const path = this.navigationTabs.find(nt => nt.name === data).path
      const self = this
      setTimeout(() => {
        self.$router.push({
          path
        })
      })
    },
    handleLogoClick(e) {
      this.$router.push({
        path: '/'
      })
    }
  }
}
</script>

<style>
.sidebar-container {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: var(--sidebar-width, 350px);
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  padding-bottom: 1em;
}
.sidebar-header {
  background-color: transparent;
  flex: 1 1 0;
  display: flex;
  align-items: center;
}

.sidebar-body {
  background-color: white;
  flex: 16 1 0;
}

.nav-tabs .nav-link {
  font-size: 0.8em;
  background-color: #f4eee9;
}

.nav-tabs .nav-link {
  color: var(--color-gray, #707070);
  font-weight: 500;
  opacity: 0.8;
}
.nav-tabs .nav-link.active {
  color: var(--color-red, #c46257);
  position: relative;
  font-weight: 500;
  border: 0;
  line-height: 10px;
  opacity: 1;
  text-transform: capitalize !important;
}

.nav-tabs .nav-link.active::before {
  content: '';
  display: block;
  width: 100%;
  height: 10px;
  background-color: white;
  position: absolute;
  top: -10px;
  left: 0;
  border-top-right-radius: 0.5em;
}

.nav-tabs .nav-link.active[aria-posinset='2']::before {
  border-top-left-radius: 0.5em;
}

.nav-tabs .nav-link.active[aria-posinset='3']::before {
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0em;
}
</style>
