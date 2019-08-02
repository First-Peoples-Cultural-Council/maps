<template>
  <div class="accordion sidebar-fold-container">
    <b-collapse id="outer-collapse" visible>
      <div id="innerToggleHead" :class="{ fixTop: visible }">
        <slot name="tabs"></slot>
        <div class="innerToggle pl-2 pr-2" @click.prevent="toggleSideBar">
          <div class="d-table innerHeader">
            <span
              class="d-inline-block badge-section d-table-cell valign-middle"
              style="width: 95%"
            >
              <slot name="badges"></slot>
            </span>
            <span
              class="d-inline-block d-table-cell valign-middle"
              style="width: 5%; line-height: 0;"
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
      <b-collapse
        id="inner-collapse"
        v-model="visible"
        :class="{ innerFix: visible }"
      >
        <slot></slot>
      </b-collapse>
    </b-collapse>
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
    isMobileSideBarOpen() {
      return this.$store.state.responsive.isMobileSideBarOpen
    }
  },
  mounted() {
    this.$store.commit('responsive/setMobileSideBarState', false)
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
.sidebar-fold-container .card-body {
  padding: 0 !important;
}

.sidebar-fold-content {
  position: relative;
}
.innerToggle {
  padding: 0.5em;
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
  padding-bottom: 1em !important;
}

.badge-section section {
  padding: 0 !important;
  margin: 0 !important;
}

#outer-collapse {
  background-color: white;
}

#inner-collapse .sidebar-tabs {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 50;
}

#inner-collapse .sidebar-tabs .nav-tabs .nav-link {
  opacity: 1;
}

#inner-collapse .sidebar-tabs .nav-item {
  background-color: White;
}

#inner-collapse .sidebar-tabs .nav-item a::before {
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
