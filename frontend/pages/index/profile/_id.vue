<template>
  <DetailSideBar>
    <UserDetailCard :name="getUserName()" type="none"></UserDetailCard>
    <ul>
      <li v-for="placename in user.placename_set" :key="placename.id">
        <nuxt-link :to="'/place-names/' + encodeFPCC(placename.name)">{{
          placename.name
        }}</nuxt-link>
      </li>
    </ul>
  </DetailSideBar>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import UserDetailCard from '@/components/user/UserDetailCard.vue'
import { getApiUrl, encodeFPCC } from '@/plugins/utils.js'

export default {
  components: {
    DetailSideBar,
    UserDetailCard
  },
  async asyncData({ params, $axios, store }) {
    const user = await $axios.$get(getApiUrl(`user/${params.id}/`))
    return { user }
  },

  mounted() {
    console.log(this.user)
  },

  methods: {
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
    },
    encodeFPCC
  }
}
</script>

<style scoped></style>
