<template>
  <div class="error-container">
    <div class="error-main-container">
      <img src="@/assets/images/splashscreen/hero_img.svg" />
      <h1>Page not found</h1>
      <p class="error-description">
        We're sorry, the page you requested could not be found. If you didn't
        find what you were looking for, please contact us at
        <a :href="'mailto:info@fpcc.ca?subject=FPCC Map: Categories Request'"
          >info@fpcc.ca</a
        >.
      </p>
      <a href="#" @click="returnToHome">Go Back to Home</a>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {}
  },
  methods: {
    returnToHome() {
      let nextPath = ''
      const firstPath = window.location.pathname.split('/')[1]

      if (firstPath === 'place-names') {
        nextPath = 'heritages'
      } else if (firstPath === 'content') {
        nextPath = 'languages'
      } else if (
        firstPath !== 'art' ||
        firstPath !== 'heritages' ||
        firstPath !== 'languages' ||
        firstPath === 'place-names' ||
        firstPath === 'content'
      ) {
        nextPath = ''
      } else {
        nextPath = firstPath
      }
      window.location = `/${nextPath}`
    }
  }
}
</script>

<style lang="scss">
.error-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 9999999;
  overflow: hidden;
  background: #fff;
}

.error-main-container {
  margin: auto auto;
  width: fit-content;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  img {
    width: 250px;
    height: 250px;
  }

  h4 {
    font-family: 'Lato', sans-serif;
    font-size: 2em;
    font-weight: 800;
  }

  .error-description {
    width: 60%;
    text-align: center;
  }
}
</style>
