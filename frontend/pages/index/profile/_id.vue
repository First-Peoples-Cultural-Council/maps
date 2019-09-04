<template>
  <DetailSideBar>
    <UserDetailCard :name="getUserName()" type="none"></UserDetailCard>
    <section class="ml-2 mr-2 mt-2">
      <div v-if="user.languages && user.languages.length > 0">
        <h5 class="color-gray font-08 text-uppercase font-weight-bold mb-0">
          Spoken Languages
        </h5>
        <LanguageDetailBadge
          v-for="lang in user.languages"
          :key="`badge${lang.id}`"
          :content="lang.name"
          class="mr-2 cursor-pointer"
          @click.native="
            $router.push({ path: '/languages/' + encodeFPCC(lang.name) })
          "
        ></LanguageDetailBadge>
      </div>
      <div v-if="user.communities && user.communities.length > 0" class="mt-3">
        <h5 class="color-gray font-08 text-uppercase font-weight-bold mb-0">
          Communities
        </h5>
        <LanguageDetailBadge
          v-for="comm in user.communities"
          :key="`badge${comm.id}`"
          :content="comm.name"
          class="mr-2 cursor-pointer"
          @click.native="
            $router.push({ path: '/content/' + encodeFPCC(comm.name) })
          "
        ></LanguageDetailBadge>
      </div>
    </section>
    <ul>
      <li v-for="placename in user.placename_set" :key="placename.id">
        <nuxt-link :to="'/place-names/' + encodeFPCC(placename.name)">{{
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
import { getApiUrl, encodeFPCC } from '@/plugins/utils.js'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'

export default {
  components: {
    DetailSideBar,
    UserDetailCard,
    LanguageDetailBadge
  },
  async asyncData({ params, $axios, store }) {
    console.log('From State', 'Test')
    const user = await $axios.$get(getApiUrl(`user/${params.id}/`))
    return { user }
  },
  mounted() {
    console.log('mounted, user=', this.user)
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
    },
    encodeFPCC
  }
}
</script>

<style scoped></style>
