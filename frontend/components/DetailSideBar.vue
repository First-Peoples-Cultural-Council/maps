<template>
  <div ref="sidebarContainer" class="ds">
    <div class="ds-container" :style="'width: ' + width + 'px;'">
      <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
      <slot></slot>
      <Contact></Contact>
    </div>
    <div class="detail-sidebar-mobile sidebar-mobile d-none">
      <SideBarFold>
        <template v-slot:badges>
          <slot name="badges"></slot>
        </template>
        <slot></slot>
      </SideBarFold>
    </div>
  </div>
</template>

<script>
import Contact from '@/components/Contact.vue'
import Logo from '@/components/Logo.vue'
import SideBarFold from '@/components/SideBarFold.vue'

export default {
  components: {
    Contact,
    Logo,
    SideBarFold
  },
  props: {
    width: {
      default: 375,
      type: Number
    }
  },
  data() {
    return {
      style: 2
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
  }
}
</script>

<style>
.ds-container {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: var(--sidebar-width, 350px);
  display: flex;
  flex-direction: column;
  background-color: white;
  overflow-y: auto;
  padding-bottom: 1em;
}

@media (max-width: 992px) {
  .ds-container {
    display: none;
  }

  .detail-sidebar-mobile {
    display: block !important;
  }

  .ds {
    width: 100%;
    top: unset;
    padding: 0;
    margin: 0;
    z-index: 50;
    max-height: 90%;
    bottom: 0;
    left: 0;
    position: fixed;
    overflow-y: auto;
    overflow-x: hidden;
  }
}
</style>
