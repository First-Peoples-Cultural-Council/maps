<template>
  <div class="p-2">
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
    }
  }
}
</script>

<style scoped>
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
</style>
