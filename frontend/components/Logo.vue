<template>
  <div
    class="logo cursor-pointer h-100 logo-parent"
    @click.prevent="handleLogoClick"
  >
    <div v-if="logoAlt === 1 || logoAlt === 2" class="p-3 logo-container">
      <img
        src="../assets/images/symbol@2x.png"
        alt="Language Map Of British Columbia"
        height="auto"
        width="50"
        class="d-inline-block mb-2"
      />
      <div
        style="color: white; font-size: 1.2em;"
        class="d-inline-block font-weight-bold ml-3"
      >
        First Peoples'
        <p>Map of B.C.</p>
      </div>
    </div>
    <div v-else-if="logoAlt === 3" class="style-two-container">
      <img
        src="@/assets/images/symbol.png"
        alt="Language Map Of British Columbia"
      />
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
        this.$router.push({ path: '/languages' })
        this.$root.$emit('resetMap')
      }
    }
  }
}
</script>

<style>
.logo-parent {
  background: url('../assets/images/logo_background.png');
}
.logo-container {
  display: flex;
  align-items: center;
  background-size: cover;
  background-position: center;
  text-transform: uppercase;
  font: Medium 20px/22px;
  letter-spacing: 1px;
}
.logo-container p {
  margin: 0;
  font-size: 0.7em;
  letter-spacing: 0.65px;
  font: Medium 13px/22px;
}
.logo img {
  display: inline-block;
  height: auto;
}
.style-two-container {
  text-align: center;
}
</style>
