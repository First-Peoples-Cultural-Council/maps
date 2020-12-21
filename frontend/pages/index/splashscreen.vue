<template>
  <div class="splash-main-container">
    <div class="splash-content-container">
      <div class="splash-header">
        <div class="header-logo" @click="redirectToHome">
          <img
            class="fpcc-logo"
            src="../../assets/images/symbol@2x.png"
            alt="Language Map Of British Columbia"
          />
          <img
            class="fpcc-logo-text hide-mobile"
            src="../../assets/images/splashscreen/fpcc_logo2x.png"
            alt="Language Map Of British Columbia"
          />
          <!-- <span class="mt-3 hide-mobile">
            First Peoples'
            <p>CULTURAL COUNCIL</p>
          </span> -->
        </div>

        <img
          src="../../assets/images/splashscreen/stars_dark.svg"
          alt="Language Map Of British Columbia"
          class="fpcc-star-dark"
        />
      </div>
      <div class="splash-detail-content">
        <div class="splash-detail-container">
          <div class="splash-detail">
            <span class="fpcc-title">First Peoples' Map of B.C.</span>
            <img
              src="../../assets/images/splashscreen/zigzag.svg"
              alt="Language Map Of British Columbia"
              class="mt-4 mb-4"
            />
            <span class="fpcc-description">
              Explore and contribute to the interactive map of the Indigenous
              Languages, Arts and Heritage in B.C.
            </span>
          </div>
          <img
            src="../../assets/images/splashscreen/hero_img.svg"
            alt="Language Map Of British Columbia"
            class="fpcc-splash-img"
          />
        </div>

        <div class="splash-nav">
          <img
            src="../../assets/images/splashscreen/stars_light.svg"
            alt="Language Map Of British Columbia"
            class="fpcc-star-light"
          />
          <div
            v-for="nav in getNavigationList()"
            :key="nav.title"
            class="splash-navigation-btn"
          >
            <div class="splash-btn" @click="redirectToPath(nav.path)">
              {{ nav.title }}
            </div>
            <span class="splash-description hide-mobile">
              {{ nav.description }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showSplashscreen: false
    }
  },
  methods: {
    getNavigationList() {
      return [
        {
          title: 'Languages',
          description:
            'Discover language regions, place names, audio and more!',
          path: '/languages'
        },
        {
          title: 'Arts',
          description:
            'Explore Indigenous arts in B.C. in this living interactive map.',
          path: '/art'
        },
        {
          title: 'Heritages',
          description: 'Learn about the diverse Indigenous heritage of B.C.',
          path: '/heritages'
        }
      ]
    },
    redirectToPath(path) {
      this.closeSplashscreen()
      this.$router.push({
        path
      })
    },
    redirectToHome() {
      this.closeSplashscreen()
      this.$router.push({
        path: '/languages'
      })
    },
    closeSplashscreen() {
      this.$root.$emit('closeSplashscreen')
    }
  }
}
</script>

<style lang="scss">
.splash-main-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  overflow-x: hidden;
  z-index: 9999999;
  background-color: rgba(0, 0, 0, 0.8);

  .splash-content-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100vw;
    height: 100vh;
    overflow-y: auto;
    box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
    background-image: url('../../assets/images/splashscreen/green_greetings_1920.svg');
    background-size: auto 100%;
    background-position: center center;
    background-color: #00343b;

    .splash-header {
      position: relative;
      height: 100px;
      width: 100%;
      background-image: url('../../assets/images/splashscreen/white_greetings_1920.svg');
      background-color: #fff;

      .header-logo {
        display: flex;
        align-items: center;
        margin-left: 5%;
        color: #a32720;
        height: 100%;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        cursor: pointer;

        .fpcc-logo {
          display: none;
          width: 70px;
          height: 100%;
          padding: 1em 0;
          object-fit: contain;
          margin-right: 0.75em;
        }

        .fpcc-logo-text {
          width: 250px;
        }

        span {
          font: Bold 15px/18px Proxima Nova;
          font-weight: 800;
          font-size: 1.2em;
        }

        p {
          margin-top: 0.25em;
          color: #000;
          font-size: 0.5em;
        }
      }

      .fpcc-star-dark {
        position: absolute;
        right: 5%;
        top: 75%;
      }
    }

    .splash-detail-content {
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: center;
      min-height: auto;
      margin: auto auto;
      width: 50%;
      color: #fff;
      padding: 1em 0;

      .splash-detail-container {
        display: flex;

        .splash-detail {
          display: flex;
          flex-direction: column;
          align-items: flex-start;
          position: relative;
          font-family: 'Faustina', serif;

          .fpcc-title {
            font-size: 34px;
            font-weight: 500;
          }

          .fpcc-description {
            font-size: 20px;
            font-weight: 500;
            width: 50%;
          }
        }
      }

      .splash-nav {
        position: relative;
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        margin-top: 3.5em;

        .fpcc-star-light {
          position: absolute;
          left: -5%;
          top: -15%;
        }

        .splash-navigation-btn {
          flex: 0 0 30%;
          display: flex;
          align-items: center;
          flex-direction: column;
          z-index: 50;
          cursor: pointer;
          margin-bottom: 1em;

          .splash-btn {
            width: 180px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.8em;
            background: #00343b;
            border-radius: 2em;
            border: 2px solid #b47a2b;
            font: Regular 16px/20px Proxima Nova;
            margin-bottom: 0.5em;
            text-transform: uppercase;
            letter-spacing: 1px;
          }

          .splash-description {
            font: Regular 16px/20px Proxima Nova;
            text-align: center;
          }

          &:hover {
            .splash-btn {
              transform: scale(1.05);
              border: 2px solid #a32720;
            }
          }
        }
      }
    }
  }
}

@media screen and (min-width: 993px) and (max-width: 1300px) {
  .splash-content-container {
    background-image: url('../../assets/images/splashscreen/green_greetings_1280.svg') !important;
  }
  .splash-header {
    background-image: url('../../assets/images/splashscreen/white_greetings_1280.svg') !important;
  }

  .splash-detail-content {
    width: 60% !important;
  }

  .fpcc-splash-img {
    width: 200px;
    height: 200px;
  }
}

@media screen and (max-width: 992px) {
  .splash-main-container:not(:root:root) {
    overflow-y: auto !important;
  }

  .splash-main-container {
    transform: translateZ(0);
    -webkit-transform: translateZ(0);
    overflow-y: auto;
  }
  .splash-content-container {
    background-image: url('../../assets/images/splashscreen/green_greetings_mobile.svg') !important;
    width: 100vw !important;
    height: 100vh !important;
    overflow-y: auto;
  }

  .splash-header {
    height: 80px !important;
    background-image: url('../../assets/images/splashscreen/white_greetings_mobile.svg') !important;

    .header-logo {
      margin-left: 2% !important;

      .fpcc-logo {
        display: block !important;
      }
    }
  }

  .splash-detail-content {
    width: 80% !important;
    height: auto !important;
  }

  .splash-detail-container {
    flex-direction: column-reverse;
    justify-content: center;
    align-items: center;
  }

  .fpcc-splash-img {
    margin-bottom: 1em;
    width: 125px;
    height: 125px;
  }

  .splash-detail {
    align-items: center !important;
    height: auto;

    .fpcc-title {
      font-size: 1.2em !important;
      text-align: center;
    }
    .fpcc-description {
      font-size: 1em !important;
    }

    .fpcc-description {
      text-align: center;
      width: 100% !important;
    }
  }

  .splash-nav {
    width: 100%;
    justify-content: center !important;

    .splash-navigation-btn {
      flex: 0 0 100% !important;

      .splash-btn {
        font-size: 0.8em !important;
      }
    }
  }
}
</style>
