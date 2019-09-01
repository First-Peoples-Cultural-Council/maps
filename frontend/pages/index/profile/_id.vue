<template>
  <DetailSideBar>
    <UserDetailCard :name="getUserName()" type="none"></UserDetailCard>
    <ul>
      <li :key="placename.id" v-for="placename in user.placename_set">
        <nuxt-link :to="'/place-names/' + placename.name">{{
          placename.name
        }}</nuxt-link>
      </li>
    </ul>
  </DetailSideBar>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import UserDetailCard from '@/components/user/UserDetailCard.vue'
import { getApiUrl } from '@/plugins/utils.js'

export default {
  async asyncData({ params, $axios, store }) {
    const user = await $axios.$get(getApiUrl(`user/${params.id}/`))
    return { user }
  },

  components: {
    DetailSideBar,
    UserDetailCard
  },

  mounted() {
    console.log(this.user)
  },

  methods: {
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
    }
  }
}
</script>

<style scoped></style>
