<template>
  <div class="language">
    <LanguageDetailCard :name="this.$route.params.lang"></LanguageDetailCard>
  </div>
</template>

<script>
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
export default {
  components: {
    LanguageDetailCard
  }
}
</script>

<style></style>
