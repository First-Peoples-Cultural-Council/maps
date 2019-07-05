<template>
  <div class="language-card">
    <Card>
      <template v-slot:header>
        <div class="language-icon-container">
          <img src="@/assets/images/language_icon.svg" alt="Language" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              Languages
            </h5>
            <h5
              class="font-09 m-0 p-0 color-gray text-uppercase font-weight-bold"
            >
              Nłeʔkepmxcín
            </h5>
          </div>
          <div><CardBadge content="Pronounce"></CardBadge></div>
        </div>
      </template>
    </Card>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
import CardBadge from '@/components/CardBadge.vue'
export default {
  components: {
    Card,
    CardBadge
  }
}
</script>

<style>
.language-icon-container {
  background-color: red;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.language-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
</style>
