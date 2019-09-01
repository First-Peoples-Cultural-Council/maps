<template>
  <DetailSideBar>
    Hello
    <UserDetailCard name="Sample User" type="none"></UserDetailCard>
  </DetailSideBar>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import UserDetailCard from '@/components/user/UserDetailCard.vue'

export default {
  components: {
    DetailSideBar,
    UserDetailCard
  }
}
</script>

<style scoped></style>

export default { async asyncData({ params, $axios, store }) { const user = await
$axios.$get(getApiUrl(`user/${params.id}/`)) return user } }
