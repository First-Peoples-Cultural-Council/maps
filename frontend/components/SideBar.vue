<template>
  <div class="sidebar-container">
    <div class="sidebar-header">
      <Logo></Logo>
    </div>
    <div class="sidebar-body">
      <div class="sidebar-tabs">
        <b-nav tabs fill>
          <b-nav-item
            v-for="tab in navigationTabs"
            :key="tab.id"
            :active="active === tab.name ? true : false"
            :class="tab.name | lowerCase"
            @click.prevent="handleNavigation($event, tab.name)"
            >{{ tab.name }}
          </b-nav-item>
        </b-nav>
      </div>
      <div class="sidebar-content">
        <slot></slot>
      </div>
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

.nav-tabs .nav-item.arts .nav-link.active::before {
  border-top-left-radius: 0.5em;
}

.nav-tabs .nav-item.heritages .nav-link.active::before {
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0em;
}
</style>
