<template>
  <div class="accordion sidebar-fold-container">
    <b-collapse id="outer-collapse" visible>
      <div id="innerToggleHead" :class="{ fixTop: visible }">
        <slot name="tabs"></slot>
        <div class="innerToggle pl-2 pr-2">
          <div class="d-table innerHeader">
            <span
              class="d-inline-block badge-section d-table-cell valign-middle"
              style="width: 95%"
            >
              <slot name="badges"></slot>
            </span>
            <span
              class="d-inline-block d-table-cell valign-middle cursor-pointer"
              style="width: 5%; line-height: 0;"
              @click.prevent="toggleSideBar"
            >
              <img
                v-if="!visible"
                src="@/assets/images/arrow_up_icon.svg"
                alt="Open"
              />
              <img
                v-else
                src="@/assets/images/arrow_down_icon.svg"
                alt="Close"
              />
            </span>
          </div>
        </div>
      </div>
      <div ref="innerCollapse">
        <b-collapse
          id="side-inner-collapse"
          v-model="visible"
          :class="{ innerFix: visible }"
        >
          <slot></slot>
          <transition v-if="showLoading" name="fade">
            <div class="loading-spinner">
              <img src="@/assets/images/loading.gif" />
            </div>
          </transition>
        </b-collapse>
      </div>
    </b-collapse>
    <div v-if="isDrawerShown" class="sidefold-modal">
      <slot name="side-panel"></slot>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      visible: false
    }
  },
  computed: {
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    },
    isMobileSideBarOpen() {
      return this.$store.state.responsive.isMobileSideBarOpen
    },
    showLoading() {
      return this.$store.state.sidebar.showLoading
    }
  },
  methods: {
    toggleSideBar() {
      this.visible = !this.visible
      this.$store.commit('responsive/setMobileSideBarState', this.visible)
    }
  }
}
</script>

<style>
.sidefold-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100vw;
  height: 100vh;
  overflow-y: hidden;
  overflow-x: hidden;
  z-index: 500000;
  background-color: rgba(0, 0, 0, 0.8);
}
.sidebar-fold-container .card-body {
  padding: 0 !important;
}

.sidebar-fold-content {
  position: relative;
}
.innerToggle {
  padding: 1em;
  background-color: white;
  box-shadow: 0px 2px 6px 3px rgba(0, 0, 0, 0.1);
}
.fixTop {
  position: static;
  width: 100%;
  left: 0;
  right: 0;
  z-index: 10;
  top: 18%;
}

.innerFix {
  padding-top: 0em !important;
  padding-bottom: 4em !important;
}

.badge-section section {
  padding: 0 !important;
  margin: 0 !important;
}

#outer-collapse {
  background-color: white;
}

#side-inner-collapse .sidebar-tabs {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 50;
}

#side-inner-collapse {
  max-height: 60vh;
  overflow-y: scroll;
  overflow-x: hidden;
}

#side-inner-collapse .sidebar-tabs .nav-tabs .nav-link {
  opacity: 1;
}

#side-inner-collapse .sidebar-tabs .nav-item {
  background-color: White;
}

#side-inner-collapse .sidebar-tabs .nav-item a::before {
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  box-shadow: 0px -2px 2px 1px rgba(0, 0, 0, 0.05);
}

.innerToggle > span > section > div {
  margin: 0 !important;
  margin-bottom: 0 !important;
}

.innerToggle > div > span > section > div {
  margin: 0 !important;
  margin-bottom: 0 !important;
}

.innerHeader {
  width: 100%;
}

#outer-collapse .card-body {
  position: relative;
}
</style>
