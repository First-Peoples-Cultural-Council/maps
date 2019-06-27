<template>
  <div class="sidebar-container">
    <div class="sidebar-header">
      Logo Goes Here
    </div>
    <div class="sidebar-body">
      <div class="sidebar-tabs">
        <b-nav tabs fill>
          <b-nav-item
            v-for="(tab, index) in navigationTabs"
            v-bind:key="index"
            @click.prevent="handleNavigation($event, tab)"
          >
            {{ tab }}
          </b-nav-item>
        </b-nav>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      navigationTabs: ['Languages', 'Arts', 'Heritage']
    }
  },
  methods: {
    handleNavigation(e, data) {
      console.log('Handling Navigation!', e, data)
      console.log('Router!', this.$router)
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
  width: 350px;
  display: flex;
  flex-direction: column;
}
.sidebar-header {
  background-color: transparent;
  flex: 2 1 0;
}

.sidebar-body {
  background-color: white;
  flex: 16 1 0;
}
</style>
