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
      default: "Languages"
    }
  },
  data() {
    return {
      navigationTabs: [
        {
          id: 0,
          name: "Languages",
          path: "/languages",
          pathName: "index-languages-language"
        },
        {
          id: 1,
          name: "Arts",
          path: "/arts",
          pathName: "index-arts-art"
        },
        {
          id: 2,
          name: "Heritages",
          path: "/heritages",
          pathName: "index-heritages-heritage"
        }
      ]
    };
  },
  mounted() {
    console.log("Mounted Sidebar", this.$route);
  },
  methods: {
    handleNavigation(e, data) {
      const path = this.navigationTabs.find(nt => nt.name === data).path;
      const self = this;
      setTimeout(() => {
        self.$router.push({
          path
        });
      });
    }
  }
};
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
  flex: 1 1 0;
  display: flex;
  align-items: center;
  padding: 1em;
}

.sidebar-body {
  background-color: white;
  flex: 16 1 0;
}

.nav-item {
  background-color: #f4eee9;
  font-size: 0.9em;
}
.nav-item a {
  color: var(--color-dark-gray, #707070);
}
.nav-item.active {
  background-color: white;
  border: 0;
  position: relative;
  line-height: 10px;
}
.active::before {
  content: '';
  display: block;
  height: 10px;
  width: 100%;
  background-color: white;
  position: absolute;
  top: -10px;
  border-top-right-radius: 1em;
}
.nav-item.active a {
  color: var(--color-red, #c46257);
}
</style>
