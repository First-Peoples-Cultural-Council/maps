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
