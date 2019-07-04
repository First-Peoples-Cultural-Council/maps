<template>
  <div class="language-card">
    <Card>
      <template v-slot:header>
        <div class="language-icon-container">
          <img src="@/assets/images/language_icon.svg" alt="Language" />
        </div>
      </template>
      <template v-slot:body>
        LB
      </template>
    </Card>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'

export default {
  components: {
    Card
  }
}
</script>

<style>
.language-icon-container {
  background-color: red;
  border-radius: 50%;
}
</style>
