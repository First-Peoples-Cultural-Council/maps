<template>
  <div class="loading-container">
    <img src="@/assets/images/splashscreen/hero_img.svg" alt="Loading" />
    Loading, Please Wait...
  </div>
</template>

<script>
export default {
  mounted() {
    this.$root.$emit('closeLoading')
  }
}
</script>

<style lang="scss">
.loading-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 500000;
  overflow: hidden;
  background: #fff;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font: Bold 16px/20px Proxima Nova;

  img {
    width: 200px;
    height: 200px;
    animation: pulse 1s infinite;
  }
}

@keyframes pulse {
  0% {
    transform: scale(0.9);
  }

  70% {
    transform: scale(1);
  }

  100% {
    transform: scale(0.9);
  }
}
</style>
