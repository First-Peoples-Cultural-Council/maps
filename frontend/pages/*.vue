<template>
  <div></div>
</template>

<script>
import moment from 'moment'
import { encodeFPCC } from '@/plugins/utils.js'

export default {
  computed: {
    redirectLink() {
      const pathMatch = this.$route.params.pathMatch

      if (pathMatch.startsWith('node') || pathMatch.startsWith('fphlccmap')) {
        // Redirect to home for these paths
        return '/'
      } else if (pathMatch.startsWith('cna')) {
        // If this is a CNA back-link, parse data then redirect
        const cnaData = pathMatch.split('/')

        // Only get the CNA path - basically ignoring the `/cna` part
        const cnaArray =
          cnaData && cnaData.length > 1 ? cnaData[1].split('-') : null

        // Identify which part of the string is the date so that we could exclude it
        let cnaMaxLength = null
        for (let i = 1; i < cnaArray.length; i++) {
          const cnaDate = cnaArray.slice(i, i + 3).join('-')

          // Here we identify where the date starts. This is necessary because
          // there are cases where the date is not the last 3 strings put together
          if (this.isDate(cnaDate)) {
            cnaMaxLength = i
            break
          }
        }

        // Remove the leading `cna` and date
        const cna = cnaMaxLength
          ? cnaArray.slice(1, cnaMaxLength).join(' ')
          : null

        // Check if cna is not null
        // Redirect to community if it is not null. Else, redirect to home
        if (cna) {
          return `/content/${encodeFPCC(cna)}`
        } else {
          return '/'
        }
      } else {
        // If there is an extension that's not included in the format above,
        // convert it into a search query in the home's Search Bar
        const searchParameter = this.$route.params.pathMatch.replace('_', ' ')
        return `/?search=${searchParameter}`
      }
    }
  },
  methods: {
    isDate(date) {
      return moment(date, 'YYYY-MM-DD', true).isValid()
    }
  },
  head() {
    return {
      meta: [
        {
          hid: 'redirect',
          name: 'redirect',
          'http-equiv': 'refresh',
          content: `0;URL=${this.redirectLink}`
        }
      ]
    }
  }
}
</script>
