<template>
  <div v-if="content" :class="{ 'help-page-content': isHelpPage }">
    <header v-if="isHelpPage" class="mobile-help-header">
      <nuxt-link to="/" class="help-back-link">
        <img src="@/assets/images/return_icon_hover.svg" alt="" />
        <span>Back to map</span>
      </nuxt-link>
      <h1>Help</h1>
    </header>
    <div class="nav-header cursor-pointer p-2" @click.prevent="handleNavLink">
      <img
        src="@/assets/images/symbol@2x.png"
        alt="Language Map Of British Columbia"
        height="auto"
        width="50"
        class="d-inline-block mb-2"
      />
      <div
        style="color: #632015; font-size: 1.2em;"
        class="d-inline-block font-weight-bold ml-3"
      >
        First Peoples' Map of B.C.
      </div>
    </div>
    <hr />
    <div class="page-content-container">
      <div
        class="fpcc-card-more"
        @click.prevent="handleReturn"
        @mouseover.prevent="handleMouseOver"
        @mouseleave="handleMouseLeave"
      >
        <img
          v-if="!hover"
          class="ml-1"
          src="@/assets/images/return_icon_hover.svg"
          alt="Go"
        />
        <img
          v-else
          class="ml-1"
          src="@/assets/images/return_icon_hover.svg"
          alt="Go"
        />
        <span class="ml-1 font-weight-bold">Return</span>
      </div>
      <div v-html="content"></div>
    </div>
  </div>
</template>

<script>
import { getApiUrl } from '@/plugins/utils.js'
const myMD = require('markdown-it')({
  html: true
})
myMD.use(require('markdown-it-container'), 'accordion', {
  validate(params) {
    return params.trim().match(/^accordion\s+(.*)$/)
  },

  render(tokens, idx) {
    const m = tokens[idx].info.trim().match(/^accordion\s+(.*)$/)

    if (tokens[idx].nesting === 1) {
      // opening tag
      return (
        '<details><summary><b>' +
        myMD.utils.escapeHtml(m[1]) +
        '</b></summary>\n'
      )
    } else {
      // closing tag
      return '</details>\n'
    }
  }
})
export default {
  computed: {
    isHelpPage() {
      return this.$route.params.page === 'how-to-use'
    }
  },
  async asyncData({ params, $axios, store }) {
    const result = await $axios.$get(
      `${getApiUrl(`page/?timestamp=${new Date().getTime()}`)}`
    )
    const currentPage = result.find(r => r.name === params.page)
    return {
      hover: false,
      content: myMD.render(currentPage.content)
    }
  },
  methods: {
    handleReturn() {
      if (this.server) {
        this.$router.push({
          path: '/'
        })
      } else {
        this.$router.go(-1)
      }
    },
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    },
    handleNavLink() {
      this.$store.commit('mapinstance/setForceReset', true)
      if (this.$route.name === 'index') {
        this.$root.$emit('resetMap')
        this.$store.commit('mapinstance/setForceReset', false)
      } else {
        this.$router.push({ path: '/' })
      }
    }
  }
}
</script>

<style scoped>
.mobile-help-header {
  display: none;
}

@media (max-width: 992px) {
  .help-page-content > .nav-header,
  .help-page-content > hr,
  .help-page-content .fpcc-card-more {
    display: none;
  }

  .mobile-help-header {
    display: block;
    padding: 1em 1.5em;
    border-bottom: 1px solid #dedcda;
    margin-bottom: 1.5em;
  }

  .mobile-help-header h1 {
    font-size: 24px;
    margin: 0.75em 0 0;
  }

  .help-back-link {
    display: inline-flex;
    align-items: center;
    min-height: 44px;
    padding: 0.5em 0.75em;
    gap: 0.5em;
    background: #632015;
    color: white;
    border-radius: 4px;
    font-size: 14px;
  }

  .help-back-link img {
    width: 15px;
    height: 15px;
  }

  .help-page-content .page-content-container {
    overflow-wrap: anywhere;
    line-height: 1.6;
  }
}

.community-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #c46156;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-radius: 0.5em;
  margin-bottom: 1em;
  margin-top: 1em;
  cursor: pointer;
}

.page-content-container {
  padding: 0 1.5em 1em 1.5em;
}

.fpcc-card-more {
  padding: 0.3em;
  font-size: 0.7em;
  color: white;
}

.fpcc-card-more:hover {
  color: white;
  background-color: #454545;
}

.fpcc-card-more img {
  display: inline-block;
  width: 15px;
  height: 15px;
}
.logo img {
  display: inline-block;
  height: auto;
}
.nav-header {
  padding-top: 0.5em;
  padding-left: -0.5em;
}
</style>
