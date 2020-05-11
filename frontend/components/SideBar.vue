<template>
  <div
    id="sidebar-container"
    ref="sidebarContainer"
    class="sidebar-container"
    :class="{ 'sidebar-arts-container': showSidePanel }"
  >
    <div class="sidebarRelative position-relative">
      <div class="sidebar-desktop position-relative">
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
            <transition v-if="showLoading" name="fade">
              <div class="loading-spinner">
                <img src="@/assets/images/loading.gif" />
              </div>
            </transition>
          </div>
          <Contact
            :subject="
              `FPCC Map: Didn't find what I was looking for (${$route.path})`
            "
          ></Contact>
        </div>
        <div
          v-if="showSidePanel"
          class="sidebar-side-panel"
          :class="{ 'hide-scroll-y': showGallery }"
        >
          <slot name="side-panel"></slot>
        </div>
      </div>
      <div class="sidebar-mobile d-none">
        <SideBarFold>
          <template v-slot:side-panel>
            <div
              v-if="showSidePanel"
              class="sidebar-side-panel"
              :class="{ 'hide-scroll-y': showGallery }"
            >
              <slot name="side-panel"></slot>
            </div>
          </template>
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
    },
    showSidePanel: {
      type: Boolean,
      default: false
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
  computed: {
    showLoading() {
      return this.$store.state.sidebar.showLoading
    },
    showGallery() {
      return this.$store.state.sidebar.showGallery
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
      // Recalibrate Vuex Values
      this.resetState()

      const path = this.navigationTabs.find(nt => nt.name === data).path
      const self = this
      self.$router.push({
        path
      })
    },
    toggleFold(e) {
      this.fold = !this.fold
    },
    resetState() {
      this.$store.commit('arts/setTaxonomyTag', [])
      this.$store.commit('arts/setArtSearch', '')
      this.$store.commit('sidebar/setDrawerContent', false)
    }
  }
}
</script>

<style>
.sidebar-side-panel {
  position: fixed;
  top: 0;
  left: 425px;
  width: 425px;
  height: 100vh;
  overflow-x: hidden;
  z-index: 999999;
}

.sidebar-container {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: var(--sidebar-width, 425px);
  overflow-y: scroll;
  padding-bottom: 1em;
  font-family: 'Proxima Nova', sans-serif;
}

.sidebar-arts-container {
  width: var(--sidebar-width, 425px);
}

.sidebar-header {
  background-color: transparent;
  overflow-x: hidden;
}

.sidebar-body {
  background-color: white;
}
.nav-tabs {
  display: flex;
  border-bottom: 0;
}

.nav-tabs .nav-item {
  flex: 1;
}
.nav-tabs .nav-link {
  font-family: 'Faustina', serif;
  font-size: 15px;
  background-color: #03333a;
  color: #fff;
  border-top-left-radius: 0rem;
  border-top-right-radius: 0rem;
}
.nav-tabs .nav-link.active {
  color: #b47a2b;
  position: relative;
  font-weight: 700;
  border: 0;
  opacity: 1;
  text-transform: capitalize !important;
}

.sidebar-desktop .nav-tabs .nav-link.active::before {
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

.sidebar-desktop .nav-tabs .nav-item.arts .nav-link.active::before {
  border-top-left-radius: 0.5em;
}
.sidebar-desktop .nav-tabs .nav-item.heritage .nav-link.active::before {
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0em;
}

/* Sidebar style when screen width is 1300px and drawer is open */
@media (min-width: 993px) and (max-width: 1300px) {
  .arts-container .sidebar-container {
    width: 350px;
  }
  .arts-container .sidebar-side-panel {
    width: 350px;
    left: 350px;
  }
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
    overflow: hidden;
  }

  .sidebar-mobile {
    display: block !important;
  }

  .sidebar-mobile .sidebar-tabs {
    margin-top: 10px;
    background-color: white;
  }

  .sidebar-mobile .sidebar-tabs ul li {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f4eee9;
    height: 50px;
  }

  .sidebar-mobile .sidebar-tabs ul .nav-link {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
  }

  .sidebar-mobile .sidebar-tabs ul .nav-link.active {
    border-radius: 0;
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

  .nav-tabs .nav-link .active {
    border: 0;
  }

  .sidebar-side-panel {
    position: fixed;
    top: 0;
    left: 0;
    width: 325px;
    height: 100vh;
    overflow-x: hidden;
    z-index: 999999;
  }
}

.loading-spinner {
  display: flex;
  justify-content: center;
  width: 100%;
}

.loading-spinner img {
  width: 75px;
  height: 75px;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
