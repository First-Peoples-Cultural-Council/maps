<template>
  <div class="splash-main-container" @click.prevent="closeSplashscreen">
    <div class="splash-content-container" @click.stop="doNothing">
      <div class="splash-header">
        <div class="header-logo">
          <img
            src="../assets/images/symbol@2x.png"
            alt="Language Map Of British Columbia"
          />
          <span class="mt-3">
            First Peoples'
            <p>Map of B.C.</p>
          </span>
        </div>

        <img
          src="../assets/images/splashscreen/stars_dark.svg"
          alt="Language Map Of British Columbia"
          class="fpcc-star-dark"
        />
      </div>
      <div class="splash-detail-content">
        <div class="splash-detail">
          <span class="fpcc-title">First Peoples' Map of B.C.</span>
          <img
            src="../assets/images/splashscreen/zigzag.svg"
            alt="Language Map Of British Columbia"
            class="mt-4 mb-4"
          />
          <span class="fpcc-description">
            Explore and contribute to the interactive map of the Indigenous
            Languages, Arts and Heritage in B.C.
          </span>
          <img
            src="../assets/images/splashscreen/hero_img.svg"
            alt="Language Map Of British Columbia"
            class="fpcc-splash-img"
          />
        </div>
        <div class="splash-nav">
          <img
            src="../assets/images/splashscreen/stars_light.svg"
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
            <span class="splash-description">
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
      this.$router.push({
        path
      })
      this.closeSplashscreen()
    },
    closeSplashscreen() {
      this.$root.$emit('closeSplashscreen')
    },
    doNothing() {}
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
  overflow-y: hidden;
  overflow-x: hidden;
  z-index: 500000;
  background-color: rgba(0, 0, 0, 0.8);

  .splash-content-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 90vw;
    height: 90vh;
    border-radius: 0.25em;
    box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
    background: url('../assets/images/splashscreen/greetings_green.svg');
    background-color: #00343b;

    .splash-header {
      position: relative;
      height: 10%;
      width: 100%;
      background: url('../assets/images/splashscreen/greetings_white.svg');
      background-color: #fff;

      .header-logo {
        display: flex;
        align-items: center;

        margin-left: 2%;
        color: #a32720;
        height: 100%;
        font: Bold 15px/18px Proxima Nova;
        font-size: 1.2em;
        text-transform: uppercase;
        letter-spacing: 1.5px;

        img {
          width: 70px;
          height: 70px;
          object-fit: contain;
          margin-right: 1em;
        }

        p {
          margin-top: 0.25em;
          color: #000;
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
      height: 90%;
      width: 50%;
      color: #fff;

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
          width: 37.5%;
        }

        .fpcc-splash-img {
          position: absolute;
          top: -25%;
          right: 5%;
        }
      }

      .splash-nav {
        position: relative;
        display: flex;
        flex-wrap: wrap;
        margin-top: 3.5em;

        .fpcc-star-light {
          position: absolute;
          left: -5%;
          top: -15%;
        }

        .splash-navigation-btn {
          flex: 0 0 33.33%;
          display: flex;
          flex-direction: column;
          padding: 0 1.5em;
          z-index: 50;
          cursor: pointer;
          margin-bottom: 1em;

          .splash-btn {
            padding: 0.8em;
            text-align: center;
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
            padding: 0 1.75em;
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

@media screen and (max-width: 1300px) {
  .splash-main-container {
    .splash-detail-content {
      width: 80% !important;
    }
  }
}

@media screen and (max-width: 992px) {
  .splash-main-container {
    border: 1px solid green;
  }
}
</style>
