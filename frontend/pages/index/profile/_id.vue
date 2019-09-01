<template>
  <DetailSideBar>
    <UserDetailCard :name="getUserName()" type="none"></UserDetailCard>
    <ul>
      <li v-for="placename in user.placename_set" :key="placename.id">
        <nuxt-link :to="'/place-names/' + placename.name">{{
          placename.name
        }}</nuxt-link>
      </li>
    </ul>
    <button v-if="isAdmin()" class="btn btn-primary" @click="edit()">
      edit
    </button>
  </DetailSideBar>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import UserDetailCard from '@/components/user/UserDetailCard.vue'
import { getApiUrl } from '@/plugins/utils.js'

export default {
  components: {
    DetailSideBar,
    UserDetailCard
  },
  async asyncData({ params, $axios, store }) {
    const user = await $axios.$get(getApiUrl(`user/${params.id}/`))
    return { user }
  },

  methods: {
    isAdmin() {
      return this.user && this.user.id === this.$store.state.user.user.id
    },
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
    },
    edit() {
      console.log(this.id)
      this.$router.push({
        path: `/profile/edit/${this.user.id}`
      })
    }
  }
}
</script>

<style scoped></style>
