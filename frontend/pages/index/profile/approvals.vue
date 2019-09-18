<template>
  <div>
    <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
    <div v-if="user && user.is_staff">
      <div v-if="placesToVerify && placesToVerify.length > 0">
        <h5>Places Waiting For Verification</h5>
        <div v-for="ptv in placesToVerify" :key="`ptv${ptv.id}`">
          <ul>
            <li>Name: {{ ptv.name }}</li>
            <li>
              <b-button @click="handlePlace($event, ptv, { verify: true })"
                >Verify</b-button
              >
            </li>
            <li>
              <b-button @click="handlePlace($event, ptv, { reject: true })"
                >Reject</b-button
              >
            </li>
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
import { getApiUrl, getCookie } from '@/plugins/utils.js'

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
  },
  methods: {
    async handlePlace(e, ptv, { verify, reject }) {
      const mode = verify ? 'verify' : 'reject'
      const result = await this.$axios.$patch(
        `${getApiUrl(`placename/${ptv.id}/${mode}/`)}`,
        {
          status_reason: mode
        },
        {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        }
      )
      console.log('Result', result)
      if (
        result &&
        (result.message === 'Verified!' || result.message === 'Rejected!')
      ) {
        this.placesToVerify = this.placesToVerify.filter(p => p.id !== ptv.id)
      }
    }
  }
}
</script>
<style></style>
