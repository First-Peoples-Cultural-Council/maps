<template>
  <div>
    <DetailSideBar>
      <UserDetailCard name="Aaron"></UserDetailCard>
    </DetailSideBar>
  </div>
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

<style></style>
