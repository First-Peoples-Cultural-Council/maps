<template>
  <div class="accordion sidebar-fold-container">
    <b-collapse id="outer-collapse" visible>
      <b-card>
        <div
          v-b-toggle.inner-collapse
          class="innerToggle pl-2 pr-2"
          :class="{ fixTop: visible }"
        >
          <span
            class="color-gray font-09 font-weight-bold d-inline-block valign-middle"
          >
          </span>
          <span class="d-inline-block badge-section">
            <slot name="badges"></slot>
          </span>
          <span class="d-inline-block float-right">
            <img
              v-if="!visible"
              src="@/assets/images/arrow_up_icon.svg"
              alt="Open"
            />
            <img v-else src="@/assets/images/arrow_down_icon.svg" alt="Close" />
          </span>
        </div>
        <b-collapse
          id="inner-collapse"
          v-model="visible"
          :class="{ innerFix: visible }"
        >
          <slot></slot>
        </b-collapse>
      </b-card>
    </b-collapse>
  </div>
</template>

<script>
export default {
  data() {
    return {
      visible: false
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
  min-height: 40px;
  padding: 0.5em;
}
.fixTop {
  position: fixed;
  background-color: white;
  width: 100%;
  left: 0;
  right: 0;
  box-shadow: 0px 2px 6px 3px rgba(0, 0, 0, 0.1);
}

.innerFix {
  padding-top: 2em !important;
  padding-bottom: 3em !important;
}

.badge-section section {
  padding: 0 !important;
  margin: 0 !important;
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
</style>
