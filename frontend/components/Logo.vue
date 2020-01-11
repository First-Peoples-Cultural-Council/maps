<template>
  <div class="logo cursor-pointer h-100" @click.prevent="handleLogoClick">
    <div v-if="logoAlt === 1">
      <img
        src="../assets/images/symbol_text_background.png"
        alt="First Peoples' Map of B.C."
      />
    </div>
    <div v-else-if="logoAlt === 2" class="style-two-container">
      <img
        src="../assets/images/symbol_text.png"
        alt="First Peoples' Map of B.C."
      />
    </div>
    <div v-else-if="logoAlt === 3" class="style-two-container">
      <img src="../assets/images/symbol.png" alt="First Peoples' Map of B.C." />
    </div>
    <div v-else-if="logoAlt === 4" class="h-100">
      <img
        src="@/assets/images/symbol@2x.png"
        alt="Menu"
        class="mobile-logo h-100"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    logoAlt: {
      default: 1,
      type: Number
    }
  },
  methods: {
    handleLogoClick() {
      this.$store.commit('mapinstance/setForceReset', true)
      if (this.$route.name === 'index') {
        this.$root.$emit('resetMap')
        this.$store.commit('mapinstance/setForceReset', false)
      } else {
        this.$router.push({ path: '/' })
      }
    }
  }
}
</script>

<style>
.logo img {
  display: inline-block;
  height: auto;
}
.style-two-container {
  text-align: center;
}
</style>
