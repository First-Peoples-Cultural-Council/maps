<template>
  <div class="sidebar-container">
    <div class="sidebar-desktop">
      <div class="sidebar-header">
        <Logo
          class="cursor-pointer"
          @click.native.prevent="handleLogoClick"
        ></Logo>
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
          <slot name="content"></slot>
          <slot name="cards"></slot>
        </div>
      </div>
    </div>
    <div class="sidebar-mobile d-none">
      <SideBarFold>
        <template v-slot:cards>
          <div class="sidebar-tabs sidebar-tabs-fold">
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
          <slot name="cards"></slot>
        </template>
      </SideBarFold>
    </div>
  </div>
</template>

<script>
import Logo from '@/components/Logo.vue'
import SideBarFold from '@/components/SideBarFold.vue'

export default {
  components: {
    Logo,
    SideBarFold
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
    },
    badgesToDisplay: {
      type: Array,
      default() {
        return []
      }
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
          path: '/art',
          pathName: 'index-art-art'
        },
        {
          id: 2,
          name: 'Heritages',
          path: '/heritages',
          pathName: 'index-heritages-heritage'
        }
      ],
      fold: true
    }
  },
  methods: {
    handleNavigation(e, data) {
      const path = this.navigationTabs.find(nt => nt.name === data).path
      const self = this
      self.$router.push({
        path
      })
    },
    handleLogoClick(e) {
      this.$router.push({
        path: '/'
      })
    },
    toggleFold(e) {
      this.fold = !this.fold
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
  overflow-y: auto;
  padding-bottom: 1em;
}
.sidebar-header {
  background-color: transparent;
  overflow-x: hidden;
}

.sidebar-body {
  background-color: white;
}

.nav-tabs .nav-link {
  font-size: 0.8em;
  background-color: #f4eee9;
}

.nav-tabs .nav-link {
  color: var(--color-gray, #707070);
  font-weight: 700;
  opacity: 0.8;
}
.nav-tabs .nav-link.active {
  color: var(--color-red, #c46257);
  position: relative;
  font-weight: 700;
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

.nav-tabs .nav-item.arts .nav-link.active::before {
  border-top-left-radius: 0.5em;
}
.nav-tabs .nav-item.heritages .nav-link.active::before {
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0em;
}

@media (max-width: 576px) {
  .sidebar-desktop {
    display: none;
  }

  .sidebar-container {
    width: 100%;
    top: unset;
    padding: 0;
    margin: 0;
    z-index: 50;
    max-height: 90%;
  }

  .sidebar-mobile {
    display: block !important;
  }

  .sidebar-tabs-fold {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
  }

  .sidebar-tabs-fold .nav-tabs .nav-link {
    opacity: 1;
  }

  .sidebar-tabs-fold .nav-fill .nav-item {
    background-color: white;
  }
}
</style>
