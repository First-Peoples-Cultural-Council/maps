<template>
  <div ref="sidebarContainer" class="sidebar-container">
    <div class="sidebarRelative position-relative">
      <div class="sidebar-desktop">
        <div class="sidebar-header">
          <Logo class="cursor-pointer" :logo-alt="1"></Logo>
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
            <slot name="badges"></slot>
            <slot name="cards"></slot>
          </div>
          <Contact></Contact>
        </div>
      </div>
      <div class="sidebar-mobile d-none">
        <SideBarFold>
          <template v-slot:tabs>
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
          </template>
          <template v-slot:badges>
            <slot name="badges"></slot>
          </template>
          <slot name="cards"></slot>
        </SideBarFold>
      </div>
    </div>
  </div>
</template>

<script>
import Logo from '@/components/Logo.vue'
import SideBarFold from '@/components/SideBarFold.vue'
import Contact from '@/components/Contact.vue'

export default {
  components: {
    Logo,
    SideBarFold,
    Contact
  },
  filters: {
    lowerCase(value) {
      return value.toLowerCase()
    }
  },
  props: {
    active: {
      type: String,
      default: ''
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
          name: 'Heritage',
          path: '/heritages',
          pathName: 'index-heritages-heritage'
        }
      ],
      fold: true
    }
  },
  mounted() {
    const sideBarContainer = this.$refs.sidebarContainer
    const el = document.getElementById('innerToggleHead')
    sideBarContainer.addEventListener('scroll', function(e) {
      if (this.scrollTop > '25') {
        el.classList.add('position-fixed')
      } else {
        el.classList.remove('position-fixed')
      }
    })
  },
  methods: {
    handleNavigation(e, data) {
      const path = this.navigationTabs.find(nt => nt.name === data).path
      const self = this
      self.$router.push({
        path
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
  text-decoration: underline;
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
.nav-tabs .nav-item.heritage .nav-link.active::before {
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0em;
}

@media (max-width: 992px) {
  .sidebar-desktop {
    display: none;
  }

  .sidebar-container {
    width: 100%;
    top: unset;
    padding: 0;
    margin: 0;
    z-index: 50;
    max-height: 80%;
  }

  .sidebar-mobile {
    display: block !important;
  }

  .sidebar-mobile .sidebar-tabs {
    margin-top: 10px;
    background-color: white;
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

  .nav-tabs .nav-link.active::before {
    position: static;
    content: unset;
  }

  .nav-tabs .nav-link.active {
    line-height: inherit;
  }
}
</style>
