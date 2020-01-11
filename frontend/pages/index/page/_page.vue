<template>
  <div class="p-2">
    <div v-html="$md.render(tos.content)"></div>
  </div>
</template>
<script>
import { getApiUrl } from '@/plugins/utils.js'

export default {
  async asyncData({ params, $axios, store }) {
    const result = await $axios.$get(
      `${getApiUrl(`page/?timestamp=${new Date().getTime()}`)}`
    )
    const tos = result.find(r => r.name === params.page)
    return {
      tos
    }
  }
}
</script>
<style></style>
