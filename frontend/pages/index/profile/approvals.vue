<template>
  <div>
    <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
    <div v-if="user && user.is_staff">
      <div v-if="placesToVerify && placesToVerify.length > 0">
        <h5>Places Waiting For Verification</h5>
        <div v-for="ptv in placesToVerify" :key="`ptv${ptv.id}`">
          <ul>
            <li>Name: {{ ptv.name }}</li>
          </ul>
        </div>
      </div>
      <div v-if="mediaToVerify && mediaToVerify.length > 0">
        <h5>Media Waiting For Verification</h5>
        <div v-for="mtv in mediaToVerify" :key="`mtv${mtv.id}`">
          <ul>
            <li>Name: {{ mtv.name }}</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Logo from '@/components/Logo.vue'
import { getApiUrl } from '@/plugins/utils.js'

export default {
  components: {
    Logo
  },
  computed: {
    user() {
      const user = this.$store.state.user.user
      return user
    }
  },
  async asyncData({ params, $axios, store }) {
    const placesToVerify = await $axios.$get(
      `${getApiUrl('placename/list_to_verify/')}`
    )

    const mediaToVerify = await $axios.$get(
      `${getApiUrl('media/list_to_verify/')}`
    )
    return {
      placesToVerify,
      mediaToVerify
    }
  }
}
</script>
<style></style>
