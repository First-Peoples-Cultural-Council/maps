<template>
  <div
    v-if="isScrollDownBtnVisible && isMainPages && !hideIndicator"
    class="scroll-indicator-container"
  >
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
    return {
      hideIndicator: false
    }
  },

  computed: {
    isScrollDownBtnVisible() {
      return this.$store.state.sidebar.showScrollIndicator
    },
    isMainPages() {
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
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    isMobileSideBarOpen() {
      return this.$store.state.responsive.isMobileSideBarOpen
    }
  },

  mounted() {
    const innerToggle = document.querySelector('#innerToggleHead')
    const getDesktopContainer = document.querySelector(this.desktop)
    const getMobileContainer = document.querySelector(this.mobile)

    if (getDesktopContainer) {
      getDesktopContainer.addEventListener('scroll', e => {
        if (innerToggle) {
          if (this.scrollTop > '25') {
            innerToggle.classList.add('position-fixed')
          } else {
            innerToggle.classList.remove('position-fixed')
          }
        }

        this.isScrollIndicatorVisible()
      })
    }

    if (getMobileContainer) {
      getMobileContainer.addEventListener('scroll', e => {
        this.isScrollIndicatorVisible()
      })
    }

    // checks window width if mobile mode or desktop
    window.addEventListener('resize', this.checkWindowDimemsion)

    this.$root.$on('triggerScrollVisibilityCheck', () => {
      this.isScrollIndicatorVisible()
    })

    this.$root.$on('toggleHideIndicator', () => {
      setTimeout(() => {
        this.checkWindowDimemsion()
      }, 250)
    })
  },

  methods: {
    isScrollIndicatorVisible() {
      const selectedContainer = document.querySelector(
        this.getSelectedContainer()
      )
      const isNotShown = selectedContainer
        ? selectedContainer.offsetHeight + selectedContainer.scrollTop >=
          selectedContainer.scrollHeight - 50
        : true

      // set store value
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

      // checks again after scrolling down
      this.isScrollIndicatorVisible()
    },
    checkWindowDimemsion() {
      if (
        window.innerWidth > 992 ||
        this.mobileContent ||
        this.isMobileSideBarOpen
      ) {
        this.hideIndicator = false
        this.isScrollIndicatorVisible()
      } else {
        this.hideIndicator = true
      }
    },
    getSelectedContainer() {
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
