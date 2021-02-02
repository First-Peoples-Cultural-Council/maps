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
    desktopContainer: {
      type: String,
      default: null
    },
    mobileContainer: {
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
    const desktopContainer = document.querySelector(this.desktopContainer)
    const mobileContainer = document.querySelector(this.mobileContainer)

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

    this.$root.$on('triggerScrollVisibilityCheck', () => {
      this.setScrollIndicatorVisibility()
    })

    /* Emulate the clicking of scroll down button */
    this.$root.$on('togglehideScrollIndicator', () => {
      setTimeout(() => {
        this.checkWindowDimemsion()
      }, 250)
    })

    /* checks window width if mobile mode or desktop */
    window.addEventListener('resize', this.checkWindowDimemsion)
  },

  destroyed() {
    window.removeEventListener('resize', this.checkWindowDimemsion)
  },

  methods: {
    setScrollIndicatorVisibility() {
      /* Set store value for ScrollDown Indicator Visibility */
      const selectedContainer = document.querySelector(
        this.getSelectedContainer()
      )

      /*
        Checks if the scroll height is 
        the same as the parent container height.
        If yes, then dont show the scroll indicator anymore.
      */
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
        /* Show the scroll indicator by force */
        this.$store.commit('sidebar/setScrollIndicatorValue', true)
      } else {
        /* Hide the scroll indicator by force */
        this.$store.commit('sidebar/setScrollIndicatorValue', false)
      }
      this.setScrollIndicatorVisibility()
    },
    getSelectedContainer() {
      /* Checks dimension, decide which 
      container to use based on window width */
      if (window.innerWidth > 992 || this.mobileContainer === null) {
        return this.desktopContainer
      } else {
        return this.mobileContainer
      }
    }
  }
}
</script>

<style></style>
