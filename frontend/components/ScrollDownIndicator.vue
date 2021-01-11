<template>
  <div v-if="showScrollIndicator" class="scroll-indicator-container">
    <button class="scroll-down-btn" @click="handleScrollDown">
      <img src="@/assets/images/arrow_scrolldown_icon.png" />
    </button>
  </div>
</template>

<script>
export default {
  props: {
    desktop: {
      type: String,
      default: null
    },
    mobile: {
      type: String,
      default: null
    }
  },
  data() {
    return {}
  },

  computed: {
    showScrollIndicator() {
      return this.isScrollDownBtnVisible && this.isMainPage
    },
    isScrollDownBtnVisible() {
      return this.$store.state.sidebar.showScrollIndicator
    },
    isMainPage() {
      const pathName = this.$route.name
      return (
        pathName === 'index-art' ||
        pathName === 'index-languages' ||
        pathName === 'index-heritages' ||
        pathName === 'index-grants' ||
        pathName === 'index' ||
        pathName === 'index-languages-lang' ||
        pathName === 'index-content-fn'
      )
    },
    isMobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    isMobileSideBarOpen() {
      return this.$store.state.responsive.isMobileSideBarOpen
    }
  },

  mounted() {
    const innerToggleContainer = document.querySelector('#innerToggleHead')
    const desktopContainer = document.querySelector(this.desktop)
    const mobileContainer = document.querySelector(this.mobile)

    /* Add Scroll eventListener on Desktop container */

    if (desktopContainer) {
      desktopContainer.addEventListener('scroll', e => {
        if (innerToggleContainer) {
          if (this.scrollTop > '25') {
            innerToggleContainer.classList.add('position-fixed')
          } else {
            innerToggleContainer.classList.remove('position-fixed')
          }
        }

        this.setScrollIndicatorVisibility()
      })
    }

    /* Add Scroll eventListener on Mobile container, if exist */

    if (mobileContainer) {
      mobileContainer.addEventListener('scroll', e => {
        this.setScrollIndicatorVisibility()
      })
    }

    /* checks window width if mobile mode or desktop */
    window.addEventListener('resize', this.checkWindowDimemsion)

    this.$root.$on('triggerScrollVisibilityCheck', () => {
      this.setScrollIndicatorVisibility()
    })

    /* Emulate the clicking of scroll down button */
    this.$root.$on('togglehideScrollIndicator', () => {
      setTimeout(() => {
        this.checkWindowDimemsion()
      }, 250)
    })
  },

  methods: {
    setScrollIndicatorVisibility() {
      /* Set store value for ScrollDown Indicator Visibility */
      const selectedContainer = document.querySelector(
        this.getSelectedContainer()
      )
      const isNotShown = selectedContainer
        ? selectedContainer.offsetHeight + selectedContainer.scrollTop >=
          selectedContainer.scrollHeight - 50
        : true

      this.$store.commit('sidebar/setScrollIndicatorValue', !isNotShown)
    },
    handleScrollDown() {
      const selectedContainer = document.querySelector(
        this.getSelectedContainer()
      )

      selectedContainer.scrollBy({
        top: selectedContainer.scrollHeight,
        left: 0,
        behavior: 'smooth'
      })

      /* checks again after scrolling 
      down if bottom of container */

      this.setScrollIndicatorVisibility()
    },
    checkWindowDimemsion() {
      /* In mobile mode, 
      check if page is on collapsed mode, 
      to hide scroll indicator */
      if (
        window.innerWidth > 992 ||
        this.isMobileContent ||
        this.isMobileSideBarOpen
      ) {
        this.$store.commit('sidebar/setScrollIndicatorValue', true)
      } else {
        this.$store.commit('sidebar/setScrollIndicatorValue', false)
      }
      this.setScrollIndicatorVisibility()
    },
    getSelectedContainer() {
      /* Checks dimension, decide which 
      container to use based on window width */
      if (window.innerWidth > 992 || this.mobile === null) {
        return this.desktop
      } else {
        return this.mobile
      }
    }
  }
}
</script>

<style></style>
