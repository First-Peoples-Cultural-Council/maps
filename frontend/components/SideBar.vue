<template>
  <div class="sidebar-container">
    <div class="sidebar-header">
      Logo Goes Here
    </div>
    <div class="sidebar-body">
      <div class="sidebar-tabs">
        <b-nav tabs fill>
          <b-nav-item
            v-for="tab in navigationTabs"
            :key="tab.id"
            :class="{ active: active === tab.name }"
            @click.prevent="handleNavigation($event, tab.name)"
          >
            {{ tab.name }}
          </b-nav-item>
        </b-nav>
      </div>
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
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
  mounted() {
    console.log('Mounted Sidebar', this.$route)
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
