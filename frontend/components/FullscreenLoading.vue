<template>
  <div class="loading-container">
    <div class="loading-inner">
      <img src="@/assets/images/splashscreen/hero_img.svg" alt="Loading" />
      <span> Loading. Please Wait.</span>
    </div>
  </div>
</template>

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
  font-weight: 800;
  font-size: 16px;

  .loading-inner {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    justify-content: center;
    img {
      width: 210px;
      height: 210px;
      animation: pulse 1s infinite;
    }

    span {
      margin-left: 1em;
      width: fit-content;
    }
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
